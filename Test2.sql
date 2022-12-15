select * from employees;
--1
select * from employees where hire_date>'02/01/01' and job_id='st_clerk';
--2
select FIRST_NAME, JOB_ID, JOB_ID, COMMISSION_PCT from employees where COMMISSION_PCT is not null order by salary desc;
--3
select salary*1.1 "new Salary" from employees where COMMISSION_PCT is null;
--4
select last_name, round(months_between(sysdate, HIRE_DATE)/12) "year",round(months_between(sysdate, HIRE_DATE)) "month" from employees;
--5  ?
select last_name from employees where last_name in ('J%','K%','L%','M%');
--6 
select last_name, SALARY, nvl2(COMMISSION_PCT, 'yes', 'no') "com" from employees;
--7
select d.department_name, e.first_name, e.job_id, e.salary
    from employees e, departments d
    where e.department_id=d.department_id
    and d.location_id=1800;
--8(1)
select count(first_name) from employees  where first_name like '%n';
--9??
select  department_id, department_name, location_id, count(*)
    from (select d.department_id, d.department_name, d.location_id, employee_id
            from departments d left outer join employees e
                on (d.department_id=e.department_id))
        group by department_id, department_name, location_id;
        
select;
select  department_id, count(*)
        from employees group by department_id;
--10
select e.job_id
    from employees e, departments d
    where e.department_id = d.department_id
    and e.department_id in (10,20);
--11
select e.job_id
    from employees e, departments d
    where e.department_id=d.department_id
    and d.department_name in('Administration', 'Executive');    
--12
select last_name, hire_date from employees where to_char(hire_date,'dd') between 1
                                                            and 15;
--13
select last_name, salary, salary/1000 "thousands"  from employees;

--14
select last_name, manager, salary, gra from employees;

--15
select department_id,
       min(salary) 
    from employees
    group by department_id
    having avg(salary)>=(select max(avg(salary)) from employees group by department_id);








    select * from departments;
    select * from employees;
 select employee_id, first_name, department_name
       -- into v_emp_id, v_emp_name, v_dept_name
        from employees, departments
        where employees.department_id = departments.department_id
        and employee_id =100;