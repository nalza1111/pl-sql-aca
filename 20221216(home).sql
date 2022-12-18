set serveroutput on
--°£´Ü if ¹®
declare
    v_myage number:=31;
begin
    if v_myage < 11 then
      dbms_output.put_line('I am a child');
    end if;
end;
/
declare
    v_myage number:=31;
begin
    if v_myage < 11 then
        dbms_output.put_line('I am a child');
    else
         dbms_output.put_line('I am not a child');
    end if;
end;
/
declare
    v_myage number:=31;
begin
    if v_myage < 11 then
        dbms_output.put_line('I am a child');
    elsif v_myage < 20 then
         dbms_output.put_line('I am  in my twenties');
    elsif v_myage < 30 then
         dbms_output.put_line('I am  in my thirties');  
    else
         dbms_output.put_line('I am always young');
    end if;
end;
/
--loop
select * from locations;
declare
    v_countryid locations.country_id%type := 'CA';
    v_loc_id    locations.location_id%type;
    v_counter   number(2) := 1;
    v_new_city  locations.city%type := 'Montreal';
begin
    select max(location_id)
        into v_loc_id
        from locations
            where country_id = v_countryid;
    loop
        insert into locations(location_id, city, country_id)
            values((v_loc_id + v_counter), v_new_city, v_countryid);
        v_counter := v_counter + 1;
        exit when v_counter >3;
    end loop;
end;
/
--for loop
select * from locations;
declare
    v_countryid locations.country_id%type := 'CA';
    v_loc_id    locations.location_id%type;
    v_new_city  locations.city%type := 'Montreal';
begin
    select max(location_id)
        into v_loc_id
        from locations
            where country_id = v_countryid;
    for i in 1..3
    loop
        insert into locations(location_id, city, country_id)
            values((v_loc_id + i), v_new_city, v_countryid);
    end loop;
end;
/
--while loop
select * from locations;
declare
    v_countryid locations.country_id%type := 'CA';
    v_loc_id    locations.location_id%type;
    v_counter   number(2) := 1;
    v_new_city  locations.city%type := 'Montreal';
begin
    select max(location_id)
        into v_loc_id
        from locations
            where country_id = v_countryid;
    while v_counter <=3
    loop
        insert into locations(location_id, city, country_id)
            values((v_loc_id + v_counter), v_new_city, v_countryid);
        v_counter := v_counter + 1;
    end loop;
end;
/











