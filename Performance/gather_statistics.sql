select con_id,operation,target, end_time from cdb_optstat_operations
where ( (operation = 'gather_fixed_objects_stats')
     or (operation = 'gather_dictionary_stats' and (target is null or target in ('SYS','SYSTEM')))
     or (operation = 'gather_schema_stats' and target in ('SYS','SYSTEM'))
     ) and end_time > sysdate -7
     order by con_id, end_time;
     
-- no-cdb version     
select operation,target, end_time from cdb_optstat_operations
where ( (operation = 'gather_fixed_objects_stats')
     or (operation = 'gather_dictionary_stats' and (target is null or target in ('SYS','SYSTEM')))
     or (operation = 'gather_schema_stats' and target in ('SYS','SYSTEM'))
     ) and end_time > sysdate -7
     order by end_time;


begin
  dbms_stats.gather_schema_stats('SYS');
  dbms_stats.gather_schema_stats('SYSTEM');
end;
/


select operation,target, end_time from cdb_optstat_operations
where end_time > sysdate -7
order by end_time;
          
