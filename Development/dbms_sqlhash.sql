SQL> desc hr.employees;
 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 EMPLOYEE_ID				   NOT NULL NUMBER(6)
 FIRST_NAME					    VARCHAR2(20)
 LAST_NAME				   NOT NULL VARCHAR2(25)
 EMAIL					   NOT NULL VARCHAR2(25)
 PHONE_NUMBER					    VARCHAR2(20)
 HIRE_DATE				   NOT NULL DATE
 JOB_ID 				   NOT NULL VARCHAR2(10)
 SALARY 					    NUMBER(8,2)
 COMMISSION_PCT 				    NUMBER(2,2)
 MANAGER_ID					    NUMBER(6)
 DEPARTMENT_ID					    NUMBER(4)


SQL> conn sys/MyPassword@orclpdb as sysdba
Connected.
SQL> grant execute on dbms_sqlhash to donghua;

Grant succeeded.

SQL> exit 

SQL> select DBMS_SQLHASH.GETHASH('select first_name,last_name,email,phone_number from hr.employees where department_id=20 order by employee_id', digest_type => 1) AS CHECKSUM_name
from hr.employees where department_id=20;  2  

CHECKSUM_NAME
--------------------------------------------------------------------------------
0C56C4A43776C9D6D2FADFB19E66BB39
0C56C4A43776C9D6D2FADFB19E66BB39

SQL> select DBMS_SQLHASH.GETHASH('select first_name,last_name,email,phone_number from hr.employees where department_id=20 order by employee_id desc', digest_type => 1) AS CHECKSUM_name
from hr.employees where department_id=20;  2  

CHECKSUM_NAME
--------------------------------------------------------------------------------
998C641109416FFD056DAA01F7B812A3
998C641109416FFD056DAA01F7B812A3


create table employees_checksum (department_id number(4), checksum varchar2(32));

set serveroutput on

declare
    checksum_sqlstr         varchar2(4000);
    sqlstr                  varchar2(4000);
begin
for x in (select distinct department_id from hr.employees) loop
    checksum_sqlstr := 'select first_name,last_name,email,phone_number from hr.employees where nvl(department_id,0)='
                ||nvl(x.department_id,0)
                ||' order by employee_id';
    sqlstr := 'insert into employees_checksum '
                ||'select department_id,  DBMS_SQLHASH.GETHASH('''||checksum_sqlstr||''', digest_type => 1)'
                ||' from hr.employees where nvl(department_id,0)='
                ||nvl(x.department_id,0)
                ||' and rownum<2';
    -- dbms_output.put_line(sqlstr);
    execute immediate sqlstr;
end loop;
    commit;
end;
/

SQL> declare
  2  	 checksum_sqlstr	 varchar2(4000);
  3  	 sqlstr 		 varchar2(4000);
  4  begin
  5  for x in (select distinct department_id from hr.employees) loop
  6  	 checksum_sqlstr := 'select first_name,last_name,email,phone_number from hr.employees where nvl(department_id,0)='
  7  		     ||nvl(x.department_id,0)
  8  		     ||' order by employee_id';
  9  	 sqlstr := 'insert into employees_checksum '
 10  		     ||'select department_id,  DBMS_SQLHASH.GETHASH('''||checksum_sqlstr||''', digest_type => 1)'
 11  		     ||' from hr.employees where nvl(department_id,0)='
 12  		     ||nvl(x.department_id,0)
 13  		     ||' and rownum<2';
 14  	 -- dbms_output.put_line(sqlstr);
 15  	 execute immediate sqlstr;
 16  end loop;
 17  	 commit;
 18  end;
 19  /

PL/SQL procedure successfully completed.

PL/SQL procedure successfully completed.


SQL> set pages 999
SQL> select * from employees_checksum;

DEPARTMENT_ID CHECKSUM
------------- --------------------------------
	   50 A6BFC686D3679081DF6902611E9D1B02
	   40 BD4343C24B17025F42DE0C883B8FBFD4
	  110 655B31A4F52A890644762DA455CBFAE7
	   90 A06A56BAF15D93199B516E2BD1D6859C
	   30 93075A4E9148F632754DDAE25D27501D
	   70 BBB81A15EF868BDF58AC6413D0D9F30D
	      4E2AD54458D717515E1F03E9E15B5CB5
	   10 4A7530FD304C33417AE1A3A28789E588
	   20 0C56C4A43776C9D6D2FADFB19E66BB39
	   60 DECF74AA42F30D7B328C65CFCF0F261E
	  100 2619291F1E4859CA6AE1F808EC865947
	   80 CDD39E1E1ABB15B005E47794F094F6DC

12 rows selected.


insert into employees_checksum 
select department_id,
        DBMS_SQLHASH.GETHASH('select first_name,last_name,email,phone_number from
                            hr.employees where nvl(department_id,0)=80 order by employee_id'
                            , digest_type =>1) 
from hr.employees 
where nvl(department_id,0)=80 and rownum<2


-- NEW APPROACH in 20c USING SQL FUNCTION
/*
SELECT
deptno,
CHECKSUM(ename) as CHECKSUM_NAME
FROM emp
WHERE deptno=20 GROUP BY deptno ORDER BY deptno;
*/
