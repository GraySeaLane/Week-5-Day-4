--Tonight create two procedures that do the following:

--1. EXTRA CREDIT: Create a procedure that adds a late fee to any customer who returned their rental after 7 days.
--Use the payment and rental tables. Create a stored function that you call inside your procedure. The function will calculate the late fee amount based on how many days late they returned their rental.

--Worked on CodeWars and workshop =>

--2. Add a new column in the customer table for Platinum Member. This can be a boolean.
--Platinum Members are any customers who have spent over $200. 
--Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200 and False for any customer who has spent less than $200.
--Use the payment and customer table.

ALTER TABLE customer
ADD COLUMN platinum_member BOOLEAN DEFAULT False;
 
 
CREATE OR REPLACE PROCEDURE my_platinum_member()
LANGUAGE plpgsql -- setting the query language for the procedure
AS $$
	BEGIN
		-- 
		UPDATE customer
		SET platinum_member = True
		WHERE customer_id IN(
			SELECT customer_id
			FROM payment
			GROUP BY payment.customer_id
			HAVING SUM(amount) > 200
			
);
COMMIT;
END;
$$

CALL my_platinum_member()

select *
from customer
ORDER BY platinum_member DESC;


---------------------------------------------------------------------------

SELECT *
FROM payment;

-- Creating a stored procedure
-- simulating a late fee charge to a customer who was mean

CREATE OR REPLACE PROCEDURE late_fee(
		customer INTEGER, -- customer_id parameter
		late_payment INTEGER, -- payment_id parameter
		late_fee_amount DECIMAL(4,2) -- amount for latefee

)
LANGUAGE plpgsql -- setting the query language for the procedure
AS $$
BEGIN
		-- Add a late fee to customer payment amount
		UPDATE payment
		SET amount = amount + late_fee_amount
		WHERE customer_id = customer AND payment_id = late_payment;
		
		--Commit our update statement inside of our transaction
		COMMIT;
END;
$$

-- Calling a stored procedure
CALL late_fee(341, 17503, 3.50);

-- 7.99
-- 11.49
SELECT *
FROM payment
WHERE payment_id = 17503 AND customer_id = 341;

DROP PROCEDURE late_fee;

-- Stored Functions Example
-- Insert data into the actor table
CREATE OR REPLACE FUNCTION add_actor(
		_actor_id INTEGER,
		_first_name VARCHAR,
		_last_name VARCHAR,
		_last_update TIMESTAMP WITHOUT TIME ZONE)
RETURNS void
LANGUAGE plpgsql
AS $MAIN$
BEGIN
		INSERT INTO actor
		VALUES(_actor_id, _first_name, _last_name, _last_update);
END;
$MAIN$

-- DO NOT 'CALL' A FUNCTION -- SELECT IT
SELECT add_actor(500, 'Orlando', 'Bloom', NOW()::TIMESTAMP);

SELECT *
FROM actor
WHERE actor_id = 500;

-- function to grab return total rentals
CREATE FUNCTION get_total_rentals()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN (SELECT SUM(amount) FROM payment);
	END;
$$;

SELECT get_total_rentals();

-- A function to get a discount that a procedure will use to apply that discount
CREATE OR REPLACE FUNCTION get_discount(price NUMERIC, percentage INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	BEGIN
		RETURN (price * percentage/100);
	END;
$$

-- procedure that alters the data in a column using the get_discount function
CREATE PROCEDURE apply_discount(percentage INTEGER, _payment_id INTEGER)
AS $$
	BEGIN
		UPDATE payment
		SET amount = get_discount(payment.amount, percentage)
		WHERE payment_id = _payment_id;
	END;
$$ LANGUAGE plpgsql;

SELECT *
FROM payment;

CALL apply_discount(20, 17517);

SELECT *
FROM payment 
WHERE payment_id = 17517;