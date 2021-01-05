# SQL-Blocking

This script will check the blocking. If it is then qualifies for the alert. It sends E-mail by combining all these alerts (example mentioned in o/p).

# Prerequisites

SQL Server
SSMS - SQL Server Management Studio

# Note

Set SSMS E-Mail Profile<br>
Blocked Query - The full query which is blocked<br>
Session ID - The Session ID of the blocked query<br>
Command - The specific query command which is blocked. Example, SELECT, INSERT, UPDATE, DELETE, etc<br>
Blocking Query - The full query which is creating block<br>
Blocking Session ID - The Session ID of the blocking query<br>
Blocking Query Command - The specific query command which is creating block. Example, SELECT, INSERT, UPDATE, DELETE, etc<br>
Start Time - The start time since block created<br>
Total Elapsed Time - Time occupied by block<br>

# Use

Create profile and script in SSMS then schedule it as per requirement.

# Input
@profile_name = 'SQL_Email', -- Replace with your SQL Database Mail Profile<br>
@recipients='example1@outlook.com;example2@outlook.com;',  -- Replace with your email address<br>
@subject = 'Blocking Alert',  
@body = @tableHTML,  
@body_format = 'HTML' ;

# Example O/P
![alt text](https://github.com/Sahista-Patel/SQL-Blocking/blob/SQL/block_query.PNG)


# License
Copyright 2020 Harsh & Sahista

# Contribution
[Harsh Parecha] (https://github.com/TheLastJediCoder)<br>
[Sahista Patel] (https://github.com/Sahista-Patel)<br>
We love contributions, please comment to contribute!

# Code of Conduct
Contributors have adopted the Covenant as its Code of Conduct.. Please understand copyright and what actions will not be abided.
