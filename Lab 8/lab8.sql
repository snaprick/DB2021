-- 1a
CREATE or REPLACE FUNCTION a(x integer)
RETURNS integer AS
    $$
        begin
        return x+1;
        end;
    $$
language 'plpgsql';

select a(5);
drop function a;
-- 1b
CREATE or REPLACE FUNCTION b(a integer,b integer)
returns integer as
    $$
        begin
            return a+b;
        end
    $$
language 'plpgsql';

select b(1,2);
drop function b;
-- 1c
CREATE or replace FUNCTION c(x integer)
returns boolean AS
    $$
        begin
            return x % 2 = 0;
        end;
    $$
language 'plpgsql';

select c(4);
drop function c;
--1d
CREATE or replace FUNCTION d(x text)
returns boolean as
    $$
        begin
            return exists(select REGEXP_MATCHES(x,'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'));
        end;
    $$
language 'plpgsql';

select d('1234567c');
drop function d;
--1 task e
create function e(a integer,out b varchar,out c varchar) as
    $$
    begin
        b=a+5;
        c=a*2;
    end;
    $$
language  'plpgsql';
select * from e(1);
drop function e;
-- 2 task
CREATE table people(
    id integer primary key,
    name varchar,
    date_of_birth date,
    age int,
    time timestamp
);

--2a
CREATE or replace FUNCTION ins_time()
returns trigger AS
    $$
        begin
            new.time = now();
            return new;
        end;
    $$
language 'plpgsql';

create trigger calc_time before insert or update on people
    for each row execute procedure ins_time();

insert into people(id, name) values (1, 'Yerlan');
update people set name = 'Yerla' where name = 'Yerlan';

drop trigger calc_time on people;
--2b
create or replace FUNCTION age()
returns trigger AS
    $$
        begin
            new.age = date_part('year', age(new.date_of_birth));
            return new;
        end;
    $$
language 'plpgsql';
create trigger calc_age before insert on people
    for each row execute procedure age();
insert into people(id, name, date_of_birth)  values (11, 'Yerlan', '11-11-2002');

drop trigger calc_age on people;
-- 2c
CREATE table product(
    id integer primary key,
    name varchar,
    price integer
);

create or replace FUNCTION price()
returns trigger as
    $$
        begin
            update product
            set price=price+0.12*price
            where id = new.id;
            return new;
        end;
    $$
language 'plpgsql';

create trigger calc_price after insert on product
    for each row execute procedure price();

insert into product(id, name,price) values (1, 'milk', 200);

insert into product(id,name,price) values (3, 'cheese', 223);

drop trigger calc_price on product;

-- 2d
create or replace function stop_del() returns trigger
    as $$
    begin
        insert into product(id,name,price) values(old.id,old.name,old.price);
        return old;
    end;
    $$
language 'plpgsql';

create trigger del_changes after delete on product
    for each row execute procedure stop_del();

delete from product where id=1;
select * from product;

drop trigger del_changes on product;
-- 2e

create table test(
    id int primary key,
    password varchar(255),
    number int,
    tax varchar(255),
    valid boolean
);

create or replace function test_f() returns trigger
    as $$
    begin
        new.valid = d(new.password);
        new.tax = e(new.number);
        return new;
    end;
    $$
language 'plpgsql';

create trigger test1 before insert or update on test
    for each row execute procedure test_f();

insert into test (id, password, number)
values (1,'123456',2);

drop trigger test1 on test;
-- 3 task
-- Procedures are basic PL SQL blocks to perform a specific action.Procedures will not return the value
-- Functions are blocks used mainly to perform the computations.Functions must return the value.
-- 4 task
create table employee(
    id int primary key,
    name varchar,
    date_of_birth date,
    age int,
    salary int,
    workexperience int,
    discount int
);
insert into employee values (1,'Yerlan','05-30-2002',19,10000,5,1);
--4a
CREATE or replace procedure salary1() as
$$
    begin
        update employee
        set salary = (workexperience/2)*1.1*salary,
            discount = (workexperience/2)*10 + employee.discount;
        update employee set discount = (workexperience/5) + employee.discount;
        commit;
    end;
    $$
language 'plpgsql';

call salary1();
-- 4b
create or replace procedure salary2() as
    $$
        begin
            update employee
            set salary = salary*1.15
            where age >= 40;
            update employee
            set salary = salary*1.15*(workexperience/8);
            update employee
            set discount = 20 where workexperience >= 8;
            commit;
        end;
    $$
language 'plpgsql';
call salary2();
-- 5 task
create table members(
    memid integer,
    surname varchar(200),
    firstname varchar(200),
    address varchar(300),
    zipcode integer,
    telephone varchar(20),
    recommendedby integer,
    joindate timestamp
);
with recursive recommenders(recommender, member) as (
	select recommendedby, memid from members
	union all
	select members.recommendedby, recommenders.member
	from recommenders inner join members on members.memid = recommenders.recommender
)
select recommenders.member member, recommenders.recommender, members.firstname, members.surname
	from recommenders inner join members on recommenders.recommender = members.memid
	where recommenders.member = 22 or recommenders.member = 12
order by recommenders.member ASC, recommenders.recommender desc;

insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (1, 'Jorgensen', 'Corie', '7 Dawn Drive', '11660000', '611-22-0684', null, '11/16/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (2, 'Padly', 'Marylee', '79513 Nobel Junction', null, '602-72-5101', null, '12/8/2020');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (3, 'Greenough', 'Clerkclaude', '2859 Center Crossing', '141986', '229-96-8163', null, '8/13/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (4, 'Kiefer', 'Jolie', '9884 Jackson Pass', '3776', '468-36-9756', 1, '8/28/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (5, 'Meanwell', 'Albertine', '3 Continental Parkway', null, '370-97-8983', 1, '3/8/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (6, 'Klicher', 'Dean', '2 Namekagon Park', null, '754-44-0475', null, '11/3/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (7, 'Binden', 'Bathsheba', '26272 Sage Parkway', '663580', '771-83-5322', 4, '8/21/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (8, 'Chander', 'Blake', '82971 Waubesa Street', null, '498-23-8837', 3, '9/4/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (9, 'Affleck', 'Fayette', '40254 Wayridge Lane', null, '111-89-1660', 6, '11/12/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (10, 'Swateridge', 'Jordan', '3 Rieder Trail', null, '221-74-3501', 1, '10/4/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (11, 'Wasling', 'Fay', '00 Hallows Way', '601136', '327-26-8655', 4, '8/8/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (12, 'Cattanach', 'Garvy', '05 Crowley Point', '81204', '394-26-6645', 9, '4/20/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (13, 'Attaway', 'Ferd', '56 Sunfield Circle', null, '337-41-5097', null, '12/26/2020');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (14, 'Himsworth', 'Felice', '16 Barnett Alley', '31', '866-52-4554', 1, '2/10/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (15, 'Raithby', 'Lin', '85 Bluejay Street', '7780325', '585-43-8588', 9, '9/13/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (16, 'Danilchev', 'Dewitt', '891 Shasta Road', null, '844-21-7275', 13, '8/18/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (17, 'Dootson', 'Sam', '42645 Arizona Way', null, '435-69-8218', 13, '12/31/2020');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (18, 'Beckworth', 'Quint', '3 Prairie Rose Pass', '69173', '303-40-9211', 5, '11/26/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (19, 'Honig', 'Pattin', '19775 Messerschmidt Park', null, '856-35-9801', 1, '3/23/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (20, 'Kunat', 'Benjie', '38 Transport Plaza', null, '571-67-7764', 5, '10/15/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (21, 'Beckworth', 'Quint', '3 Prairie Rose Pass', '69173', '303-40-9211', 1, '11/26/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (22, 'Honig', 'Pattin', '19775 Messerschmidt Park', null, '856-35-9801', 16, '3/23/2021');
insert into members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate) values (23, 'Kunat', 'Benjie', '38 Transport Plaza', null, '571-67-7764', 15, '10/15/2021');