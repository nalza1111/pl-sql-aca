--IN ���ν���
create procedure raise_salary
    (   p_id        in employees.employee_id%type,
        p_percent   in number)
    is
    begin
        update  employees
        set     salary = salary * (1 + p_percent/100)
        where   employee_id =p_id;
    end raise_salary;
    /
select employee_id, salary from employees where employee_id=200;
--1 ���ν��� ������
execute raise_salary(200, 10);
--2 ���ν��� ������
begin
    raise_salary(200, 10);
end;
/
--OUT �Ű�����
create or replace procedure query_emp
    (   p_id        in employees.employee_id%type,
        p_name      out employees.last_name%type,
        p_salary    out employees.salary%type   )is
begin
    select last_name, salary into p_name, p_salary
        from employees
        where employee_id = p_id;
end query_emp;
/

declare
    v_emp_name  employees.last_name%type;
    v_emp_sal   employees.salary%type;
begin
    query_emp(100, v_emp_name, v_emp_sal);
    dbms_output.put_line(v_emp_name ||' earns '||
        to_char(v_emp_sal, '$999,999.00'));
end;
/
--INOUT ��ȭ��ȣ ��� --> 64������ �ؿ� �κ� sql���ʷ� ����
CREATE or replace procedure format_phone
    (p_phone_no in out varchar2)
is
begin
    p_phone_no := '(' || substr(p_phone_no,1,3) ||
                   ')' || substr(p_phone_no,4,3) ||
                   '-' || substr(p_phone_no,7);
end format_phone;
/
--In ���ν��� 68p
create or replace procedure add_dept(
    p_name in   departments.department_name%type,
    p_loc in    departments.location_id%type)
is
begin
    insert into departments(
                            department_id,
                            department_name,
                            location_id
                            )
        values (
                    departments_seq.nextval,
                    p_name,
                    p_loc
                );
end add_dept;
/
--����
execute add_dept('TRAINING', 2500);
select * from departments;
--�����ϴ� ��2 ���� ������ �� ��
execute add_dept(p_loc=>2500, p_name=>'EDUCATION');

--���ν��� ��ø
select employee_id, salary from employees;

-- �Ű������� ����--���ุ�ϸ鵹�ư�
create or replace procedure process_emps 
is --������� ��� ...����� �����̿� �Ϲݺ������� ����!!!
    cursor emp_cursor
    is
        select employee_id
        from employees;
begin --���⼭ ����
    for emp_rec in emp_cursor
    loop
        raise_salary(emp_rec.employee_id, 10);
    end loop;
end process_emps;
/
--�Ű����� ���� ���ν������
execute process_emps;
/
--76������ �ͼ��� �ƴ���
create or replace procedure add_department(
                p_name varchar2,
                p_mgr number,
                p_loc number
            )
is
begin
    insert into departments (
                    department_id, department_name, manager_id, location_id)
        values (departments_seq.nextval, p_name, p_mgr, p_loc);
    DBMS_OUTPUT.PUT_line('added dept: '|| p_name);
exception --
    when others then --
    DBMS_OUTPUT.PUT_line('err: adding depg:' || p_name);     -- ��� ���� �ּ�ó���ϸ� ...
end;
/
create procedure create_departments
is
begin
    add_department('Media', 100, 1800);
    add_department('Editing', 99, 1800);
    add_department('Advertising', 101, 1800);

end;
/


execute create_departments; --�̰� �������� �� �����ɸ�
--
describe user_source;

--
select text
  from user_source
  where name = 'ADD_DEPT' AND type = 'PROCEDURE'
  order by line;
  











