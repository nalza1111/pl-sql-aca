--시작시 이거 명령해주기 메시지 버퍼의 메시지가 표준 출력으로 경로 재지정되도록 지정
set SERVEROUTPUT ON
--간단 if문
declare
    v_myage number := 10;
begin
    if v_myage < 11 then
        dbms_output.put_line(' I am a child ');
    end if;
end;
/
--if else문 2가지
declare
    v_myage number := 31;
begin
    if v_myage < 11 then
        dbms_output.put_line(' I am a child ');
    else
        dbms_output.put_line(' I am not a child ');
    end if;
end;
/
--복합 if문
declare
    v_myage number := 39;
begin
    if v_myage < 11 then
        dbms_output.put_line(' I am a child ');
    elsif v_myage < 20 then
        dbms_output.put_line(' I am young ');
    elsif v_myage < 30 then
        dbms_output.put_line(' I am twenties ');
    elsif v_myage < 40 then
        dbms_output.put_line(' I am thirties ');
    else
        dbms_output.put_line(' I am always young ');
    end if;
end;
/
--loop
declare
    v_contryid  locations.country_id%type := 'CA';
    v_loc_id    locations.location_id%type;
    v_counter   number(2) := 1;
    v_new_city  locations.city%type := 'Montreal';
begin
    select max(location_id) into v_loc_id from locations
        where country_id = v_contryid;
    loop
        insert into locations(location_id, city, country_id)
            values((v_loc_id+v_counter), v_new_city, v_contryid);
        v_counter := v_counter + 1;
        exit when v_counter >3;
    end loop;
end;
/

select * from locations;

-- while roop
declare
    v_contryid  locations.country_id%type := 'CA';
    v_loc_id    locations.location_id%type;
    v_new_city  locations.city%type := 'Montreal';
    v_counter   number := 1;
begin
    select max(location_id) into v_loc_id from locations
        where country_id = v_contryid;
    
    while v_counter <= 3
    loop
        insert into locations(location_id, city, country_id)
            values((v_loc_id+v_counter), v_new_city, v_contryid);
        v_counter := v_counter + 1;
    end loop;
end;
/
--for loop
declare
    v_contryid  locations.country_id%type := 'CA';
    v_loc_id    locations.location_id%type;
    v_new_city  locations.city%type := 'Montreal';
begin
    select max(location_id) into v_loc_id
        from locations
        where country_id = v_contryid;
    for i in 1..3
    loop
        insert into locations(location_id, city, country_id)
            values((v_loc_id+i), v_new_city, v_contryid);
    end loop;
end;
/
select * from locations;