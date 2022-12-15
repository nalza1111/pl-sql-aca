declare
    v_fname varchar2(20);
begin
    select first_name into v_fname from employees
    where employee_id=100;
    DBMS_OUTPUT.put_line('The First Name of ther Employee id'||v_fname);
end;
/
declare
    v_myName varchar2(20);
begin
    DBMS_OUTPUT.PUT_LINE('My name is:'||v_myName);
    v_myname := 'John';
    DBMS_OUTPUT.PUT_Line('My name is:'||v_myName);
END;    
/   
declare
    v_myName  varchar2(20) := 'John';
begin
    v_myName := 'Steven';
    DBMS_OUTPUT.PUT_LINE('My name is:'||v_myName);
end;
/
VARIABLE b_result NUMBER;
BEGIN
SELECT (SALARY*12) + NVL(COMMISSION_PCT,0) INTO :b_result
FROM employees WHERE employee_id = 100;
END;
/
PRINT b_result;
declare
    v_salary number(6) := rr;
    v_sal_hike varchar2(5) := '1000';
    v_total_salary v_salary%TYPE;
begin
    DBMS_OUTPUT.PUT_line(v_total_salary);
    v_total_salary := v_salary + v_sal_hike;
    DBMS_OUTPUT.PUT_line(v_total_salary);
end;
/
declare
    v_father_name varchar2(20) := 'Patrick';
    v_date_of_birth date := '1992/04/20';
begin
    declare
        v_child_name varchar2(20) := 'Mike';
        v_date_of_birth date := '199/04/02';
    begin
        DBMS_OUTPUT.PUT_LINE(v_father_name);
        DBMS_OUTPUT.PUT_LINE(v_child_name);
        DBMS_OUTPUT.PUT_LINE(v_date_of_birth);
    end;
        DBMS_OUTPUT.PUT_LINE(v_date_of_birth);
end;
/
declare
    v_weight number(3) := 600;
    v_message varchar2(255) := 'Product 10012';
begin
    declare
        v_weight number(7,2) := 50000;
        v_message varchar2(255) := 'Product 11001';
        v_new_locn varchar2(50) := 'Europe';
    begin
        v_weight := v_weight+1;
        v_new_locn := 'Western'||v_new_locn;
        dbms_output.put_line(v_weight);
        dbms_output.put_line(v_message);
        dbms_output.put_line(v_new_locn);
    end;
        dbms_output.put_line(v_weight);
        dbms_output.put_line(v_message);
end;
/
declare
    v_emp_hiredate  employees.hire_date%type;
    v_emp_salary    employees.salary%type;
begin
    select  hire_date, salary
    into    v_emp_hiredate, v_emp_salary
    from    employees
    where   employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('Hire_date is: '||v_emp_hiredate);
    DBMS_OUTPUT.PUT_LINE('salary is: '||v_emp_salary);
end;
/
declare
    v_sum_sal   number(10, 2);
    v_deptno    number not null := 60;
begin
    select sum(salary)
    into v_sum_sal from employees
    where department_id = v_deptno;
    DBMS_OUTPUT.PUT_LINE('The sum of salary is ' || v_sum_sal);
end;
/
declare
    deptno  employees.department_id%type := 10;
begin
    delete from employees
    where department_id = deptno;
end;
/
declare
    sal_increase employees.salary%type := 800;
begin
    update employees
        set salary = salary + sal_increase
    where job_id = upper('ST_CLERK');
end;
/
declare
    deptno employees.department_id%type := 30;
begin
    delete from employees
    where department_id = deptno;
end;
/
rollback;

declare
    v_rows_deleted  varchar2(30);
    v_empno         employees.employee_id%Type := 176;
begin
    delete from employees
    where employee_id = v_empno;
    v_rows_deleted := (sql%rowcount|| 'row deleted.');
    DBMS_OUTPUT.PUT_LINE(v_rows_deleted);
end;
/



