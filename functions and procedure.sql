USE production;
USE sales;

-- STORE QUERY VALUE IN VARIABLE
SET @product_count :=(
    SELECT COUNT(*) FROM production.products
    );

-- PRINT THE VARIABLE NAME
SELECT @product_count;

/*
-- Temporary Table Variable this insertion
-- not a good design for insertion and creating a temp table
CREATE TEMPORARY TABLE production.products_table (
    product_id INT,
    product_name VARCHAR(255),
    model_year INT,
    list_price DECIMAL
);

INSERT INTO production.products_table
    (product_id, product_name, model_year, list_price)
SELECT
    product_id, product_name, model_year, list_price
FROM
    production.products;
*/

DROP TABLE IF EXISTS production.products_table;

-- Create table and insert data in one step
CREATE TEMPORARY TABLE production.products_temp_table
    AS
    SELECT *
    FROM
        production.products;

SELECT * FROM production.products_temp_table;

DROP TABLE IF EXISTS production.products_temp_table;

SHOW TABLES FROM production;
SHOW TABLES FROM sales;
DESCRIBE sales.orders;

/*
DELIMITER $$
CREATE FUNCTION fnCustomers_orders(
    customer_id INT
) RETURNS TABLE
DETERMINISTIC
BEGIN
    SELECT
        SO.order_id, SO.order_date
    FROM
        sales.orders AS SO
    WHERE SO.order_id = customer_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE spCustomers_orders(
    IN customer_id INT,
    OUT order_no INT,
    OUT order_date DATE
)
BEGIN
    -- SELECT ALL ROWS IN ORDER NO
    SELECT
        COUNT(*)
    INTO
        order_no
    FROM
        sales.orders AS SO
    WHERE
        SO.customer_id = customer_id;
    -- SELECT ALL ROWS IN ORDER DATE
    SELECT
        COUNT(*)
    INTO
        order_date
    FROM
        sales.orders AS SO
    WHERE
        SO.customer_id = customer_id;
END $$
DELIMITER ;

CALL production.spCustomers_orders
    (135,@order_number,@order_date);

SELECT @order_number, @order_date;

*/



DELIMITER $$
    CREATE PROCEDURE production.FindMostExpensiveProduct()
    BEGIN
       DECLARE  product_name VARCHAR(255);
       -- FIND THE MOST EXPENSIVE PRODUCT
        SELECT
            PP.product_name
        INTO
            product_name
        FROM production.products AS PP
        ORDER BY list_price DESC
        LIMIT 1;

       -- CHECK IF ANY PRODUCT IS FOUND
        IF FOUND_ROWS() != 0 THEN
            SELECT CONCAT('The most expensive product is ', product_name) AS Message;
        ELSE
            SELECT 'No product is found' AS Message;
        END IF;
    END $$
DELIMITER ;

CALL production.FindMostExpensiveProduct();

DELIMITER $$
CREATE PROCEDURE exampleWhileLoop()
BEGIN
    DECLARE counter INT DEFAULT 0;
    WHILE counter <= 5 DO
        SET counter = counter + 1;
        SELECT counter;
        end while;
end $$
DELIMITER ;

CALL exampleWhileLoop();

DELIMITER $$
CREATE PROCEDURE exampleWhileLoop01()
BEGIN
    DECLARE counter INT DEFAULT 0;
    WHILE counter <= 10 DO
        SET counter = counter + 1;
        IF counter = 5 THEN
            SET counter = counter + 1;
        ELSE
            SELECT counter;
        end if ;
    end while;
end $$
DELIMITER ;

CALL exampleWhileLoop01();
