/*
you should add this hint to your query to capture it
option (use hint('query_plan_profile'))
*/
if exists(select 1 from sys.server_event_sessions where name = 'xQueryPlanProfile')
begin
	alter event session xQueryPlanProfile on server state = stop
	drop event session xQueryPlanProfile on server
end
go