set SERVEROUTPUT ON

declare
    cursor c_emp_cursor
    is
    select employee_id, last_name
    from employees;
begin
    for emp_record in c_emp_cursor
    loop
        dbms_output.put_line(emp_record.employee_id
            ||' '||emp_record.last_name);
    end loop;
end;
/
--extract으로 바꾸기
declare
    cursor c_emp_cursor is
        select employee_id, first_name, hire_date
            from employees;
begin
    for emp_record in c_emp_cursor
    loop
        if extract(year from emp_record.hire_date)
            >= 2000 then
            insert into test01 values emp_record;
        else
            insert into test02 values emp_record;
        end if;
    end loop;
end;
/
--커서선언없이 서브쿼리로 사용하기..
--declare가 필요 없음..but %isopen %rowcount등의 속성을 쓸 수 없음
begin
    for emp_record in
        (select employee_id, last_name
            from employees)
    loop
        dbms_output.put_line(emp_record.employee_id
            ||' '||emp_record.last_name);
    end loop;
end;
/
--
--매개변수(parameter) 사용 커서
declare
    v_empno employees.employee_id%type;
    v_ename employees.last_name%type;
    cursor emp_cursor (
                        v_detpno number,
                        v_job varchar2
                    )
    is
        select employee_id, last_name
            from employees
            where department_id = v_detpno
            and job_id = v_job;
        
begin
    open emp_cursor(60, 'IT_PROG');
    loop
        fetch emp_cursor into v_empno, v_ename;
            exit when emp_cursor%notfound;
            dbms_output.put_line(v_empno||' '||v_ename);
    end loop;
    close emp_cursor;
end;
/
--where current 절
declare
    cursor sal_cursor is
        select salary
            from employees
            where department_id = 30
            for update of salary nowait;
begin
    for emp_record in sal_cursor
    loop
        update employees
            set salary = emp_record.salary * 1.10
            where current of sal_cursor;
    end loop;
end;
/
--예외트랩(기본사용)
declare
    v_lname varchar2(15);
begin
    select last_name into v_lname
        from employees;
        dbms_output.put_line(v_lname);
    exception
        when too_many_rows then
        dbms_output.put_line('too many rows');
end;
/
--예외정의
declare
    e_insert_excep exception;
    pragma exception_init(e_insert_excep, -01400);
begin
    insert into departments
        (department_id, department_name)
            values (280, null);
    exception
        when e_insert_excep then
            dbms_output.put_line('오류');
end;
/
--sqlcode // sqlerrm
declare
    v_error_code    number;
    v_error_message varchar2(255);
begin
    insert into departments
        (department_id, department_name)
            values (280, null);
    exception
        when others then
            v_error_code    := sqlcode;
            v_error_message := sqlerrm;
            dbms_output.put_line(sqlcode ||' :: '||sqlerrm);
end;
/
--사용자정의(1)
declare
    v_deptno number := 500;
    v_name varchar2(20) := 'Testing';
    e_invalid_department Exception;
begin
    update departments
        set department_name = v_name
        where department_id = v_deptno;
    if sql%notfound then
        raise e_invalid_department;
    end if;
    exception
        when e_invalid_department then
        dbms_output.put_line('no~');
end;
/
--사용자정의 예외처리2
declare
    e_name exception;
begin
    delete from employees
        where last_name = '&id';
    if sql%notfound then
        raise e_name;
    end if;
    exception
    when e_name then
        --dbms_output.put_line('사원no');
        raise_application_error(-20999, '해당사원no');
end;
/
--(2)
declare
    e_name exception;
begin
    delete from employees
        where last_name = '&id';
    if sql%notfound then
        raise_application_error(-20999,'no');
    end if;
end;
/
--In 프로시져
create procedure raise_salary
    (   p_id        in employees.employee_id%type,
        p_percent   in number)
    is
    begin
        update employees
        set salary = salary * (1+p_percent/100)
        where employee_id = p_id;
    end raise_salary;
    /
select employee_id, salary from employees where employee_id=200;

execute raise_salary(200, 10);
begin
    raise_salary(200, 10);
end;
/
--OUT 매개변수
create or replace procedure query_emp
    (   p_id        in  employees.employee_id%type,
        p_name      out employees.last_name%type,
        p_salary    out employees.salary%type)
is
begin
    select last_name, salary
        into p_name, p_salary
        from employees
        where employee_id = p_id;
end query_emp;
/
--OUT2
declare
    v_emp_name  employees.last_name%type;
    v_emp_sal   employees.salary%type;
begin
    query_emp(100, v_emp_name, v_emp_sal);
    dbms_output.put_line(v_emp_name ||' earns '||
    to_char(v_emp_sal, '$999,999,00'));
end;
/
select * from employees;

--INOUT 전화번호 출력
create or replace procedure format_phone
    (p_phone_no in out varchar2)
is
begin
    p_phone_no := '(' || substr(p_phone_no, 1, 3) ||
                  ')' || substr(p_phone_no, 4, 3) ||
                  '-' || substr(p_phone_no, 7);
end foramt_phone;
/
--프로시저
create or replace procedure add_dept(
    p_name  in  departments.department_name%type,
    p_loc   in  departments.location_id%type)
is
begin
    insert into departments(
            department_id,
            department_name,
            location_id)
        values (departments_seq.nextval, p_name, p_loc);
end add_dept;
/
execute add_dept('TRAINING', 2500);
execute add_dept(p_loc=>2500, p_name=>'Education');
select * from departments;

--프로시저 중첩
select employee_id, salary from employees;

create or replace procedure process_emps
is
    cursor emp_cursor
    is
        select employee_id from employees;
begin
    for emp_rec in emp_cursor
    loop
        raise_salary(emp_rec.employee_id, 10);
    end loop;
end process_emps;
/
execute process_emps;
--
--익셉션
create or replace procedure add_department(
    p_name  varchar2,
    p_mgr number,
    p_loc number)
is
begin
    insert into departments
            (department_id, department_name, manager_id, location_id)
    values (departments_seq.nextval, p_name, p_mgr, p_loc);
    DBMS_OUTPUT.PUT_line('added dept: '|| p_name);
exception
    when others then
    DBMS_OUTPUT.PUT_line('Err: '|| p_name);
end;
/
create or replace procedure create_departments
is
begin
    add_department('Media', 100, 1800);
    add_department('Editing', 99, 1800);
    add_department('Advertising', 101, 1800);
end;
/
execute create_departments;
select * from departments;
delete from departments where department_id = 370;

describe add_department;

select text
  from user_source
  where name = 'format_phone' AND type = 'PROCEDURE'
  order by line;



