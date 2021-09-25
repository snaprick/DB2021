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
    id int NOT NULL PRIMARY KEY,
    full_name varchar NOT NULL,
    age int NOT NULL,
    birth_date date NOT NULL,
    gender varchar NOT NULL,
    avg_grade double precision NOT NULL,
    info text NOT NULL,
    need_for_dorm boolean NOT NULL,
    add_info text
);
CREATE TABLE instructors(
    id int NOT NULL PRIMARY KEY,
    full_name varchar NOT NULL,
    work_experience varchar NOT NULL,
    remote_lessons boolean NOT NULL
);

CREATE TABLE languages(
    instructor_id int NOT NULL,
    language_name varchar NOT NULL,
    PRIMARY KEY(instructor_id,language_name),
    FOREIGN KEY(instructor_id) REFERENCES instructors(id)
);

CREATE TABLE lesson_participants(
    id int NOT NULL,
    lesson_title varchar,
    instructor_id int,
    room_num int NOT NULL,
    student_id int NOT NULL,
    PRIMARY KEY(id,lesson_title,student_id),
    FOREIGN KEY(instructor_id) REFERENCES instructors(id),
    FOREIGN KEY(student_id) REFERENCES students(id)
);



--Task 4
INSERT INTO customers VALUES('1','Yesmoldin Yerlab','2021-09-23 02:37:30','Tole bi 59');
INSERT INTO orders VALUES(1,1,500,true);
INSERT INTO products VALUES(1,'cucumber','southern greenhouse cucumbers',200.00);
INSERT INTO order_items VALUES(1,1,5);

UPDATE customers SET full_name='Yerbolov Aidyn' WHERE delivery_address='Tole bi 59';
UPDATE orders SET is_paid=false WHERE is_paid = true;
UPDATE products SET name='pomidor' WHERE price = 200.00;
UPDATE order_items SET quantity=10 WHERE quantity = 5;

DELETE FROM order_items WHERE order_code=1;
DELETE FROM products WHERE name='pomidor';
DELETE FROM orders WHERE is_paid = false;
DELETE FROM customers WHERE delivery_address='Tole bi 59';

