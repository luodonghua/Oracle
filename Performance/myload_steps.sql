-- create tablespace
create bigfile tablespace myload datafile size 1g autoextend on next 100M;

-- create table and index
create table t (id int generated as identity, value varchar2(1000),last_update date default sysdate) tablespace myload;
create index t_n1 on t(id) tablespace myload;

-- intial polulate table data. 
-- e.g. 30GB data ~ 30*1024*1024/8*7 = 27,525,120 (rows)

begin
for i in 1..10 loop
 myload.p_insert(1000000);
end loop;
end;
/


-- schedule job


begin
  dbms_scheduler.create_job (
    job_name         => 'job_0_my_insert',
    job_type         => 'PLSQL_BLOCK',
    job_action       => 'begin myload.my_insert(0.05);end;',
    repeat_interval  => 'FREQ=DAILY;BYHOUR=8;BYMINUTE=0;BYSECOND=0',
    enabled          => TRUE,
    comments         => 'insert 5% data based on current size at 8AM'
  );
end;
/


begin
  dbms_scheduler.create_job (
    job_name         => 'job_1_my_update',
    job_type         => 'PLSQL_BLOCK',
    job_action       => 'begin myload.my_update(0.04);end;',
    repeat_interval  => 'FREQ=DAILY;BYHOUR=12;BYMINUTE=0;BYSECOND=0',
    enabled          => TRUE,
    comments         => 'update 4% data based on current size at 12PM'
  );
end;
/


begin
  dbms_scheduler.create_job (
    job_name         => 'job_2_my_delete',
    job_type         => 'PLSQL_BLOCK',
    job_action       => 'begin myload.my_delete(0.01);end;',
    repeat_interval  => 'FREQ=DAILY;BYHOUR=16;BYMINUTE=0;BYSECOND=0',
    enabled          => TRUE,
    comments         => 'delete 1% data based on current size at 4PM'
  );
end;
/
