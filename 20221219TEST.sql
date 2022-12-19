--3
declare
    cursor c_emp_cursor is
        select e.first_name a, e.hire_date b, d.department_name c
            from employees e, departments d
            where e.department_id = d.department_id
            and e.department_id = &v_department_id;  
begin
    for emp_record in c_emp_cursor
    loop
        dbms_output.put_line(emp_record.a
            ||' '||emp_record.b
            ||' '||emp_record.c);
    end loop;
end;
/
--3(2) 매개변수 사용시 작성하다 귀찮아서 그만 둠
declare
    v_empna employees.first_name%type;
    v_edate employees.hire_date%type;
    v_dept departments.department_name%type;
    v_depno departments.department_id%type;
    cursor c_emp_cursor (v_depno employees.department_id%type) is 
        select e.first_name a, e.hire_date b, d.department_name c
            from employees e, departments d
            where e.department_id = d.department_id
            and e.department_id = &v_depno;  
begin
    open c_emp_cursor(v_depno);
    loop
        fetch c_emp_cursor into v_empna, v_edate, v_dept;
            exit when c_emp_cursor%notfound;
        dbms_output.put_line(v_empna||' '||v_edate||' '||v_dept);
    end loop;
end;
/
--4
declare
    cursor c_emp_cursor is
        select employee_id, first_name, department_id
            from employees
            where department_id = &v_department_id;  
begin
    for emp_record in c_emp_cursor
    loop
        dbms_output.put_line(emp_record.employee_id
            ||' '||emp_record.first_name
            ||' '||emp_record.department_id);
    end loop;
end;
/
--5
declare
    cursor c_emp_cursor is
        select first_name, salary, commission_pct
            from employees
            where department_id = &v_department_id;
    v_newsal employees.salary%type;
begin
    for emp_record in c_emp_cursor
    loop
        v_newsal := (emp_record.salary*12+(emp_record.salary*nvl(emp_record.commission_pct,0)*12));
        dbms_output.put_line(emp_record.first_name
            ||' '||emp_record.salary
            ||' '||v_newsal);
    end loop;
end;
/
--6
declare
    cursor c_emp_cursor is
        select job_id, avg(salary) as "A"
            from employees
            where department_id = &v_department_id
            group by job_id;
begin
    for emp_record in c_emp_cursor
    loop
        dbms_output.put_line(emp_record.job_id ||' '|| emp_record.A);
    end loop;
end;
/
--7
truncate table test01;
truncate table test02;
select * from test01;
select * from test02;
select * from employees;
declare
    cursor c_emp_cursor is
        select employee_id, first_name, hire_date, salary
            from employees;
begin
    for emp_record in c_emp_cursor
    loop
        if emp_record.salary >= 5000 then
            insert into test01
                values (emp_record.employee_id,
                        emp_record.first_name,
                        emp_record.hire_date);
        else
            insert into test02 
                values (emp_record.employee_id,
                        emp_record.first_name,
                        emp_record.hire_date);
        end if;
    end loop;
end;
/
--
--예외처리
drop table emp_test;
create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;
select * from emp_test;
--1
declare
    e_invalid exception;
begin
    delete from emp_test
        where employee_id = &emp_id;
    if sql%notfound then
        raise e_invalid;
    end if;
    exception
        when e_invalid then
        DBMS_OUTPUT.PUT_LINE('id가 없습니다');
end;
/
--2
declare
    v_empid employees.employee_id%type := &emp_id;
    v_date employees.hire_date%type;
    e_invalid Exception;
begin
    select employee_id, salary, hire_date
        into v_empid, v_date
        from employees
        where employee_id = v_empid;
    if to_char(v_date, 'yyyy')< 2000 then
        update employees set salary = salary*1.1
            where employee_id = v_empid;
    else 
        raise e_invalid;
    end if;
    exception
        when e_invalid then
            dbms_output.put_line('2000년 이후 입사한 사원입니다.');
        when no_data_found then
            dbms_output.put_line('없는 사원입니다.');
end;
/
select * from employees;

--3 뒤에 보기
declare
    cursor c_emp_cursor is
        select * from employees
            where department_id = &id;
    e_name exception;
begin
    for emp_v_list in c_emp_cursor
    loop
        update employees set salary = salary * 1.1
            where department_id = emp_v_list.department_id;
            dbms_output.put_line(c_emp_cursor%rowcount);
    end loop;
    open c_emp_cursor;
    dbms_output.put_line(c_emp_cursor%rowcount);
    if c_emp_cursor%rowcount=0  then
        raise e_name;
    end if;
    exception
    when e_name then
        dbms_output.put_line('해당 부서에 사원없음');
    close c_emp_cursor;
end;
/
select * from employees;





















