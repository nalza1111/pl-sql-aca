SET SERVEROUTPUT ON

create table testTBL(
                        id number,
                        txt varchar2(100)
                        );
insert into testTBL values (1, '������');
insert into testTBL values (2, '�ڹٽ�ũ��Ʈ');
insert into testTBL values (3, 'PL/SQL');

select * from testTBL;

create trigger testTrg
    after delete or update
    on testTBL
    for each row
begin
    dbms_output.put_line('Ʈ���Ű� �۵��߽��ϴ�.');
END;
/
begin
    insert into testTBL values (4, 'Ŭ���� ��ǻ��');
    update testTBL set txt = '������ ��Ʈ' where id = 1;
    delete testTBL where id = 4; 
END;
/
--����Ʈ����
