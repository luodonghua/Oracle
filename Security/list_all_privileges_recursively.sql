select * from dba_role_privs where grantee='DBA';

select * from dba_roles;

select * from dba_sys_privs ;

select * from dba_tab_privs;

-- list all the granted_roles for any grantee
select granted_role from dba_role_privs 
connect by prior granted_role=grantee start with grantee='DONGHUA';

-- list all the granted system privleges for roles
select s.privilege,r.role from dba_sys_privs s join dba_roles r 
on s.grantee=r.role;

-- list all the granted object privileges for roles
select t.privilege||' on '|| t.owner||'.'||t.table_name privilege,r.role 
from dba_tab_privs t join dba_roles r on t.grantee=r.role;

-- prepare grantees table, include interested grantees and PUBLIC
WITH grantees AS (
    SELECT column_value AS grantees 
    FROM TABLE(
        sys.odcivarchar2list(
            'DBA', 
            'PUBLIC'
        )
    )
)
SELECT * FROM grantees;



-- final privlege resursive query, privilege granted to PUBLIC applies to all
WITH grantees AS (
    SELECT column_value AS grantees 
    FROM TABLE(
        sys.odcivarchar2list(
            'HR'
            --,'PUBLIC' 
        )
    )
)
select privilege, listagg(roles,',')  within group (order by roles) role_list
from (
    -- list all system privilege granted directly to grantees
    select s.privilege, 'S' as priv_type, null as roles  from dba_sys_privs s join grantees g 
    on s.grantee=g.grantees
    union
    -- list all object privilege granted directly to grantees
    select t.privilege||' on '|| t.owner||'.'||t.table_name privilege, 'O' as priv_type, null as roles 
    from dba_tab_privs t join grantees g on t.grantee=g.grantees
    union
    -- list all sys privilege granted through roles to grantees
    select s.privilege, 'S' as priv_type, r.role from dba_sys_privs s join dba_roles r 
    on s.grantee=r.role
    join (select granted_role from dba_role_privs 
    connect by prior granted_role=grantee start with grantee in (select * from grantees)) rr
    on r.role=rr.granted_role
    union
    -- list all object privilege granted through roles to grantees
    select t.privilege||' on '|| t.owner||'.'||t.table_name privilege, 'O' as priv_type, r.role 
    from dba_tab_privs t join dba_roles r on t.grantee=r.role
    join (select granted_role from dba_role_privs 
    connect by prior granted_role=grantee start with grantee in (select * from grantees)) rr
    on r.role=rr.granted_role
)
group by priv_type, privilege
order by priv_type DESC, privilege;
 
