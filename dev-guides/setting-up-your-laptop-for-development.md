# Setting Up Your Laptop for Development
If you have any issues installing any of the following, start by looking up the documentation online. Try to find a “getting started” tutorial.

## Install an IDE
Install your preferred IDEs. VS Code is recommended for its great extensions, including Python, SQL Developer, Edit csv, Ruff, and Batch Runner. Install SQL Developer, too.

## Install KeePass
KeePass is a database that stores credentials for databases, applications, etc. It’s available for download in the software center. The KeePass database file is located on a shared drive at `S:\Info Tech\Operations - Applications (6820)\Local appl (by name) (6820-30)\Corporate Data Warehouse\Cognos 11 and Data Stage\Data Stage\Credentials.kdbx`. Note, the first part of this path might be different depending on how you mounted our Info Tech network drive. I used the S: drive, here. Someone on our team can share the master password for KeePass with you.

## Setup Source Control
1. Install and setup git.
2. Access and clone repositories in [our GitHub team](https://github.com/orgs/bcgov/teams/sdpr-corporate-data-warehouse-team). 

## Install Languages
Install Python along with any other languages you would like to use.

## Install Python Libraries
Some Python libraries you might want to get started with include:
- `oracledb` to connect to our databases
- `polars`, `pandas`, and `PySpark` to work with data
- `requests` to make API requests
- `aiohttp` and `asyncio` to make asynchronous API requests

 