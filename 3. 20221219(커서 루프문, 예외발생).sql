--초기화 해주기..
set SERVEROUTPUT ON
-- 명시적 커서 + for loop를 사용하기..for loop암시적커서 닫음
declare
    cursor c_emp_cursor is
        select employee_id, last_name from employees;
        --where department_id = 30;
begin
    for emp_record in c_emp_cursor
    loop
        dbms_output.put_line(emp_record.employee_id
                             ||' ' ||emp_record.last_name);
    end loop; --암시적커서 닫음
end;
/
-- 금요일 오후 문제 for loop로 바꾸기
--1
declare
    cursor c_emp_cursor is
        select employee_id, first_name, hire_date
            from employees;
begin
    for emp_record in c_emp_cursor
    loop
        if to_char(emp_record.hire_date, 'yyyy') >= 2000 then
            insert into test01 values emp_record;
        else
            insert into test02 values emp_record;
        end if;
    end loop;
end;
/
select * from test02;
truncate table test01;

-- 커서선언없이 서브쿼리로 사용하기..
-- declare가 필요 없음 ..but %isopen %rowcount등의 커서속성은 쓸 수 없음
begin 
    for emp_record in (select employee_id, first_name, hire_date
                        from employees)
    loop
        if to_char(emp_record.hire_date, 'yyyy') >= 2000 then
            insert into test01 values emp_record;
        else
            insert into test02 values emp_record;
        end if;
    end loop;
end;
/
-- 예제가 없어 만들어 사용
-- 매개변수(parameter) 사용 커서
declare
    v_empno employees.employee_id%type;
    v_ename employees.last_name%type;
    cursor emp_cursor (v_deptno number, v_job varchar2) is
        select employee_id, last_name
            from employees
            where department_id = v_deptno
            and job_id = v_job;
begin
    open emp_cursor(60, 'IT_PROG');
    loop
        fetch emp_cursor into v_empno, v_ename;
            exit when emp_cursor%notfound;
        DBMS_OUTPUT.PUT_line(to_char(v_empno)||' '||v_ename);
    end loop;
    close emp_cursor;
end;
/
--where current of 절(책) ?
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
select * from employees;

--예외트랩( too many rows사용)
declare
    v_lname varchar2(15);
begin
    select last_name into v_lname
        from employees;
        dbms_output.put_line('john''s last name is :' || v_lname);
    exception -- 이 아래로 세줄 주석 하면 pls문 처리안되고 예외전달됨
        when too_many_rows then--
        dbms_output.put_line('Too many rows'); --
end;
/
--예외정의(-ORA 번호사용) -01400 널
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
--예외처리2(사용자정의1)
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
    --commit;
    exception
        when e_invalid_department then
        dbms_output.put_line('no such~~');
end;
/
--예외처리 내장(raise)(사용자정의2)
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
        -- 실행안됨
        --raise_application_error (-20999, '해당사원이 없습니다'); 
    
        --이건 실행 됨
        dbms_output.put_line('해당사원xx'); 
end;
/
--(2)
declare
    e_name exception;
begin
    delete from employees
        where last_name = '&id';
    if sql%notfound then
        raise_application_error ( -20999, '해당사원이 없습니다'); -- raise ~~ error 이건 표준이 아니어서 권장하진 않음
    end if;   
end;
/







