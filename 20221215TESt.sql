--�����ȣ�� �Է�(ġȯ�������&)�� ���
--�����ȣ, ����̸�, �μ��̸�
--�� ����ϴ� PL/SQL�� �ۼ�
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
--�����ȣ�� �Է�(ġȯ�������&)�� ���
--����̸�, �޿�, ���� -> (�޿�*12+(nvl(�޿�,0)*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
--�� ����ϴ� pl/sql�� �ۼ��Ͻÿ�
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
--�����ȣ�� �Է�(ġȯ�������&)�� ���
--�Ի����� 2000�� ����(2000�� ����)�̸� 'New employee' ���
--2000�� �����̸� 'Career employee'���
--��Ʈ) case when then ���� ���
declare
    v_empid employees.employee_id%TYPE;
    v_st varchar2(20); 
begin
    select employee_id,
            case when to_char(hire_date,'yyyy')>=2000 then 'New employee' --to_date�� ���� ����Ȯ..?? 
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

--�����ȣ�� �Է��ϴ� ���(&ġȯ���� ���)\
--������̺�(employees)����
--�����ȣ(employee_id), ����̸�(last_name), �Ի���(hire_date)�� test01���̺� �Է��ϴ� pl/sql�� �ۼ�
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