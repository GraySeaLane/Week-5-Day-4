SELECT *
FROM customer;

ALTER TABLE customer-- WILL CHANGE INFO ON TABLE IN SOME WAY -DDL
ADD phone_number VARCHAR(20);

-- UPDATING DATA INSIDE OF A TABLE -DML
UPDATE customer -- updating table name
SET phone_number = '773-202-LUNA' --setting data in column
WHERE customer_id = 1; -- a cond for the data to be set

UPDATE customer -- updating table name
SET phone_number = '630-852-8289' --setting data in column
WHERE customer_id = 5; -- a cond for the data to be set



SELECT *
FROM customer;

SELECT *
FROM order_;

ALTER TABLE order_
ADD order_quantity INTEGER,
ADD staff_first VARCHAR(50),
ADD staff_last VARCHAR(50),
ADD price INTEGER;

SELECT *
FROM order_;

ALTER TABLE order_
ALTER price TYPE NUMERIC(6,2);

UPDATE order_
SET order_quantity = 3, staff_first = 'Rod', staff_last = 'Kimble', price = 250.00
WHERE order_id = 1;

SELECT *
FROM order_;


CREATE TABLE staff(
staff_id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(50)

);

ALTER TABLE staff
DROP COLUMN email;

SELECT *
FROM staff;

DROP TABLE staff CASCADE;

SELECT * 
FROM customer;

SELECT *
FROM order_;

DROP TABLE customer CASCADE;

