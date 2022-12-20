--Function
create or replace function get_sal
    (   p_id employees.employee_id%type )
    return number
    is
        v_sal employees.salary%type := 0;
    begin
        select  salary
        into    v_sal
        from    employees
        where   employee_id = p_id;
    
        return v_sal;
    end get_sal;
    /
    
--function은 단독리턴값은 출력이 안되므로 dbms~쓰기
execute dbms_output.put_line(get_sal(100));

select job_id, get_sal(employee_id)
    from employees;

--function2
create or replace function tax(p_value in number)
return number
is
begin
    return (p_value * 0.08);
end tax;
/
select employee_id, last_name, salary, tax(salary)
    from employees
    where department_id = 90;
describe tax;

select text
from user_source
where type = 'FUNCTION'
order by line;

--패키지

--패키지 스펙만들기

create or replace package comm_pkg
is
    v_std_comm number := 0.10;
    procedure reset_comm(   p_new_comm number   );
end comm_pkg;
/
--바디만들기(150p)
create or replace package body comm_pkg
is
    function validate -- 전용함수
        (p_comm number)
    return boolean
    is
        v_max_comm  employees.commission_pct%type;
    begin
        select max(commission_pct) into v_max_comm
        from employees;
        return (p_comm between 0.0 and v_max_comm);
    end validate;

    procedure reset_comm -- 공용procedure
        (p_new_comm number)
    is
    begin
        if validate(p_new_comm) then
            v_std_comm := p_new_comm;
            DBMS_OUTPUT.PUT_LINE(p_new_comm||' right Commission');
        else raise_application_error(-20210, 'Bad Commission');
        end if;
    end reset_comm;
end comm_pkg;
/
--실행하기(151p)
execute comm_pkg.reset_comm(0.1);

--5-3
create or replace package global_consts
is
    mile_2_kilo constant number := 1.6093;
    kilo_2_yard constant number := 0.6214;
    yard_2_meter constant number := 0.9144;
    meter_2_yard constant number := 1.0936;
end global_consts;
/
execute DBMS_OUTPUT.PUT_LINE('20 miles =' || 20*global_consts.mile_2_kilo || ' km');


--오버로드
CREATE OR REPLACE PACKAGE dept_pkg IS
    PROCEDURE add_department
        (p_deptno departments.department_id%TYPE,
        p_name departments.department_name%TYPE :='unknown',
        p_loc departments.location_id%TYPE := 1700);
    PROCEDURE add_department
        (p_name departments.department_name%TYPE :='unknown',
        p_loc departments.location_id%TYPE := 1700);
END dept_pkg;
/

-- Package body of package defined on previous slide. 
CREATE OR REPLACE PACKAGE BODY dept_pkg IS
    PROCEDURE add_department
        (p_deptno departments.department_id%TYPE,
        p_name departments.department_name%TYPE := 'unknown',
        p_loc departments.location_id%TYPE := 1700) IS
    BEGIN
        INSERT INTO departments(department_id, 
        department_name, location_id)
        VALUES (p_deptno, p_name, p_loc);
    END add_department;
    PROCEDURE add_department
        (p_name departments.department_name%TYPE := 'unknown',
        p_loc departments.location_id%TYPE := 1700) IS
    BEGIN
    INSERT INTO departments (department_id,
        department_name, location_id)
        VALUES (departments_seq.NEXTVAL, p_name, p_loc);
    END add_department;
END dept_pkg;
/

EXECUTE dept_pkg.add_department(980,'Education',2500);
SELECT * FROM departments
WHERE department_id = 980;

EXECUTE dept_pkg.add_department ('Training', 2500);
SELECT * FROM departments
WHERE department_name = 'Training';





