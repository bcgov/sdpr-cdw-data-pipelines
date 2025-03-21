import oracledb
from utils.win_reg_for_ora import WinRegForOra
import pandas as pd
import polars as pl
import logging
import os
from dotenv import load_dotenv
load_dotenv()

logger = logging.getLogger('__main__.' + __name__)


class OracleDB:
    """
    A class for managing connections and operations on an Oracle database.

    This class retrieves credentials based on the OS environment and provides methods to 
    execute queries, manage transactions, and perform CRUD operations on Oracle database tables.

    Attributes:
        conn_str_key_endpoint (str): The last part of the Windows Registry key that yields the Oracle connection strings.
        credentials (dict[str, str], optional): A dictionary containing additional credentials.
    """

    # Class Env Vars
    # the directory containing tnsnames.ora
    tnsnames_config_dir = os.getenv('TNSNAMES_CONFIG_DIR')

    def __init__(
        self, 
        conn_str_key_endpoint: str,
    ) -> None:
        """
        Initializes the OracleDB instance.
        Designed to connect to the DB using connection string key endpoint in Windows Registry.
        However, conn_str_key_endpoint=None will allow the user to manually connect using
        the 'connect' function after initializing an OracleDB object:

            db = OracleDB()
            db.connect(...)

        Args:
            conn_str_key_endpoint (str): The endpoint for retrieving the Oracle connection string from the registry.
        
        Raises:
            DatabaseException: If a connection to the database cannot be established.
        """
        if conn_str_key_endpoint is not None:
            logger.info(fr'connecting to Oracle using connection string in WinReg sub-key: {conn_str_key_endpoint}')
            self.connect_w_win_reg(conn_str_key_endpoint=conn_str_key_endpoint)
        else:
            msg = 'Since conn_str_key_endpoint is None, use the connect function to connect to the DB.'
            logger.debug(msg)

    def connect_w_win_reg(self, conn_str_key_endpoint: str) -> None:
        """
        Creates a database connection and opens a cursor using a connection string in the
        Windows registry.

        Args:
            conn_str_key_endpoint (str): The endpoint for retrieving the Oracle connection string from the registry.
        """
        reg = WinRegForOra()
        db_credentials = reg.get_oracle_conn_dict(conn_str_key_endpoint)
        self.user = db_credentials["user"]
        pwd = db_credentials["pwd"]
        self.service_name = db_credentials["service_name"]
        self.conn = oracledb.connect(
            user=self.user,
            password=pwd,
            dsn=fr'{self.service_name}.world',
            config_dir=self.tnsnames_config_dir,
        )
        logger.info("connected to: " + self.service_name + "." + self.user)
        self.cursor = self.conn.cursor()
        logger.info("cursor opened")

    def connect(
        self,
        user: str = None, 
        password: str = None, 
        host: str = None, 
        port: str = None, 
        service_name: str = None,
    ) -> None:
        """
        Creates a connection to an Oracle DB and opens a cursor.
        """
        self.user = user
        self.service_name = service_name
        self.conn = oracledb.connect(
            user=user,
            password=password,
            host=host,
            port=port,
            service_name=service_name
        )
        logger.info("connected to: " + self.service_name + "." + self.user)
        self.cursor = self.conn.cursor()
        logger.info("cursor opened")

    def open_cursor(self):
        """
        Opens a new cursor for the database connection.

        Returns:
            Cursor: The opened cursor for executing SQL statements.
        """
        self.cursor = self.conn.cursor()
        logger.info("cursor opened")
        return self.cursor

    def close_cursor(self) -> None:
        """
        Closes the current cursor.
        """
        self.cursor.close()
        logger.info("cursor closed")

    def commit(self) -> None:
        """
        Commits the current transaction to the database.
        """
        self.conn.commit()
        logger.debug("committed db changes")

    def close_connection(self) -> None:
        """
        Closes the database connection.
        """
        self.conn.close()
        logger.info("connection closed")

    def commit_and_close(self) -> None:
        """
        Commits the current transaction and closes the database connection.
        """
        self.close_cursor()
        self.commit()
        self.close_connection()

    def execute(self, statement: str, parameters=None) -> None:
        """
        Executes a single SQL statement.

        Args:
            statement (str): The SQL statement to execute.
            parameters (optional): The parameters to bind to the statement.
        """
        logger.debug(f'executing "{statement}" with {parameters}')
        self.cursor.execute(statement, parameters)

    def execute_with_exception_handling(
        self, statement: str, parameters=None, ignore_all_db_errors=False, ora_codes_to_ignore=None
        ):
        """ 
        Executes an SQL statement with exception handling options

        Args:
            statement (str): an SQL statement.
            parameters: parameters to pass to the sql statement.
            ignore_all_db_errors (bool): continues to the next statement whenever
                a DB error is encountered if True.
            ora_codes_to_ignore (list[str]): a list of ora error codes of the form
                ['ORA-XXXXX',...] to be ignored if encountered.
        """
        if ignore_all_db_errors:
            try:
                self.execute(statement, parameters=parameters)
            except oracledb.Error as e:
                error_obj, = e.args
                message = error_obj.message
                logger.warning(f'the following Oracle Error was ignored: {message}')
                return
        elif ora_codes_to_ignore is not None:
            try:
                self.execute(statement, parameters=parameters)
            except oracledb.Error as e:
                error_obj, = e.args
                code = error_obj.full_code
                message = error_obj.message
                if code in ora_codes_to_ignore:
                    logger.warning(f'the following Oracle Error was ignored: {message}')
                    return
                else:
                    raise e
        else:
            self.execute(statement, parameters=parameters)

    def execute_many(self, statement: str, parameters) -> None:
        """
        Executes a single SQL statement multiple times with different parameters.

        Args:
            statement (str): The SQL statement to execute.
            parameters: The parameters to bind to the statement for each execution.

        Raises:
            DatabaseException: If an error occurs during execution.
            Exception: For any unhandled exceptions.
        """
        # try:
        logger.debug(f'executing many "{statement}"')
        self.cursor.executemany(statement, parameters)

    def run_sql_script(
        self, 
        sql_file_path, 
        parameters=None, 
        ignore_all_db_errors=False,
        ora_codes_to_ignore=None
    ):
        """ 
        Executes SQL statements in the SQL script at sql_file_path 

        Args:
            sql_file_path (str): The path to the sql file.
            parameters: Parameters to pass to the sql statement. Only relevant if
                if all parameters are referenced in each statement.
            ignore_all_db_errors (bool): continues to the next statement whenever
                a DB error is encountered if True.
            ora_codes_to_ignore (list[str]): a list of ora error codes of the form
                ['ORA-XXXXX',...] to be ignored if encountered.
        """

        def get_sql_from_file_as_str(filepath):
            """Returns the SQL in a file as a string"""
            lines = []
            with open(filepath, 'r') as file:
                for line in file:
                    # exclude comments
                    if '--' in line:
                        index = line.find('--')
                        line = line[:index]
                    lines.append(line)
            sql = ''.join(lines)
            return sql

        def split_sql_statements_in_str(sql_str):
            """Returns a list of SQL statements inside a singular string of SQL statements seperated by semi-colons"""
            sql_splitlines = sql_str.splitlines()
            sql_joined_lines = " ".join(sql_splitlines)
            sql_statements = [statement for statement in sql_joined_lines.split(';') if statement]
            return sql_statements

        sql_file_content = get_sql_from_file_as_str(filepath=sql_file_path)
        sql_statements = split_sql_statements_in_str(sql_str=sql_file_content)

        for statement in sql_statements:
            self.execute_with_exception_handling(
                statement=statement,
                parameters=parameters,
                ignore_all_db_errors=ignore_all_db_errors,
                ora_codes_to_ignore=ora_codes_to_ignore,
            )

    def query_to_df(self, query_string: str, parameters=None) -> pd.DataFrame:
        """
        Executes a query and returns the result as a pandas DataFrame.

        Args:
            query_string (str): The SQL query to execute.
            parameters (optional): The parameters to bind to the query.

        Returns:
            pd.DataFrame: A DataFrame containing the query results.
        """
        self.execute(statement=query_string, parameters=parameters)
        data = self.cursor.fetchall()
        columns = [column[0] for column in self.cursor.description]
        df = pd.DataFrame(data, columns=columns)
        return df

    def query_to_pl_df(self, query_string: str, parameters=None) -> pl.DataFrame:
        """
        Executes a query and returns the result as a polars DataFrame.

        Args:
            query_string (str): The SQL query to execute.
            parameters (optional): The parameters to bind to the query.

        Returns:
            pl.DataFrame: A DataFrame containing the query results.
        """
        self.execute(statement=query_string, parameters=parameters)
        data = self.cursor.fetchall()
        columns = [column[0] for column in self.cursor.description]
        df = pl.DataFrame(
            data, schema=columns, orient="row", infer_schema_length=None
        )
        return df

    def truncate(self, table_owner: str, table_name: str) -> None:
        """
        Truncates a table in the database.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
        """
        statement = f"Truncate table {table_owner}.{table_name} REUSE STORAGE"
        self.execute(statement=statement)

    def default_load(
        self,
        table_owner: str,
        table_name: str,
        cols_to_load_list: list[str],
        writeRows: list[tuple],
        truncate_first: bool = True,
    ) -> None:
        """
        Loads data into a table, optionally truncating it first.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            cols_to_load_list (str): a list of column names that align with the data to be loaded.
            writeRows (list[tuple]): The rows of data to insert.
            truncate_first (bool): Whether to truncate the table before loading data.
        """
        if truncate_first:
            self.truncate(table_owner, table_name)

        row_params = [
            dict(zip(cols_to_load_list, list(row_vals_tuple))) for row_vals_tuple in writeRows
        ]

        self.insert_many(
            table_owner=table_owner,
            table_name=table_name,
            cols_to_insert_list=cols_to_load_list,
            parameters=row_params,
        )

    def grant(self, grant_type: str, on_str: str, to_str: str, parameters=None) -> None:
        """
        Grants privileges of the form: grant {grant_type} on {on_str} to {to_str}

        Args:
            grant_type (str): The grant type.
            on_str (str): The object on which the privileges are being granted.
            to_str (str): The user to which the privileges are granted.
            parameters: The parameters to bind to the statement.
        """
        statement = f"grant {grant_type} on {on_str} to {to_str}"
        self.execute(statement=statement, parameters=parameters)
        self.commit()

    def delete(self, table_owner: str, table_name: str, where_str: str, parameters) -> None:
        """
        Deletes rows from a table based on a condition.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            where_str (str): The condition for deleting rows.
            parameters: The parameters to bind to the condition.
        """
        statement = f"delete from {table_owner}.{table_name} where {where_str}"
        self.execute(statement=statement, parameters=parameters)
        self.commit()

    def add_primary_key(
        self, table_owner: str, table_name: str, pk_name: str, pk_cols: str, parameters=None
    ) -> None:
        """
        Adds a primary key constraint to a table.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            pk_name (str): The name of the primary key constraint.
            pk_cols (str): The columns for the primary key.
            parameters: The parameters to bind to the statement.
        """
        statement = f"alter table {table_owner}.{table_name} add constraint {pk_name} primary key ({pk_cols})"
        self.execute(statement=statement, parameters=parameters)
        self.commit()

    def insert(
        self,
        table_owner: str,
        table_name: str,
        insert_tgt_cols_str: str,
        insert_vals_str: str,
        parameters,
    ) -> None:
        """
        Inserts a new row into a table.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            insert_tgt_cols_str (str): The target columns for the insert.
            insert_vals_str (str): The values to insert.
            parameters: The parameters to bind to the insert statement.
        """
        statement = f"""
            INSERT INTO {table_owner}.{table_name} ({insert_tgt_cols_str}) 
            values ({insert_vals_str})
        """
        self.execute(statement=statement, parameters=parameters)
        self.commit()

    def insert_many(
        self,
        table_owner: str,
        table_name: str,
        cols_to_insert_list: list[str],
        parameters,
    ) -> None:
        self.execute_many(
            statement=f"""
                INSERT INTO {table_owner}.{table_name} ({self._list_of_cols_to_cols_str(list_of_col_names=cols_to_insert_list)})
                VALUES {self._bind_vars_str(cols_to_insert_list)}
            """,
            parameters=parameters,
        )
        self.commit()

    def _bind_vars_str(self, list_of_cols: int) -> str:
        """
        Generate a string of numeric bind variables for an SQL insert/merge statement.

        This function creates a string of bind variables formatted for use 
        in a dynamically generated SQL `execute_many` insert statement. 

        Args:
            list_of_cols (list[str]): The columns for which to generate bind variables.

        Returns:
            str: A string containing the bind variables in the format 
                "( :col1, :col2, ..., :coln )", where n is the number of columns.

        Notes:
            - The resulting string can be used in SQL statements for 
            parameterized queries to prevent SQL injection.
        """
        bind_vars = "("
        for col in list_of_cols:
            bind_vars += f":{col}, "
        bind_vars = bind_vars[:-2] + ")"
        return bind_vars
    
    def upsert(
        self,
        table_owner: str,
        table_name: str,
        on_str: str,
        update_set_str: str,
        insert_tgt_cols_str: str,
        insert_vals_str: str,
        parameters
    ) -> None:
        """
        Updates or inserts records in a table using a merge statement.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            on_str (str): The condition for matching records.
            update_set_str (str): The columns to update if a match is found.
            insert_tgt_cols_str (str): The target columns for the insert.
            insert_vals_str (str): The values to insert.
            parameters: The parameters to bind to the merge statement.
        """
        statement=f"""
            merge into {table_owner}.{table_name} tgt 
            using dual
            on ({on_str})
            when matched then update set {update_set_str}
            when not matched then insert ({insert_tgt_cols_str}) values ({insert_vals_str})
        """
        self.execute(statement=statement, parameters=parameters)
        self.commit()

    def merge_new_records(
        self,
        table_owner: str,
        table_name: str,
        cols_to_merge_on_list: list[str],
        cols_to_merge_list: list[str],
        parameters,
    ) -> None:
        """
        Inserts new records in a table using a merge statement.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            cols_to_merge_on_list (list[str]): The columns to merge on.
            cols_to_merge_list (str): The columns to be merged.
            parameters: The parameters to bind to the merge statement.
        """
        statement=f"""
            merge into {table_owner}.{table_name} tgt 
            using dual
            on ({self._merge_on_str(list_of_col_names=cols_to_merge_on_list)})
            when not matched then insert ({self._list_of_cols_to_tgt_cols_str(cols_to_merge_list)}) 
                values {self._bind_vars_str(cols_to_merge_list)}
        """
        self.execute_many(statement=statement, parameters=parameters)
        self.commit()

    def _list_of_cols_to_tgt_cols_str(self, list_of_col_names: list[str]) -> str:
        """
        converts a list of column names into a string of the form:

        "tgt.col1, ..., tgt.coln"

        Args:
            list_of_col_names (list[str]): a list of column names
        """
        tgt_cols_list = ["tgt." + col for col in list_of_col_names]
        tgt_cols_str = ", ".join(tgt_cols_list)
        return tgt_cols_str

    def _list_of_cols_to_cols_str(self, list_of_col_names: list[str]) -> str:
        """
        converts a list of column names into a string of the form:

        "col1, ..., coln"

        Args:
            list_of_col_names (list[str]): a list of column names
        """
        tgt_cols_str = ", ".join(list_of_col_names)
        return tgt_cols_str

    def _merge_on_str(self, list_of_col_names: list[str]) -> str:
        """
        Generate the string that follows 'on' in a merge statement by equating a list of column names
        with corresponding numeric bind variables.

        Args:
            list_of_col_names (list[str]): a list of column names to be merged on.
        """
        on_str = ""
        for col in list_of_col_names:
            on_str += f" and {col} = :{col}"
        return on_str[5:]

    def update(self, table_owner, table_name, set_str, where_str, parameters) -> None:
        """
        Updates records in a table based on a condition.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.
            set_str (str): The columns to update.
            where_str (str): The condition for updating records.
            parameters: The parameters to bind to the update statement.
        """
        statement = f"""
            update {table_owner}.{table_name}
            set {set_str}
            where {where_str}
        """
        self.execute(statement=statement, parameters=parameters)
        self.commit()

    def count_dups_in_oracle(self, table_owner: str, table_name: str) -> int:
        """
        Counts duplicate rows in a table, ignoring columns that cannot be selected.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.

        Returns:
            int: The number of duplicate rows in the table.
        """
        get_cols_in_oracle = self.query_to_df(f"""
            select column_name 
            from all_tab_cols 
            where owner = upper('{table_owner}') 
            and table_name = upper('{table_name}')
            and data_type not in ('CLOB')
        """)
        list_cols_in_oracle = get_cols_in_oracle['COLUMN_NAME'].to_list()
        str_cols_in_oracle = ''
        for col in list_cols_in_oracle:
            str_cols_in_oracle += col
            if col != list_cols_in_oracle[-1]:
                str_cols_in_oracle += ', '

        dups_query = f"""
            select sum(dups) from (
                SELECT {str_cols_in_oracle}, COUNT(*) -1 dups
                FROM {table_owner}.{table_name}
                GROUP BY {str_cols_in_oracle}
                HAVING COUNT(*) > 1
            ) 
        """
        get_duplicates_in_oracle = self.query_to_df(dups_query).iat[0, 0]
        if get_duplicates_in_oracle is None:
            get_duplicates_in_oracle = 0
        else:
            get_duplicates_in_oracle = get_duplicates_in_oracle.item()
        return get_duplicates_in_oracle

    def get_row_count(self, table_owner: str, table_name: str) -> int:
        """
        Gets the total number of rows in a table.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.

        Returns:
            int: The total number of rows in the table.
        """
        row_count = self.query_to_df(f"""
            select count(*) 
            from {table_owner}.{table_name}
        """).iat[0, 0].item()
        return row_count

    def get_col_count(self, table_owner: str, table_name: str) -> int:
        """
        Gets the total number of columns in a table.

        Args:
            table_owner (str): The owner of the table.
            table_name (str): The name of the table.

        Returns:
            int: The total number of columns in the table.
        """
        col_count = (self.query_to_df(f"""
            select count(*) 
            from all_tab_columns 
            where owner = '{table_owner.upper()}' and table_name = '{table_name.upper()}'
        """).iat[0, 0].item())
        return col_count


class DatabaseException(Exception):
    """ 
    Exception raised for errors in the database operations.
    """
    pass


class UnknownEnvironmentException(Exception):
    """ 
    Exception raised for errors related to unknown environment configurations.
    """
    pass
