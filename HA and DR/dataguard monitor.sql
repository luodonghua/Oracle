
select to_char(start_time,'YYYY-MON-DD HH24:MI:SS')||','||type||','||item||','||units||','||sofar||','||total||','||timestamp||','||comments recover_stats
from  v$recovery_progress;

/*

RECOVER_STATS
--------------------------------------------------------------------------------------------------------
2021-NOV-03 01:10:13,Media Recovery,Log Files,Files,78,0,,
2021-NOV-03 01:10:13,Media Recovery,Active Apply Rate,KB/sec,645,0,,
2021-NOV-03 01:10:13,Media Recovery,Average Apply Rate,KB/sec,3,0,,
2021-NOV-03 01:10:13,Media Recovery,Maximum Apply Rate,KB/sec,1396,0,,
2021-NOV-03 01:10:13,Media Recovery,Redo Applied,Megabytes,83,0,,
2021-NOV-03 01:10:13,Media Recovery,Recovery ID,RCVID,0,0,,RCVID: 428953150226319861
2021-NOV-03 01:10:13,Media Recovery,Last Applied Redo,SCN+Time,0,0,03-NOV-21,SCN: 4376813
2021-NOV-03 01:10:13,Media Recovery,Active Time,Seconds,1219,0,,
2021-NOV-03 01:10:13,Media Recovery,Apply Time per Log,Seconds,15,0,,
2021-NOV-03 01:10:13,Media Recovery,Checkpoint Time per Log,Seconds,0,0,,
2021-NOV-03 01:10:13,Media Recovery,Elapsed Time,Seconds,22243,0,,

11 rows selected.
*/

select name||','||value||','||time_computed||','||datum_time dg_stats from v$dataguard_stats;

/*


SQL> select name||','||value||','||time_computed||','||datum_time dg_stats from v$dataguard_stats;

DG_STATS
-------------------------------------------------------------------------------------------------------
transport lag,+00 00:00:00,11/03/2021 07:21:02,11/03/2021 07:21:01
apply lag,+00 00:00:00,11/03/2021 07:21:02,11/03/2021 07:21:01
apply finish time,+00 00:00:00.000,11/03/2021 07:21:02,
estimated startup time,13,11/03/2021 07:21:02,
*/


set echo off
set feedback off
set termout off
set pagesize 100
set numwidth 10
column event format a40 truncate
column name format a35 truncate
column opname format a35 truncate
column value format 99999999999999
select to_char(sysdate,'YYYYMMDD-HH24:MI:SS') snaptime,event, total_waits, time_waited, average_wait*10 from v$system_event where time_waited > 100 and event not like 'rdbms ipc %' and event not like '%timer%'and lower(event) not like '%idle%' and lower(event) not like 'sql%net%' and event not like 'ges%' order by time_waited;





