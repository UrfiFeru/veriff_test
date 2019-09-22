# veriff_test
# ETL PROCESS:
The ETL process runs on truncate and load methodology for the purpose of simplicity. 
This is worth pointing out that when the data increases in the future, it can be made sure that the process only runs on the delta instead of the overall data.

# Data Warehouse Architecture
## Dimensions:
verifier_lnd (Same table as the raw data acts as a dimension for verifiers. For simplicity have not added surrogate keys to this table) 
country_lnd (Same table as the raw data acts as a dimension for countries. For simplicity have not added surrogate keys to this table)
sessions_dim (For each session, insert a surrogate key, session_uuid and calculate the start and end time via their respective keys)

## Fact:
verification_fact 
Created using the dimensions table and the sessions_lnd table.
Due to limited amount of columns, I thought it was best to implement the modern day Data Warehouse practices in which the fact table not only contains the foreign keys of the data, but the most used dimensions as well. That is why I have put Verifer and Country name in the session fact table along with the respective Ids.

# Questions
For the questions which needed to be answered, it is assumed that the statistics are required for both approved and declined statuses and not just only for the approved status.
The answers are attached in the excel file veriff_test.xlsx
