/*

Note: Do not use the VARCHAR data type. Use the VARCHAR2 data type instead. 
Although the VARCHAR data type is currently synonymous with VARCHAR2, 
the VARCHAR data type is scheduled to be redefined as a separate data type used 
for variable-length character strings compared with different comparison semantics.

*/

/*
Comparison semantics

When you need ANSI compatibility in comparison semantics, use the CHAR data type. 
When trailing blanks are important in string comparisons, use the VARCHAR2 data type.

*/


[(orcl)oracle@oracle19c ~]$ sql donghua/myPass@orclpdb

SQLcl: Release 19.1 Production on Wed Nov 27 10:41:14 2019

Copyright (c) 1982, 2019, Oracle.  All rights reserved.

Last Successful login time: Wed Nov 27 2019 10:41:15 +08:00

Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.5.0.0.0



SQL> drop table t purge;

Table dropped.

SQL> create table t (
  2      c1 char(10),c2 char(10), c3 char(10), 
  3      vc1 varchar2(10), vc2 varchar2(10), vc3 varchar2(10));

Table created.

SQL> insert into t values('a','a ', 'a  ','a', 'a ','a  ');

1 row created.

SQL> commit;

Commit complete.


select 
    case when c1=c2 then 'True' else 'False' end as "C1=C2",
    case when c1=c3 then 'True' else 'False' end as "C1=C3",
    case when c1=vc1 then 'True' else 'False' end as "C1=VC1",
    case when c1=vc2 then 'True' else 'False' end as "C1=VC2",
    case when c1=vc3 then 'True' else 'False' end as "C1=VC3"
from t;

SQL> select 
  2      case when c1=c2 then 'True' else 'False' end as "C1=C2",
  3      case when c1=c3 then 'True' else 'False' end as "C1=C3",
  4      case when c1=vc1 then 'True' else 'False' end as "C1=VC1",
  5      case when c1=vc2 then 'True' else 'False' end as "C1=VC2",
  6      case when c1=vc3 then 'True' else 'False' end as "C1=VC3"
  7  from t;

C1=C2 C1=C3 C1=VC C1=VC C1=VC
----- ----- ----- ----- -----
True  True  False False False


select 
    case when c2=c3 then 'True' else 'False' end as "C2=C3",
    case when c2=vc1 then 'True' else 'False' end as "C2=VC1",
    case when c2=vc2 then 'True' else 'False' end as "C2=VC2",
    case when c2=vc3 then 'True' else 'False' end as "C2=VC3"
from t;


SQL> select 
  2      case when c2=c3 then 'True' else 'False' end as "C2=C3",
  3      case when c2=vc1 then 'True' else 'False' end as "C2=VC1",
  4      case when c2=vc2 then 'True' else 'False' end as "C2=VC2",
  5      case when c2=vc3 then 'True' else 'False' end as "C2=VC3"
  6  from t;

C2=C3 C2=VC C2=VC C2=VC
----- ----- ----- -----
True  False False False

select 
    case when c3=vc1 then 'True' else 'False' end as "C3=VC1",
    case when c3=vc2 then 'True' else 'False' end as "C3=VC2",
    case when c3=vc3 then 'True' else 'False' end as "C3=VC3"
from t;

SQL> select 
  2      case when c3=vc1 then 'True' else 'False' end as "C3=VC1",
  3      case when c3=vc2 then 'True' else 'False' end as "C3=VC2",
  4      case when c3=vc3 then 'True' else 'False' end as "C3=VC3"
  5  from t;

C3=VC C3=VC C3=VC
----- ----- -----
False False False

select 
    case when vc1=vc2 then 'True' else 'False' end as "VC1=VC2",
    case when vc1=vc3 then 'True' else 'False' end as "VC1=VC3",
    case when vc2=vc3 then 'True' else 'False' end as "VC2=VC3"
from t;

SQL> select 
  2      case when vc1=vc2 then 'True' else 'False' end as "VC1=VC2",
  3      case when vc1=vc3 then 'True' else 'False' end as "VC1=VC3",
  4      case when vc2=vc3 then 'True' else 'False' end as "VC2=VC3"
  5  from t;

VC1=V VC1=V VC2=V
----- ----- -----
False False False

select * from t;
select dump(c1) from t;
select dump(c2) from t;
select dump(c3) from t;
select dump(vc1) from t;
select dump(vc2) from t;
select dump(vc3) from t;


SQL> select * from t;

C1         C2         C3         VC1        VC2        VC3       
---------- ---------- ---------- ---------- ---------- ----------
a          a          a          a          a          a         

SQL> select dump(c1) from t;

DUMP(C1)                                                                        
--------------------------------------------------------------------------------
Typ=96 Len=10: 97,32,32,32,32,32,32,32,32,32                                    

SQL> select dump(c2) from t;

DUMP(C2)                                                                        
--------------------------------------------------------------------------------
Typ=96 Len=10: 97,32,32,32,32,32,32,32,32,32                                    

SQL> select dump(c3) from t;

DUMP(C3)                                                                        
--------------------------------------------------------------------------------
Typ=96 Len=10: 97,32,32,32,32,32,32,32,32,32                                    

SQL> select dump(vc1) from t;

DUMP(VC1)                                                                       
--------------------------------------------------------------------------------
Typ=1 Len=1: 97                                                                 

SQL> select dump(vc2) from t;

DUMP(VC2)                                                                       
--------------------------------------------------------------------------------
Typ=1 Len=2: 97,32                                                              

SQL> select dump(vc3) from t;

DUMP(VC3)                                                                       
--------------------------------------------------------------------------------
Typ=1 Len=3: 97,32,32                                                           


SQL> select * from t where c1=vc1;
no rows selected

SQL> select * from t where trim(c1)=vc1;

C1         C2         C3         VC1        VC2        VC3       
---------- ---------- ---------- ---------- ---------- ----------
a          a          a          a          a          a         