--4.1

select date_part('month',sales.date) as Month, brand_name, count(*) as cnt
        from sales inner join customer c on c.id = sales.customer_id inner join vehicles v on sales.vin = v.vin inner join models m on v.model_name = m.name
        group by Month, brand_name
        order by Month;

select to_char(sales.date, 'Month') as Month, brand_name, count(*) as cnt_male
        from sales
            inner join customer c on c.id = sales.customer_id
            inner join vehicles v on sales.vin = v.vin
            inner join models m on v.model_name = m.name
            where gender = 'Male'
            group by Month, brand_name
            order by Month;

select to_char(sales.date, 'Month') as Month, brand_name, count(*) as cnt_female
        from sales
                 inner join customer c on c.id = sales.customer_id
                 inner join vehicles v on sales.vin = v.vin
                 inner join models m on v.model_name = m.name
        where gender = 'Female'
        group by Month, brand_name
        order by Month;

create or replace function trend(type varchar(255),brand varchar(255))
returns table(
    time2 varchar,
    cnt int
    )
as $$
    begin
        return query select to_char(sales.date, type)::varchar as time2, count(*)::int as cnt
        from sales inner join customer c on c.id = sales.customer_id inner join vehicles v on sales.vin = v.vin inner join models m on v.model_name = m.name
        where m.brand_name = brand
        group by time2
        order by time2;
    end;
$$
language plpgsql;

drop function trend;
select * from trend('MM','Hyundai');

select brand_name, sum(price)
from sales inner join vehicles v on sales.vin = v.vin inner join models m on v.model_name = m.name
group by brand_name;

--4.2
select s.vin, first_name, last_name
from customer c inner join sales s on c.id = s.customer_id inner join vehicles on vehicles.vin = s.vin where transmission_id in (
        select id from parts
        where name = 'Transmission' and suppliers_name = 'Getrag' and date>='1/1/2015' and date <= '12/12/2020'
    );
--4.3
select brand_name, sum(price)
from sales inner join vehicles v on sales.vin = v.vin inner join models m on v.model_name = m.name
group by brand_name
order by sum(price) desc
limit 2;
--4.4
select brand_name, count(*)
from sales inner join vehicles v on sales.vin = v.vin inner join models m on v.model_name = m.name
group by brand_name
order by count(*)desc
limit 2;
--4.5
SELECT date_part('month',sales.date) AS Month, count(*)
from sales inner join vehicles v on sales.vin = v.vin inner join models m on v.model_name = m.name
where convertible = true
group by Month
order by Month;
--4.6
select name, date_part('days',avg(now()-i1.date)) as time
from inventory_cars i1 inner join inventory i2 on i1.inventory_id = i2.id inner join dealers d on d.id = i2.dealer_id
group by name
order by time desc;


