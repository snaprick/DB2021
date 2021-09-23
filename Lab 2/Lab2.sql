--task1
CREATE TABLE students(
    id int,
    name varchar(50),
    age int,
    address varchar(255),
    phone_number varchar(20)
);
ALTER TABLE
students
ADD PRIMARY KEY (id);
INSERT INTO students VALUES ('12345','Yerlan','19','Tole bi 59','7014595588');
UPDATE students SET id = '54321' WHERE id = '12345';
DELETE FROM students WHERE name = 'Yerlan';
SELECT name FROM students WHERE id = '12345';
TRUNCATE TABLE students;
DROP TABLE students;

--task2
CREATE TABLE customers (
    id int NOT NULL PRIMARY KEY,
    full_name varchar(50) NOT NULL,
    timestamp timestamp NOT NULL,
    delivery_address text NOT NULL
);
CREATE TABLE orders (
    code int NOT NULL PRIMARY KEY,
    customer_id int REFERENCES customers(id),
    total_sum double precision NOT NULL CHECK(total_sum>0),
    is_paid boolean NOT NULL
);
CREATE TABLE products (
    id varchar NOT NULL PRIMARY KEY,
    name varchar NOT NULL UNIQUE ,
    description text  ,
    price double precision NOT NULL CHECK (price > 0)
);
CREATE TABLE order_items(
    order_code int REFERENCES orders(code),
    product_id varchar references products(id),
    quantity int NOT NULL CHECK ( quantity>0 ),
    PRIMARY KEY (order_code,product_id)
);

--task3
CREATE TABLE students(
    full_name varchar PRIMARY KEY,
    age integer NOT NULL,
    birth_date date NOT NULL,
    gender varchar NOT NULL,
    average_grade double precision NOT NULL,
    information text NOT NULL,
    need_for_dorm boolean NOT NULL,
    additional_info text
);
CREATE TABLE instructors(
    full_name varchar PRIMARY KEY,
    remote_lessons boolean NOT NULL
);

CREATE TABLE work_exp(
    instructor_name varchar NOT NULL,
    company_name varchar NOT NULL,
    PRIMARY KEY(instructor_name,company_name),
    FOREIGN KEY(instructor_name) REFERENCES instructors(full_name)
);

CREATE TABLE languages(
    instructor_name varchar NOT NULL,
    language_name varchar NOT NULL,
    PRIMARY KEY(instructor_name,language_name),
    FOREIGN KEY(instructor_name) REFERENCES instructors(full_name)
);

CREATE TABLE lesson_participants(
    lesson_title varchar,
    instructor varchar,
    room_num integer NOT NULL,
    PRIMARY KEY(lesson_title,instructor),
    FOREIGN KEY(instructor) REFERENCES instructors(full_name)
);

CREATE TABLE studying_students(
    full_name varchar NOT NULL,
    studying_lesson varchar NOT NULL,
    teaching_instructor varchar NOT NULL,
    PRIMARY KEY(full_name,studying_lesson),
    FOREIGN KEY(studying_lesson,teaching_instructor) REFERENCES lesson_participants,
    FOREIGN KEY(full_name) REFERENCES students(full_name)
);




--Task 4
INSERT INTO customers values('1','Yesmoldin Yerlab','2021-09-23 02:37:30','Tole bi 59');
INSERT INTO orders values(1,1,500,true);
INSERT INTO products values(1,'cucumber','southern greenhouse cucumbers',200.00);
INSERT INTO order_items values(1,1,5);

UPDATE customers SET delivery_address='Turgut Ozala 70' WHERE delivery_address='Tole bi 59';
UPDATE orders SET total_sum=1200 where code=1;
UPDATE products SET price=175.00 where name='cucumber';
UPDATE order_items SET quantity=3 where quantity = 5;

DELETE FROM order_items WHERE order_code=1;
DELETE FROM products WHERE name='cucumber';
DELETE FROM orders WHERE code=1;
DELETE FROM customers WHERE delivery_address='Turgut Ozala 70';

