-- <#
-- .SYNOPSIS
--     This script will check the blocking. If it is then qualifies for the alert.
--     It sends E-mail by combining all these alerts (example mentioned in o/p).
-- .DESCRIPTION
--     Alert serial number, Server Name, Database Name,  %Free File Space - Free log file space.
--     It will send an email, if scheduled then it is monitoring as well as log file size auto handling technique.
-- .INPUTS
--     Set E-Mail profile in SSMS. Replace it with example one as mentioned in comment. 
--     Please set varibles like recipients E-Mail id and profile as and when guided by comment through code.
-- .EXAMPLE
--     Create script and schedule it as per requirement.
--     This will execute the script and gives HTML content in email with the details in body.
-- .NOTES
--     PUBLIC
-- .AUTHOR & OWNER
--     Harsh Parecha
--     Sahista Patel
-- #>

IF EXISTS(SELECT sqltext.text As Command_In_queue,
db_name(sp.dbid) As Database_Name, 
req.session_id,
req.blocking_session_id,
req.status,
req.start_time,
req.command,
req.cpu_time,
req.total_elapsed_time,
(SELECT sqltext.text FROM sys.dm_exec_requests CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext where session_id = req.blocking_session_id) As Command_Created_Block
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
inner join sys.sysprocesses sp on req.session_id = sp.spid
WHERE blocking_session_id <> 0 )
BEGIN

DECLARE @tableHTML  NVARCHAR(MAX) ;  
  
SET @tableHTML =  
    N'<H1>Block Query Report</H1>' +  
    N'<table border="1">' +  
    N'<tr><th>Database Name</th><th>Blocked Query</th><th>Session ID</th>' +  
    N'<th>Command</th><th>Blocking Query</th><th>Blocking Session ID</th>' +  
    N'<th>Blocking Query Command</th><th>Start Time</th><th>Total Elapsed Time</th></tr>' +  
    CAST ( ( SELECT td = db_name(sp.dbid), '',
                    td = sqltext.text,       '',  
                    td = req.session_id, '',  
                    td = req.command, '',  
                    td = ((SELECT sqltext.text FROM sys.dm_exec_requests CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext where session_id = req.blocking_session_id)), '',  
                    td = req.blocking_session_id, '',  
                    td = (SELECT command FROM sys.dm_exec_requests CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext where session_id = req.blocking_session_id), '',
                    td = req.start_time,       '',  
                    td = req.total_elapsed_time
              FROM sys.dm_exec_requests req  
              CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
              inner join sys.sysprocesses sp on req.session_id = sp.spid
              WHERE blocking_session_id <> 0    
              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  
  
EXEC msdb.dbo.sp_send_dbmail 
    @profile_name = 'SQL_Email', -- Replace with your SQL Database Mail Profile 
    @recipients='example1@outlook.com;example2@outook.com;',  -- Replace with your email address
    @subject = 'Blocking Alert',  
    @body = @tableHTML,  
    @body_format = 'HTML' ;  

END
