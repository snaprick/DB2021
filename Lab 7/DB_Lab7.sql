--1
--We can use clob(character large object)-object is a large collection of character data
--for text and e.t.c.
-- and blob(binary large object)- object is a large collection of uninterpreted binary data.
-- for image, videos
--2
--Roles are created by users (usually administrators) and are used to group together privileges or other roles.
-- They are a means of facilitating the granting of multiple privileges or roles to users.
--A user privilege is a right to execute a particular type of SQL statement,
-- or a right to access another user's object
--User is someone who can log in and is a member of one or more groups
create role accountant;
grant insert,update,delete on accounts,transactions to accountant;

create role administrator;
grant accountant,support to administrator with admin option;

create role support;
grant select on accounts,customers,transactions to support,accountant;

create user user1 with login password '123';
grant accountant to user1;

create user user2 with login password '123';
grant administrator to user2;

create user user3 with login password '123';
grant support to user3;
grant update on accounts to user3;
revoke update on accounts from user3;

create user user4 with login password '123';
grant support to user4;

--3

alter table transactions alter column amount SET NOT NULL;
alter table transactions alter column date SET NOT NULL;
alter table transactions alter column status SET NOT NULL;
insert into transactions values (4,now(),'RS88012','NT10204',null,'init');

update accounts set "limit" = 0 where "limit" is null;
alter table accounts alter column currency SET NOT NULL;
alter table accounts alter column balance SET NOT NULL;
alter table accounts alter column "limit" SET NOT NULL;
insert into accounts values ('RS12345',205,null,100,0);

alter table customers alter column name SET NOT NULL;
alter table customers alter column birth_date SET NOT NULL;
insert into customers values (204,null,null);
--4
create domain ddd as varchar(3);
ALTER TABLE accounts ALTER COLUMN currency TYPE ddd;
--5
create unique index index1 on accounts (customer_id,currency);
insert into accounts values ('RS12345',201,'KZT',5000,0);

create index find_accounts on accounts(currency,balance);
create index find_by_sender on transactions(src_account);
create index find_by_recipient on transactions(dst_account);

--6

do
$$
begin
    insert into transactions values (5,now(),'AB10203','NK90123',50,'init');
    begin
        update accounts set balance = balance - 50 where account_id = 'AB10203';
        update accounts set balance = balance + 50 where account_id = 'NK90123';
        update transactions set status = 'commited' where id = 5;
        exception
            when others then
                update transactions set status = 'rollback' where id = 5;
    end;
end
$$;

ALTER TABLE accounts ADD CONSTRAINT limit_check CHECK (balance > "limit");

--simple example of commit
do
$$
begin
    update accounts set balance = balance + 50 where account_id = 'AB10203';
    commit;
end
$$;
--simple example of rollback
do
$$
begin
    update accounts set balance = balance + 50 where account_id = 'AB10203';
    rollback;
    commit;
end
$$;