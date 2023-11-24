USE production;
USE sales;

CALL uspFINDProductByModel(2016, @count_price);

-- create a function and function have must return value and can be used in
-- select statement
-- THE same output
SELECT * FROM customers
WHERE LOCATE('yahoo', email) > 0;

SELECT *
FROM customers
WHERE LOCATE(LOWER('@yahoo'), LOWER(email)) > 0;

SELECT * FROM customers
WHERE email LIKE '%@yahoo%';

SELECT
    email,
    SUBSTRING(
        email,
        LOCATE('@', email) + 1,
        LENGTH(email) - LOCATE('@', email) + 1
    ) AS "Domain"
FROM customers;

SELECT  CURRENT_TIMESTAMP AS "TIMESTAMP", NOW() AS "NOW";

SELECT NOW() AS "Current Date",
       DATE_ADD(NOW(), INTERVAL 5 DAY) AS "Added Days";

-- CREATE A PROCEDURE TO FIND DOMAIN BY NAME
DELIMITER $$
CREATE PROCEDURE SelectDomain(
    IN domain_name TEXT
)
    BEGIN
        SELECT
            customer_id, first_name, last_name, email, street, city, state,
            SUBSTRING(
                email,
                LOCATE('@', email) + 1,
                LENGTH(email) - LOCATE('@', email) + 1
            ) AS "Domain"
        FROM customers
        WHERE LOCATE(domain_name, email) > 0;
    END $$
DELIMITER ;

CALL SelectDomain('hotmail');

-- Create net sales function
DELIMITER $$
CREATE FUNCTION sales.udfNetSales(
    quantity INT,
    list_price NUMERIC,
    discount NUMERIC
) RETURNS NUMERIC
DETERMINISTIC
BEGIN
    RETURN quantity * list_price * (1 - discount);
end $$
DELIMITER ;

SELECT *, udfNetSales(quantity, list_price, discount)
AS "Net Sales"
FROM sales.order_items
ORDER BY udfNetSales(quantity, list_price, discount) DESC;

DELIMITER $$
CREATE FUNCTION sales.Vat(
     list_price NUMERIC
) RETURNS NUMERIC
DETERMINISTIC
BEGIN
    RETURN list_price * 0.15;
end $$
DELIMITER ;

SELECT product_id, product_name, list_price, Vat(list_price) AS "Tax",
       list_price + Vat(list_price) AS "Total price"
FROM production.products;

SELECT order_id,
       SUM(udfNetSales(quantity,list_price,discount))
       AS "Net Amount"
FROM sales.order_items
GROUP BY order_id
ORDER BY `Net Amount` DESC;

-- Declare variable for the vat function
SET @Vat_rate := 0.17;

-- not working query still need to be working on
SELECT product_id, product_name, list_price,
       IFNULL(sales.Vat(list_price, 0.17 ), 0) AS "Tax",
       list_price + IFNULL(sales.Vat(list_price, 0.17), 0) AS "Total price"
FROM production.products;

-- testing query
SELECT @Vat_rate;
SELECT * FROM production.products;











