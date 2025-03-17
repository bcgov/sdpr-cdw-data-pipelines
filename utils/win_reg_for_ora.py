import winreg
import os
from dotenv import load_dotenv
load_dotenv()


class WinRegForOra:
    '''
    Gets Oracle connection strings stored in Windows Registry on the local machine.

    Required Env Vars:
        ORACLE_CONN_STR_DIR_IN_WINREG: the root directory in Registry Editor that 
            contains keys with Oracle connection string values

    Connection string format: user/password@servicename

    Example:
        if ORACLE_CONN_STR_DIR_IN_WINREG = Databases\Oracle\\
        then the full path to this dir in Registry Editor is:
            Computer\HKEY_LOCAL_MACHINE\Databases\Oracle
        and this dir can contain multiple key folders that each contain
        connection strings as values. Suppose one of these key folders is
        names CW1D, then the full key path to the connection string is:
            Computer\HKEY_LOCAL_MACHINE\Databases\Oracle\CW1D
    '''
    
    # Class Env Vars
    # the directory in Registry Editor that contains Oracle connection strings
    oracle_conn_str_dir_in_winreg = os.getenv('ORACLE_CONN_STR_DIR_IN_WINREG')
    print('xxxxx', oracle_conn_str_dir_in_winreg)

    def __init__(self):
        pass

    def get_oracle_conn_str_paths(self):
        """
        Returns a dictionary of Oracle connection string paths on the local machine.

        One complete path is constructed as:
        path_dict['base_path'] + path_dict['endpoints'][index of chosen endpoint].

        Returns:
            dict: A dictionary containing base path and list of endpoints.
        """
        key_path = self.oracle_conn_str_dir_in_winreg
        aKey = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, key_path, 0, winreg.KEY_ALL_ACCESS)
        paths = {"base_path": key_path + "\\", "endpoints": []}
        try:
            i = 0
            while True:
                asubkey = winreg.EnumKey(aKey, i)
                paths["endpoints"] += [asubkey]
                i += 1
        except WindowsError:
            pass
        return paths

    def get_oracle_conn_str(self, conn_str_key_endpoint: str) -> str:
        """
        Retrieves the Oracle DB connection string from the Windows Registry.

        Args:
            conn_str_key_endpoint (str): The final part of the key for the Oracle DB connection string.

        Returns:
            str: The Oracle DB connection string.
        """
        local_computer_key = winreg.ConnectRegistry(None, winreg.HKEY_LOCAL_MACHINE)
        key_path = self.oracle_conn_str_dir_in_winreg + conn_str_key_endpoint
        conn_str_key = winreg.OpenKey(local_computer_key, rf"{key_path}")
        name, value, type = winreg.EnumValue(conn_str_key, 0)
        winreg.CloseKey(conn_str_key)
        return value

    def parse_oracle_conn_str(self, oracle_conn_str: str) -> dict[str, str]:
        """
        Parses an Oracle DB connection string into its components.

        Args:
            oracle_conn_str (str): An Oracle DB connection string in the form user/password@service_name.

        Returns:
            dict: A dictionary containing the parsed Oracle DB credentials.
        """
        slashLoc = oracle_conn_str.find("/")
        atLoc = oracle_conn_str.find("@cw")

        user = oracle_conn_str[0:slashLoc]
        cust_pwd = oracle_conn_str.find("\\")
        service_name = oracle_conn_str[oracle_conn_str.find("@cw") + 1 :]
        if cust_pwd == -1:
            pwd = oracle_conn_str[slashLoc + 1 : atLoc]
        else:
            pwd = oracle_conn_str[slashLoc + 3 : atLoc - 2]

        creds = {"user": user, "pwd": pwd, "service_name": service_name}

        return creds

    def get_oracle_conn_dict(self, conn_str_key_endpoint: str) -> dict[str, str]:
        """
        Retrieves and parses the Oracle DB connection string into a dictionary.

        Args:
            conn_str_key_endpoint (str): The final part of the key for the Oracle DB connection string.

        Returns:
            dict: A dictionary containing Oracle DB credentials parsed from the connection string.
        """
        conn_str = self.get_oracle_conn_str(conn_str_key_endpoint)
        conn_dict = self.parse_oracle_conn_str(conn_str)
        return conn_dict
