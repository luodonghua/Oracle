create or replace package myload as
  procedure my_insert(pct number);
  procedure my_update(pct number);
  procedure my_delete(pct number);
  procedure p_insert(n integer);
  procedure p_update(minval integer, maxval integer, n integer);
  procedure p_delete(minval integer, maxval integer, n integer);
end;
/

create or replace package body myload as
    
  procedure my_insert(pct number)
  as
    current_cnt integer;
    delta_cnt integer;
  begin
    select count(*) into current_cnt from t;
    -- insert number of rows based on pct of current rowcount
    delta_cnt := round(current_cnt*pct);
    p_insert(delta_cnt);
  end;

  procedure my_update(pct number)
  as
    current_cnt integer;
    minval integer;
    maxval integer;
    delta_cnt integer;
  begin
    select count(*),min(id),max(id) into current_cnt,minval,maxval from t;
    -- update number of rows based on pct of current rowcount
    delta_cnt := round(current_cnt*pct);
    -- dbms_output.put_line(current_cnt||','||minval||','||maxval);
    p_update(minval,maxval,delta_cnt);
  end;

  procedure my_delete(pct number)
  as
    current_cnt integer;
    minval integer;
    maxval integer;
    delta_cnt integer;
  begin
    select count(*),min(id),max(id) into current_cnt,minval,maxval from t;
    -- update number of rows based on pct of current rowcount
    delta_cnt := round(current_cnt*pct);
    -- dbms_output.put_line(current_cnt||','||minval||','||maxval);
    p_delete(minval,maxval,delta_cnt);
  end;

  procedure p_insert(n integer)
  as
    batch_count integer;
    per_batch integer default 1000;
  begin
    if mod(n,per_batch) = 0 then
      batch_count := n/per_batch - 1;
    else
      batch_count := floor(n/per_batch);
    end if;
    for i in 0..batch_count loop
      if i < batch_count then
        insert into t (value) select rpad('a',900,'a') from dual connect by level <= per_batch;
        commit;
      else
        insert into t (value) select rpad('a',900,'a') from dual connect by level <= (n-per_batch*batch_count);
        commit;
      end if;
    end loop;
  end;

  procedure p_update(minval integer, maxval integer, n integer)
  as
    per_batch integer default 1000;
  begin
    for i in 1..n loop
      update t set value=rpad(to_char(sysdate,'yyyymmdd'),900,'a'),last_update=sysdate where id>dbms_random.value(minval,maxval) and rownum=1;
      if mod(i,per_batch) = 0 then
        commit;
      end if;
    end loop;
    commit;
  end;

  procedure p_delete(minval integer, maxval integer, n integer)
  as
    per_batch integer default 1000;
  begin
    for i in 1..n loop
      delete from t where id>dbms_random.value(minval,maxval) and rownum=1;
      if mod(i,per_batch) = 0 then
        commit;
      end if;
    end loop;
    commit;
  end;
  
end;
/
