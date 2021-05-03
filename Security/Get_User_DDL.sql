-- set long 20000 longchunksize 20000 pagesize 0 linesize 1000 feedback off verify off trimspool on
-- column ddl format a1000

begin
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
   dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);
end;
/

with g as (select 'DONGHUA' as grantee from dual)
select dbms_metadata.get_ddl('USER', u.username) AS ddl
from   dba_users u, g
where  u.username = g.grantee
union all
select dbms_metadata.get_granted_ddl('TABLESPACE_QUOTA', tq.username) AS ddl
from   dba_ts_quotas tq, g
where  tq.username = g.grantee
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('ROLE_GRANT', rp.grantee) AS ddl
from   dba_role_privs rp, g
where  rp.grantee = g.grantee
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('SYSTEM_GRANT', sp.grantee) AS ddl
from   dba_sys_privs sp, g
where  sp.grantee = g.grantee
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('OBJECT_GRANT', tp.grantee) AS ddl
from   dba_tab_privs tp, g
where  tp.grantee = g.grantee
and    rownum = 1
union all
select dbms_metadata.get_granted_ddl('DEFAULT_ROLE', rp.grantee) AS ddl
from   dba_role_privs rp, g
where  rp.grantee = g.grantee
and    rp.default_role = 'YES'
and    rownum = 1
union all
select to_clob('/* Start profile creation script in case they are missing') AS ddl
from   dba_users u, g
where  u.username = g.grantee
and    u.profile <> 'DEFAULT'
and    rownum = 1
union all
select dbms_metadata.get_ddl('PROFILE', u.profile) AS ddl
from   dba_users u, g
where  u.username = g.grantee
and    u.profile <> 'DEFAULT'
union all
select to_clob('End profile creation script */') AS ddl
from   dba_users u, g
where  u.username = g.grantee
and    u.profile <> 'DEFAULT'
and    rownum = 1
;
