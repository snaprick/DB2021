create table car_company(
    name varchar(255) not null primary key,
    foundation_date date not null
);

create table brands(
    name varchar(255) not null primary key,
    comp_name varchar(255)  references car_company(name)
);

create table models(
    name varchar(255) not null primary key,
    year int not null,
    doors int not null,
    convertible bool not null,
    body_type varchar(255) not null,
    brand_name varchar(255)  references brands(name)
);

create table options(
    id int not null primary key ,
    color varchar(255) not null,
    engine varchar(255) not null,
    transmission varchar(255) not null
);
create table suppliers(
    name varchar(255) not null primary key,
    city varchar(255) not null,
    street varchar(255) not null,
    zip int not null
);
create table parts(
    id int not null primary key,
    name varchar(255) not null,
    date date not null,
    suppliers_name varchar(255) references suppliers(name)
);

create table factory(
    id int not null primary key,
    name varchar(255) references car_company(name)
);
create table assembly(
    vin int not null primary key ,
    transmission_id int references parts(id),
    engine_id int references parts(id),
    factory_id int references factory(id)
);



create table company_suppliers(
    name varchar(255) not null primary key,
    comp_name varchar(255) references car_company(name)
);

create table vehicles(
    VIN int not null primary key references assembly(vin),
    day int not null,
    month int not null,
    year int not null,
    price int not null,
    option_id int  references options(id)
);



create table customer(
    id int not null  primary key,
    first_name varchar(255) not null,
    last_name varchar(255) not null,
    city varchar(255) not null,
    street varchar(255) not null,
    zip int not null,
    gender varchar(255) not null,
    annual_income int not null
);

create table customers_phones(
    id int not null  primary key,
    phone_number varchar(255) not null,
    customer_id int  references customer(id)
);

create table dealers(
    id int not null  primary key,
    name varchar(255) not null,
    city varchar(255) not null,
    street varchar(255) not null,
    zip int not null
);

create table dealers_phones(
    id int not null  primary key,
    phone_number varchar(255) not null,
    dealer_id int  references dealers(id)
);

create table sales(
    id int not null  primary key,
    week int not null,
    month int not null,
    year int not null,
    --brand_name varchar(255)  references brands(name),
    --model_name varchar(255)   references models(name),
    --color_id int  references options(id),
    vin int  references vehicles(VIN),
    dealer_id int  references dealers(id),
    customer_id int references customer(id)
);

create table inventory(
    id int not null  primary key,
    dealer_id int  references dealers(id),
    city varchar(255) not null,
    street varchar(255) not null,
    zip int not null,
    capacity int not null
);

create table inventory_cars(
    id int not null  primary key,
    vin int  references vehicles(VIN),
    inventory_id int  references inventory(id),
    date date not null,
    factory_id int references factory(id)
);



