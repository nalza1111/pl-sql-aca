--�ʱ�ȭ ���ֱ�..
set SERVEROUTPUT ON
-- ����� Ŀ�� + for loop�� ����ϱ�
declare
    cursor c_emp_cursor is
        select employee_id, last_name from employees;
        --where department_id = 30;
begin
    for emp_record in c_emp_cursor
    loop
        dbms_output.put_line(emp_record.employee_id
                             ||' ' ||emp_record.last_name);
    end loop;
end;
/
-- �ݿ��� ���� ���� for loop�� �ٲٱ�
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
select * from test01;
truncate table test02;
--Ŀ��������� ���������� ����ϱ�(declare�� �ʿ� ������..but %isoften %rowcount������ �� ��)
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
-- ������ ���� ����� ���
-- �Ű�����(parameter) ��� Ŀ��
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
--where currnet of ��(å) ?
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

--����Ʈ��
declare
    v_lname varchar2(15);
begin
    select last_name into v_lname
        from employees;
        dbms_output.put_line('john''s last name is :' || v_lname);
    exception -- �� �Ʒ��� ���� �ּ� �ϸ� pls�� ó���ȵǰ� �������޵�
        when too_many_rows then--
        dbms_output.put_line('Too many rows'); --
end;
/
--��������
declare
    e_insert_excep exception;
    pragma exception_init(e_insert_excep, -01400);
begin
    insert into departments
        (department_id, department_name)
        values (280, null);
    exception   
        when e_insert_excep then
            dbms_output.put_line('����');
end;
/
--����ó��2
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
--����ó�� ����(raise)
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
        --plspl ����ȵ�
        --raise_application_error (-20999, '�ش����� �����ϴ�'); 
        --�̰� plspl�����
        dbms_output.put_line('�ش���xx'); --�̰� ���� ��
end;
/
--(2)
declare
    e_name exception;
begin
    delete from employees
        where last_name = '&id';
    if sql%notfound then
        raise_application_error ( -20999, '�ش����� �����ϴ�'); -- raise ~~ error �̰� ǥ���� �ƴϾ �������� ����
    end if;   
end;
/







