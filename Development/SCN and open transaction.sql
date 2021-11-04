create table t (i number);

alter database add supplemental log data; 
alter table t add supplemental log data (all) columns;


-- session 1: start at time T

column scn new_value myscn

select current_timestamp(6), dbms_flashback.get_system_change_number from dual;
select dbms_flashback.get_system_change_number as scn from dual;
insert into t values (&myscn);



-- session 2: start at time T + 1

column scn new_value myscn

select current_timestamp(6), dbms_flashback.get_system_change_number from dual;
select dbms_flashback.get_system_change_number as scn from dual;
insert into t values (&myscn);


-- session 2: commit at T + 2

select dbms_flashback.get_system_change_number as scn from dual;
insert into t values (&myscn);

commit;


-- session 1: commit at T + 3

select dbms_flashback.get_system_change_number as scn from dual;
insert into t values (&myscn);

commit;


select xid, start_scn,commit_scn, operation, row_id, undo_sql from flashback_transaction_query where table_name='T' and start_scn >=3239721;

/*

SQL> select current_scn, dbms_flashback.get_system_change_number from v$database;

   CURRENT_SCN    GET_SYSTEM_CHANGE_NUMBER 
______________ ___________________________ 
        728212                      728212 


-- session 1: start at time T

SQL> column scn new_value myscn

SQL> select current_timestamp(6), dbms_flashback.get_system_change_number from dual;

                            CURRENT_TIMESTAMP(6)    GET_SYSTEM_CHANGE_NUMBER 
________________________________________________ ___________________________ 
04/11/21 02:50:09.185240000 PM ASIA/SINGAPORE                        3239721 

SQL> select dbms_flashback.get_system_change_number as scn from dual;

       SCN 
__________ 
   3239729 

SQL> insert into t values (&myscn);
old:insert into t values (&myscn)
new:insert into t values (3239729)

1 row inserted.


-- session 2: start at time T + 1


SQL> column scn new_value myscn

SQL> select current_timestamp(6), dbms_flashback.get_system_change_number from dual;

                            CURRENT_TIMESTAMP(6)    GET_SYSTEM_CHANGE_NUMBER 
________________________________________________ ___________________________ 
04/11/21 02:51:07.956494000 PM ASIA/SINGAPORE                        3239844 

SQL> select dbms_flashback.get_system_change_number as scn from dual;

       SCN 
__________ 
   3239856 

SQL> insert into t values (&myscn);
old:insert into t values (&myscn)
new:insert into t values (3239856)

1 row inserted.



-- session 2: commit at T + 2

SQL> select dbms_flashback.get_system_change_number as scn from dual;

       SCN 
__________ 
   3240007 

SQL> insert into t values (&myscn);
old:insert into t values (&myscn)
new:insert into t values (3240007)

1 row inserted.

SQL> commit;

Commit complete.



-- session 1: commit at T + 3

SQL> select dbms_flashback.get_system_change_number as scn from dual;

       SCN 
__________ 
   3240052 

SQL> insert into t values (&myscn);
old:insert into t values (&myscn)
new:insert into t values (3240052)

1 row inserted.

SQL> commit;

Commit complete.



SQL> select i, scn_to_timestamp(i) from t order by i;

         I               SCN_TO_TIMESTAMP(I) 
__________ _________________________________ 
   3239729 04/11/21 02:50:10.000000000 PM    
   3239856 04/11/21 02:51:11.000000000 PM    
   3240007 04/11/21 02:51:56.000000000 PM    
   3240052 04/11/21 02:52:14.000000000 PM    


SQL> select xid, start_scn,commit_scn, operation, row_id, undo_sql from flashback_transaction_query where table_name='T' and start_scn >=3239721;

                XID    START_SCN    COMMIT_SCN    OPERATION                ROW_ID                                                         UNDO_SQL 
___________________ ____________ _____________ ____________ _____________________ ________________________________________________________________ 
03001B00AA030000         3239747       3240074 INSERT       AAASqpAAMAAAACHAAB    delete from "DONGHUA"."T" where ROWID = 'AAASqpAAMAAAACHAAB';    
03001B00AA030000         3239747       3240074 INSERT       AAASqpAAMAAAACHAAA    delete from "DONGHUA"."T" where ROWID = 'AAASqpAAMAAAACHAAA';    
08002100E9030000         3239933       3240021 INSERT       AAASqpAAMAAAACFAAB    delete from "DONGHUA"."T" where ROWID = 'AAASqpAAMAAAACFAAB';    
08002100E9030000         3239933       3240021 INSERT       AAASqpAAMAAAACFAAA    delete from "DONGHUA"."T" where ROWID = 'AAASqpAAMAAAACFAAA';  


--------------------------------------
|   update t set id =2 where id =1   |
--------------------------------------
                                            -------------------------------------- 
                                            |   update t set id =3 where id =2   |
                                            --------------------------------------
      
      ------------------------------------
      |   select * from t (full load)    |
      ------------------------------------
      --------------------------------------------------------------------------------------
      |                            Change Data Capture .....
      --------------------------------------------------------------------------------------


*/