USE production;
USE sales;

-- procedure for  Product By Model
DELIMITER $$
CREATE PROCEDURE uspFINDProductByModel(
	IN model_year INT,
    OUT count_product INT 
)
BEGIN
	SELECT 
		PP.product_name, PP.list_price,
         COUNT(*) OVER () AS product_count
    FROM production.products AS PP
    WHERE PP.model_year = model_year
    ORDER BY list_price;
END $$
DELIMITER ;

CALL uspFINDProductByModel(2017, @product_count);

-- procedure for  Product list price

DELIMITER $$
CREATE PROCEDURE uspPRODUCTList(IN min_price NUMERIC, IN max_price NUMERIC)
BEGIN
	SELECT 
		product_name, list_price
	FROM production.products
    WHERE list_price BETWEEN min_price AND max_price
    ORDER BY list_price DESC;
END $$
DELIMITER ;

CALL uspPRODUCTLisT(1000,2000);

-- create a procedure withe default parameters
DELIMITER $$
CREATE PROCEDURE uspPRODUCTListUpdated(
    IN min_price NUMERIC ,
    IN max_price NUMERIC 
)
BEGIN 
-- condition to set the parameter if mot provided
	IF min_price = '' THEN
		SET min_price = 0;
	END IF;
    
    IF max_price =  '' THEN
		SET max_price = 999999;
	END IF;
    
    SELECT 
        product_name, list_price
    FROM production.products
    WHERE list_price BETWEEN min_price AND max_price
    ORDER BY list_price; 
END $$
DELIMITER ;

CALL uspPRODUCTListUpdated(@min_price, @max_price);
