--사원번호를 입력(치환변수사용&)할 경우
--사원번호, 사원이름, 부서이름
--을 출력하는 PL/SQL을 작성
declare
    v_empid employees.employee_id%TYPE;
    v_empname employees.first_name%TYPE;
    v_deptname departments.department_name%TYPE;
begin
    select employee_id, first_name, department_name
        into v_empid, v_empname, v_deptname
        from employees, departments
        where employees.department_id = departments.department_id
        and employee_id =&employee_id;
        dbms_output.put_line (v_empid);
        dbms_output.put_line (v_empname);
        dbms_output.put_line (v_deptname);
end;
/
--사원번호를 입력(치환변수사용&)할 경우
--사원이름, 급여, 연봉 -> (급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
--을 출력하는 pl/sql을 작성하시오
declare
    v_empid employees.employee_id%TYPE;
    v_empsal employees.salary%TYPE;
    v_com number(30);
begin
    select employee_id, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct, 0)*12))
        into v_empid, v_empsal, v_com
        from employees
        where employee_id =&employee_id;
        dbms_output.put_line (v_empid);
        dbms_output.put_line (v_empsal);
        dbms_output.put_line (v_com);
end;
/
select * from employees;
select employee_id, salary, (salary*12+(nvl(salary,0)*nvl(commission_pct, 0)*12))
        from employees
        where employee_id =100;
--사원번호를 입력(치환변수사용&)할 경우
--입사일이 2000년 이후(2000년 포함)이면 'New employee' 출력
--2000년 이전이면 'Career employee'출력
--힌트) case when then 구문 사용
declare
    v_empid employees.employee_id%TYPE;
    v_st varchar2(20); 
begin
    select employee_id,
            case when to_char(hire_date,'yyyy')>=2000 then 'New employee' --to_date를 쓰는 게정확..?? 
                 else 'Career employee' -- EXTRACT( year from hire_date) >= 2000 
                 end as AA
        into v_empid, v_st
        from employees
        where employee_id =&employee_id;
    dbms_output.put_line (v_st);
end;
/
select employee_id,
    case when to_char(hire_date,'yyyy')>=2000 then 'New employee'
         else 'Career employee'
    end as AA from employees;
    
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;
  
select * from test01;
select * from test02;

--사원번호를 입력하는 경우(&치환변수 사용)\
--사원테이블(employees)에서
--사워번호(employee_id), 사원이름(last_name), 입사일(hire_date)를 test01테이블에 입력하는 pl/sql을 작성
declare
    v_id employees.employee_id%type;
    v_name employees.last_name%type;
    v_date employees.hire_date%type;
begin
    select employee_id, last_name, hire_date
        into v_id, v_name, v_date
        from employees
        where employee_id=&employee_id;
    insert into test01 values(v_id, v_name, v_date);
end;
/