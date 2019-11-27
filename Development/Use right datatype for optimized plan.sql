[(orcl)oracle@oracle19c ~]$ sql donghua/MYPass@orclpdb

SQLcl: Release 19.1 Production on Wed Nov 27 07:36:32 2019

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Last Successful login time: Wed Nov 27 2019 07:36:35 +08:00

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.5.0.0.0


SQL> CREATE TABLE t (str_date, date_date, number_date, data)
  2  AS
  3  SELECT TO_CHAR(dt+rownum,'yyyymmdd')              str_date,    -- VARCHAR2
  4         dt+rownum                                  date_date,   -- DATE
  5         TO_NUMBER(TO_CHAR(dt+rownum,'yyyymmdd'))   number_date, -- NUMBER
  6         RPAD('*',45,'*')                           data
  7  FROM (SELECT TO_DATE('01-jan-1995', 'dd-mm-yyyy') dt
  8        FROM all_objects)
  9  ORDER BY DBMS_RANDOM.VALUE
 10  /

Table created.

SQL> CREATE INDEX t_str_date_idx ON t(str_date);

Index created.

SQL> CREATE INDEX t_date_date_idx ON t(date_date);

Index created.

SQL> CREATE INDEX t_number_date_idx ON t(number_date);

Index created.

SQL> BEGIN
  2    DBMS_STATS.GATHER_TABLE_STATS (
  3      'DONGHUA',
  4      'T',
  5      method_opt => 'for all indexed columns size 254',
  6      cascade => TRUE
  7    );
  8  END;
  9  /

PL/SQL procedure successfully completed.

SQL> SET AUTOTRACE ON EXPLAIN
Autotrace Enabled
Displays the execution plan only.

-- query string date column
SQL> SELECT * FROM t WHERE str_date BETWEEN '20001231' AND '20010101'
  2  ORDER BY str_date;

STR_DATE DATE_DATE NUMBER_DATE DATA                                         
-------- --------- ----------- ---------------------------------------------
20001231 31-DEC-00    20001231 *********************************************
20010101 01-JAN-01    20010101 *********************************************

Explain Plan
-----------------------------------------------------------

PLAN_TABLE_OUTPUT                                                               
--------------------------------------------------------------------------------
Plan hash value: 961378228                                                      
                                                                                
---------------------------------------------------------------------------     
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |     
---------------------------------------------------------------------------     
|   0 | SELECT STATEMENT   |      |   237 | 16353 |   200   (1)| 00:00:01 |     
|   1 |  SORT ORDER BY     |      |   237 | 16353 |   200   (1)| 00:00:01 |     
|*  2 |   TABLE ACCESS FULL| T    |   237 | 16353 |   199   (1)| 00:00:01 |     
---------------------------------------------------------------------------     
                                                                                
Predicate Information (identified by operation id):                             

PLAN_TABLE_OUTPUT                                                               
----------------------------------------------------------------------------                         
                                                                                
   2 - filter("STR_DATE"<='20010101' AND "STR_DATE">='20001231')  


-- query number date column
SQL> SELECT * FROM t WHERE number_date BETWEEN 20001231 AND 20010101
  2  order by number_date;

STR_DATE DATE_DATE NUMBER_DATE DATA                                         
-------- --------- ----------- ---------------------------------------------
20001231 31-DEC-00    20001231 *********************************************
20010101 01-JAN-01    20010101 *********************************************

Explain Plan
-----------------------------------------------------------

PLAN_TABLE_OUTPUT                                                               
--------------------------------------------------------------------------------
Plan hash value: 961378228                                                      
                                                                                
---------------------------------------------------------------------------     
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |     
---------------------------------------------------------------------------     
|   0 | SELECT STATEMENT   |      |   235 | 16215 |   200   (1)| 00:00:01 |     
|   1 |  SORT ORDER BY     |      |   235 | 16215 |   200   (1)| 00:00:01 |     
|*  2 |   TABLE ACCESS FULL| T    |   235 | 16215 |   199   (1)| 00:00:01 |     
---------------------------------------------------------------------------     
                                                                                
Predicate Information (identified by operation id):                             

PLAN_TABLE_OUTPUT                                                               
-------------------------------------------------------------------------------                            
                                                                                
   2 - filter("NUMBER_DATE"<=20010101 AND "NUMBER_DATE">=20001231)  

-- query date date column
SQL> SELECT * FROM t WHERE date_date
  2    BETWEEN TO_DATE('20001231','yyyymmdd')
  3    AND     TO_DATE('20010101','yyyymmdd')
  4*   order by date_date;

STR_DATE DATE_DATE NUMBER_DATE DATA                                         
-------- --------- ----------- ---------------------------------------------
20001231 31-DEC-00    20001231 *********************************************
20010101 01-JAN-01    20010101 *********************************************

Explain Plan
-----------------------------------------------------------

PLAN_TABLE_OUTPUT                                                                                                       
-----------------------------------------------------------------------------------------------------
Plan hash value: 546586007                                                                                              
                                                                                                                        
-----------------------------------------------------------------------------------------------                         
| Id  | Operation                   | Name            | Rows  | Bytes | Cost (%CPU)| Time     |                         
-----------------------------------------------------------------------------------------------                         
|   0 | SELECT STATEMENT            |                 |     1 |    69 |     3   (0)| 00:00:01 |                         
|   1 |  TABLE ACCESS BY INDEX ROWID| T               |     1 |    69 |     3   (0)| 00:00:01 |                         
|*  2 |   INDEX RANGE SCAN          | T_DATE_DATE_IDX |     1 |       |     2   (0)| 00:00:01 |                         
-----------------------------------------------------------------------------------------------                         
                                                                                                                        
Predicate Information (identified by operation id):                                                                     

PLAN_TABLE_OUTPUT                                                                                                       
----------------------------------------------------------------------------------------------------------                                                                  
                                                                                                                        
   2 - access("DATE_DATE">=TO_DATE(' 2000-12-31 00:00:00', 'syyyy-mm-dd hh24:mi:ss')                                    
              AND "DATE_DATE"<=TO_DATE(' 2001-01-01 00:00:00', 'syyyy-mm-dd hh24:mi:ss'))                               

SQL> 

-- below gather satistics doesn't help to change the execution plan:

SQL> BEGIN
  2    DBMS_STATS.GATHER_TABLE_STATS (
  3      'DONGHUA',
  4      'T',
  5      options=>'gather auto',
  6      cascade => TRUE
  7    );
  8  END;
  9 /
PL/SQL procedure successfully completed.
