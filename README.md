# veriff_test
edw_veriff.py - DAG containing ETL process using python and airflow  
scripts.sql - Create table scripts in datawarehouse db  
procedure.sql - Contain the actual script to populate dimensions and facts.    
answers.sql - Contain queries to the questions asked.  
Veriff_Answers.xlsx - Contain results to the question asked.  
Note: The script to build the source database was the same as provided with the test.  

# Environment Setup
Airflow was installed on Ubuntu v18 on the windows machine.  
Airflow db is based on Sqlite for the purposes of this project and the webserver is hosted at 8080 port.
The ETL schedule is set to daily currently.
PostgreSql was installed locally on the windows machine and was used to connect with airflow through Python.
PostgreSql connection strings are mentioned in the code as they are being used with psycopg2 instead of PostgresHook.

# ETL PROCESS:  
The ETL process runs on truncate and load methodology for the purpose of simplicity.  
There are 4 tasks written in airflow which moves data from each of the 4 tables from source (veriff) to destination (edw).  
The 5th task populates the data in the fact and dimension tables and is dependent on the previous 4 tables.  
This is worth pointing out that when the data increases in the future, it can be made sure that the process only runs on the delta instead of the overall data.

# Data Warehouse Architecture

## Landing Tables:  
The landing tables are:  
Countries_lnd  
Events_lnd  
Sessions_lnd  
Verifiers_lnd  
  
As mentioned above, these are made on truncate and load methodology. These have exactly the same strucuture as source tables with the addition of inserted_at column.  
For the sake of simplicity, no backup table has been made currently which can be used for data integrity and quality checks in the future.  

## Dimensions:
### verifier_lnd
Same table as the raw data acts as a dimension for verifiers. For simplicity have not added surrogate keys to this table  

### country_lnd 
Same table as the raw data acts as a dimension for countries. For simplicity have not added surrogate keys to this table  

### sessions_dim 
For each session, insert a surrogate key, session_uuid and calculate the start and end time via their respective keys  

## Fact Tables:
### verification_fact 
Created using the dimensions table and the sessions_lnd table.  
Due to limited amount of columns, I thought it was best to implement the modern day Data Warehouse practices in which the fact table not only contains the foreign keys of the data, but the most used dimensions as well. That is why I have put Verifer and Country name in the session fact table along with the respective Ids.

# Questions
For the questions which needed to be answered, it is assumed that the statistics are required for both approved and declined statuses and not just only for the approved status.  
The answers are attached in the excel file veriff_test.xlsx

# Feedback
Reach me at arsalan-93@hotmail.com or urfi0071 on Skype for any feedback/questions
