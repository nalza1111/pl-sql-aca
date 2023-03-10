--레코드 사용예제
declare
    type t_rec is record
           (v_sal number(8),
            v_minsal number(8) default 1000,
            v_hire_date employees.hire_date%type,
            v_recl employees%rowtype);
    v_myrec t_rec;
begin
    v_myrec.v_sal := v_myrec.v_minsal + 500;
    v_myrec.v_hire_date := sysdate;
    select * into v_myrec.v_recl
        from employees where employee_id = 100;
        dbms_output.put_line(v_myrec.v_recl.last_name 
        ||' '|| to_char(v_myrec.v_hire_date)
        || ' ' || to_char(v_myrec.v_sal));
end;

-- 테이블만들기
create table retired_emps (empno, ename, job, mgr, hiredate,
                           leavedate, sal, comm, deptno)
as
  select employee_id, last_name, job_id, manager_id, hire_date,
         sysdate, salary, commission_pct, department_id
  from   employees
  where  employee_id = 0;
--
/
declare
    v_emp_rec employees%rowtype;
begin
    select * into v_emp_rec from employees
        where employee_id = 124;
    insert into retired_emps
        values(v_emp_rec.EMPLOYEE_ID,
               v_emp_rec.LAST_NAME,
               v_emp_rec.JOB_ID,
               v_emp_rec.MANAGER_ID,
               v_emp_rec.HIRE_DATE,
               sysdate,
               v_emp_rec.SALARY,
               v_emp_rec.COMMISSION_PCT,
               v_emp_rec.DEPARTMENT_ID);
end;
/
select * from retired_emps;

-- 테이블
declare
    type    dept_table_type is table of
            departments%rowtype index by pls_integer;
    dept_table dept_table_type;
begin
    select * into dept_table(1)
                                from departments
                                where department_id = 10;
    dbms_output.put_line(dept_table(1).department_id ||' '||
    dept_table(1).department_name ||' '||
    dept_table(1).manager_id);
end;
/
--테이블2
declare
    type emp_table_type is table of
            employees%rowtype index by pls_integer;
    my_emp_table    emp_table_type;
begin
    for i in 100..104
    loop
    select * into my_emp_table(i) from employees
        where employee_id = i;
    end loop;
    for i in my_emp_table.first..my_emp_table.last
    loop
        dbms_output.put_line(my_emp_table(i).last_name);
    end loop;
end;
/
--3-7 넘버 테이블
declare
    type dept_table_type is table of number
        index by binary_integer;
    dept_table dept_table_type;
    v_total number;
begin
    for v_counter in 1..50 loop
        dept_table(v_counter) := v_counter;
    end loop;
    v_total := dept_table.count;
    dbms_output.put_line(v_total);
end;
/
--커서
declare
    cursor c_emp_cursor is
        select employee_id, last_name from employees;
        --where department_id = 30;
    v_empno employees.employee_id%type;
    v_lname employees.last_name%type;
begin
    open c_emp_cursor;
    loop
        fetch c_emp_cursor into v_empno, v_lname;
        exit when c_emp_cursor%notfound;
        dbms_output.put_line(v_empno ||' ' ||v_lname);
    end loop;
    close c_emp_cursor;
end;
/
-- 위의 문장을 커서 + 레코드 섞기
declare
    cursor c_emp_cursor is
        select employee_id, last_name from employees;
        --where department_id = 30;
    v_emp_record c_emp_cursor%rowtype;
begin
    open c_emp_cursor;
    loop
        fetch c_emp_cursor into v_emp_record;
        exit when c_emp_cursor%notfound;
        dbms_output.put_line(v_emp_record.employee_id
                             ||' ' ||v_emp_record.last_name);
    end loop;
    close c_emp_cursor;
end;
/















