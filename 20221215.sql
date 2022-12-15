set serveroutput on

declare
    v_fname varchar2(20);
begin
    select first_name into v_fname from employees
    where employee_id=100;
    DBMS_OUTPUT.PUT_LINE(' The First Name of the Employe is ' || v_fname); --print()와 같음
end;
/
declare
    v_myName varchar2(20);
begin
    dbms_output.put_line('My name is: '|| v_myName);
    v_myName := 'John';
    dbms_output.put_line('My name is: '|| v_myName);
end;
/
declare
    v_myName varchar2(20):= 'john';
begin
    dbms_output.put_line('My name is: '|| v_myName);
    v_myName := 'steven';
    dbms_output.put_line('My name is: '|| v_myName);
end;
/
DECLARE
    v_name employees.last_name%TYPE;
    --v_naem varchar2(10)이렇게 지정하지 않고 변수타입을 바로가져옴
begin
    select last_name
    into v_name
    from employees
    where employee_id = 100;
    
    dbms_output.put_line('My name is ' || v_name);
end;
/
variable b_result number
begin
    select (salary*12) + nvl(commission_pct, 0)
                    into : b_result
        from employees where employee_id = 100;
end;
--데이터타입이 다른데 실행이 됨
/
declare
    v_salary number(6) := 6000;
    v_sal_hike varchar2(5) := '1000';
    -- v_sal_hike2 varchar2(5) := '가나';
    v_total_salary v_salary%TYPE;
    -- v_total_salary2 v_salary%TYPE;
begin
    v_total_salary := v_salary + v_sal_hike;
    -- v_total_salary2 := v_salary + v_sal_hike2;
    --오라클의 pl sql은 자동변환됨
    --문자는 변환되지않음
    dbms_output.put_line(v_total_salary);
    -- dbms_output.put_line(v_total_salary2);
end;
/
declare
    v_father_name varchar2(20):='Patrick';
    v_date_of_birth date:='1992/04/20';
begin
    declare
        v_child_name varchar2(20):='Mike';
        v_date_of_birth date:='2002/12/12';
    begin
        dbms_output.put_line('Fater''s Name: '||v_father_name);
        dbms_output.put_line('Date of Birth: '||v_date_of_birth);
        dbms_output.put_line('child''s Name: '||v_child_name);
    end;
    dbms_output.put_line('Date of Birth: '||v_date_of_birth);
end;
/
declare
    v_weight number(3) := 600;
    v_message varchar2(255) := 'product 10012';
begin
    declare
        v_weight number(7,2) := 50000;
        v_message varchar2(255):='product 11001';
        v_new_locn varchar2(50):='europe';
    begin
        v_weight := v_weight+1;
        v_new_locn := 'western' ||v_new_locn;
        dbms_output.put_line(v_weight);
        dbms_output.put_line(v_message);
        dbms_output.put_line(v_new_locn);
    end;
    v_weight := v_weight + 1;
    v_message := v_message|| 'is in stock';
    --v_new_lonc:='western'||v_new_locn;
    dbms_output.put_line(v_weight);
    dbms_output.put_line(v_message);
    --dbms_output.put_line(v_new_locn);
end;
/
declare
    v_emp_hiredate employees.hire_date%TYPE;
    v_emp_salary employees.salary%TYPE;
begin
    select hire_date, salary
    into v_emp_hiredate, v_emp_salary
    from employees
    where employee_id = 100;
    dbms_output.put_line ('Hire date is :'|| v_emp_hiredate);
    dbms_output.put_line ('Salary is :'|| v_emp_salary);
end;
/
declare
    v_sum_sal number(10, 2);
    v_deptno number not null := 60; --not null 초기값할당
begin
    select sum(salary)
    into v_sum_sal from employees
    where department_id = v_deptno;
    dbms_output.put_line('The sum of salary is ' || v_sum_sal);
end;
/
declare
    sal_increase employees.salary%TYPE := 800;
begin
    update employees
            set salary = salary + sal_increase
        where job_id = upper('ST_CLERk');
end;
/

select * from employees;

declare
    deptno employees.department_id%type := 30;
begin
    delete from employees
    where department_id = deptno;
end;
/
ROLLBACK;
select * from employees;

declare
    v_rows_deleted varchar2(30);
--    v_empno employees.employee_id%TYPE := 176;
begin
    delete from job_grades;
--    where employee_id = v_empno;
    v_rows_deleted := (sql%rowcount || ' row deleted.');
    dbms_output.put_line(v_rows_deleted);
end;
/














    
    