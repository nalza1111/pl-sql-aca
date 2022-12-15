select *from employees;
--1
select * from employees
    where to_char(hire_date,'yy/mm/dd')>'02/01/01'
    and job_id = upper('st_clerk');
--2
select last_NAME, JOB_ID, salary, COMMISSION_PCT
    from employees
    where COMMISSION_PCT is not null
    order by 3 desc;
--3
select 'The salary of '
       ||first_name||
       ' after a 10% raise is'
       || round(salary*1.1) "new Salary"
    from employees
    where COMMISSION_PCT is null;
--4
select last_name,
       trunc(months_between(sysdate, HIRE_DATE)/12) "year",
       round(mod(months_between(sysdate, HIRE_DATE),12)) "month"
       from employees;
--5  ?
select last_name
    from employees
    where upper(substr(last_name,1,1)) in ('J','K','L','M');
--6 
select last_name,
       SALARY,
       nvl2(COMMISSION_PCT, 'yes', 'no') "com"
       from employees;
select last_name,
       SALARY,
       decode(COMMISSION_PCT, null, 'no', 'yes') comm from employees;

select last_name,
       salary,
       case when COMMISSION_PCT is null then 'no'
             else 'yes' end as comm
    from employees;
--7
select d.department_name, e.first_name, e.job_id, e.salary
    from employees e, departments d
    where e.department_id=d.department_id
    and d.location_id=1800;
--8(1)
select count(*)
    from employees
    where lower(first_name)
    like '%n';
--9??
select  department_id, department_name, location_id, count(*)
    from (select d.department_id, d.department_name, d.location_id, employee_id
            from departments d left outer join employees e
                on (d.department_id=e.department_id))
        group by department_id, department_name, location_id;
      
--10
select job_id
    from employees
    where department_id in (10,20);
--11
select e.job_id, count(e.job_id) as frequency
    from employees e, departments d
    where e.department_id=d.department_id
    and lower(d.department_name) in('administration', 'executive')
    group by e.job_id order by 2 desc;    
--12
select last_name, hire_date
    from employees
    where to_char(hire_date,'dd') < 16;
--13
select last_name, salary, trunc(salary, -3)/1000 thousands  from employees;

--14
select distinct l.last_name, r.last_name as "manager", l.salary, j.grade_level as "gra"
    from employees l, employees r, job_grades j
    where l.employee_id = r.employee_id
      and l.salary between lowest_sal and j.highest_sal
      and l.salary > 15000;

--15
select department_id,
       min(salary) 
    from employees
    group by department_id
    having avg(salary)>=(select max(avg(salary)) from employees group by department_id);





select * from job_grades;

select * from job_grades;
select * from departments;
select * from employees;
 select employee_id, first_name, department_name
       -- into v_emp_id, v_emp_name, v_dept_name
        from employees, departments
        where employees.department_id = departments.department_id
        and employee_id =100;
        
CREATE TABLE job_grades (
grade 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);

ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade);

INSERT INTO job_grades VALUES ('A', 1000, 2999);
INSERT INTO job_grades VALUES ('B', 3000, 5999);
INSERT INTO job_grades VALUES ('C', 6000, 9999);
INSERT INTO job_grades VALUES ('D', 10000, 14999);
INSERT INTO job_grades VALUES ('E', 15000, 24999);
INSERT INTO job_grades VALUES ('F', 25000, 40000);

COMMIT;

