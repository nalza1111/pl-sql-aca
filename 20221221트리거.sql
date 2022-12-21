SET SERVEROUTPUT ON

create table testTBL(
                        id number,
                        txt varchar2(100)
                        );
insert into testTBL values (1, '스프링');
insert into testTBL values (2, '자바스크립트');
insert into testTBL values (3, 'PL/SQL');

select * from testTBL;

create trigger testTrg
    after delete or update
    on testTBL
    for each row
begin
    dbms_output.put_line('트리거가 작동했습니다.');
END;
/
begin
    insert into testTBL values (4, '클라우드 컴퓨팅');
    update testTBL set txt = '스프링 부트' where id = 1;
    delete testTBL where id = 4; 
END;
/
--문장트리거
