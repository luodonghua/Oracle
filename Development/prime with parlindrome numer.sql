with prime_list 
as (select l prime_number
  from (select level l from dual connect by level <= 10000), 
       (select level m from dual connect by level <= 10000)
where m<=l
group by l
having count(case l/m when trunc(l/m) then 'Y' end) = 2
order by l)
select * from prime_list
where to_char(prime_number) = reverse(to_char(prime_number));