# MHRGRP PeopleSoft API ETL Documentation

## Following Initial Clone

- Rename `config_template.yml` to `config.yml` and set the configuration values
- Rename `SDPR_keypair_template.pem` to `SDPR_keypair.pem` and add the pem key
- Rename `template.env` to `.env` and set the environment variable values

Setup your virtual environment to install an independent set of python packages in the project directory in a .venv folder:
1. go to the chips-src-to-stg directory: `cd chips\chips-src-to-stg`
2. create a venv in the root directory: `python -m venv .venv`
3. activate the venv in powershell terminal: `.venv\Scripts\Activate.ps1`

Install packages in your virtual environment:
* Offline (if on the servers):
  1. go to the chips-src-to-stg directory: `cd chips\chips-src-to-stg`
  2. activate the venv in powershell terminal: `.venv\Scripts\Activate.ps1`
  3. install all packages in requirements.txt using the whl files in the wheels folder: `python -m pip install --no-index --find-links=wheels/ -r requirements.txt`
  * If you just want to install a specific package from a folder containing wheels, run a command of the form: `pip install --no-index --find-links /path/to/wheel/dir/ pkg`
* Online (if on your own machine): `pip install -r requirements.txt`

## Managing Libraries
Generate a requirements.txt file containing all libraries installed in the venv by running: `pip3 freeze > requirements.txt` so you can install required packages in new venvs by running `pip install -r requirements.txt`. 

Since our ETL servers require offline installs, I created a folder called `wheels` to house all of the `.whl` files, which can be installed by following the instructions on offline package installs above.

To refresh the venv_downloads folder based on the current `requirements.txt` file, you need to be on a machine that let's you access the internet so you can use `pip download ...`. From such a machine:
1. delete existing whl files in the wheels folder
2. download the whl files for all packages in requirements.txt into the wheels folder: `pip download -r requirements.txt -d wheels`

Now, you can merge these changes made on your local machine into the main branch, pull the changes on the servers, and do an offline install on the servers.

## Formatting
Ruff is used for formatting. You can run `format ruff` in powershell from the root directory to format all code. You can configure formatting rules in the `ruff.toml` and `pyproject.toml` files. See the ruff documentation online for details.

## Source Control
Use Git + GitHub for source control:
1. create a development branch off the main branch: `git checkout -b your-branch-name`
2. publish the branch to the remote: `git push -u origin your-branch-name`
3. stage all changes: `git add .`
4. commit staged changes: `git commit -m "your commit message"`
5. push changes: `git push`
6. go to the associated GitHub repo and create a pull request. Assign reviewers for code 
reviews.

To pull changes from the remote, run `git pull`

## Generating Documentation with Sphinx
Open bash terminal
1. `source .venv/Scripts/activate`
2. `cd docs`
3. auto-generate the .rst files: `sphinx-apidoc -o ./source ../[relative path to folder containing the new modules, i.e. src] -f --separate`
4. `make html`
5. The documentation website is located at: `docs\build\html\index.html`. Just paste the full file path in your browser.

## Running the HCDWLPWA Job
Here’s an exercise you can do familiarize yourself with running this ETL pipeline:
1.	In Oracle, open the view ETL.TABLE_BUILD_STATUS_VIEW and take a look at the build_end column to see the last time chips_stg tables have been refreshed.
2.	go onto the dev server, amleth.
3.	In VS Code, open this repo at: E:\ETL_V8\sdpr-cdw-data-pipelines
4.	Open `...\chips\chips-src-to-stg\etl_jobs\chips_src_to_stg\chips_src_to_stg.py`
5.	Comment out some endpoint table pairs (using #) by highlighting lines of code then using Ctrl + / and then saving the file.
6.	Run `...\chips\chips-src-to-stg\etl_jobs\chips_src_to_stg\chips_src_to_stg.bat` to refresh the tables that haven’t been commented out
7.	In Oracle, refresh your view of ETL.TABLE_BUILD_STATUS_VIEW to see real time status updates of the tables being built
8.	Remember to go back to chips_src_to_stg.py and uncomment the endpoint table pairs that you previously commented out in (5.).
