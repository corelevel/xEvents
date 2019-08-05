------------------------------------------------------------------
/*
you should configure this parameter to start capture that type of event
exec sp_configure 'blocked process threshold', 25 -- it's seconds
reconfigure
*/
if exists(select 1 from sys.server_event_sessions where name = 'xBlocking')
begin
	alter event session xBlocking on server state = stop
	drop event session xBlocking on server
end
go
create event session xBlocking on server
add event sqlserver.blocked_process_report
add target package0.event_file(set filename=N'xBlocking',max_file_size=(250),max_rollover_files=(3))
with (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_state=ON)
go
alter event session xBlocking on server state = start
go
------------------------------------------------------------------
if exists(select 1 from sys.server_event_sessions where name = 'xDeadlocks')
begin
	alter event session xDeadlocks on server state = stop
	drop event session xDeadlocks on server
end
go
create event session xDeadlocks on server
add event sqlserver.xml_deadlock_report
add target package0.event_file(SET filename=N'xDeadlocks',max_file_size=(250),max_rollover_files=(3))
with (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_state=ON)
go
alter event session xDeadlocks on server state = start
go
------------------------------------------------------------------
if exists(select 1 from sys.server_event_sessions where name = 'xLongDuration')
begin
	alter event session xLongDuration on server state = stop
	drop event session xLongDuration on server
end
go
create event session xLongDuration on server
add event sqlserver.rpc_completed(set collect_output_parameters=(1),collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.[database_name],sqlserver.is_system,sqlserver.nt_username,sqlserver.plan_handle,sqlserver.session_id)
    WHERE (duration>(25000000))) -- it's microseconds
add target package0.event_file(set filename=N'xLongDuration',max_file_size=(250),max_rollover_files=(3))
with (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_state=ON)
go
alter event session xLongDuration on server state = start
go
------------------------------------------------------------------
if exists(select 1 from sys.server_event_sessions where name = 'xTimeOuts')
begin
	alter event session xTimeOuts on server state = stop
	drop event session xTimeOuts on server
end
go
create event session xTimeOuts on server
add event sqlserver.rpc_completed(set collect_output_parameters=(1)
    action(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.[database_name],sqlserver.is_system,sqlserver.nt_username,sqlserver.plan_handle,sqlserver.session_id)
    where (result=(2)))
add target package0.event_file(set filename=N'xTimeOuts',max_file_size=(250),max_rollover_files=(3))
with (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_state=ON)
go
alter event session xTimeOuts on server state = start
go
