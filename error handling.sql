USE sales;
USE production;

-- Exception handing in stored procedure
-- declare a handler is part of database like catch
-- syntax will be is: to declare action either is (continue or exist) for condition_value statement

-- conditional value means
-- my-sql error code
-- standard sqlstate value (sql_warning , not_found, sql_exception)

CREATE TABLE production.supp_prod(
    SID INT,
    PID INT,
    PRIMARY KEY (SID,PID)
);

/*
main objective is to insert record to the table
1- check whether records is exists or not
3- if exists display a massage
*/

DELIMITER &&
CREATE PROCEDURE INSERT_SUPP_PRODUCT(
    IN IN_SID INT,
    IN IN_PID INT
)
BEGIN
    -- 1062 basically means error code means if the error is already exists
    -- it will returns somethings
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT  CONCAT('Duplicate key (',IN_SID,' ',IN_PID,') OCCURRED') AS "MESSAGE";
    END;
    -- insert into a new record into the table
    INSERT INTO production.supp_prod(SID, PID) VALUES (IN_SID, IN_PID);

    -- RETURN THE PRODUCTS SUPPLY BY SID
    SELECT COUNT(*) FROM supp_prod WHERE SID = IN_SID;
END &&
DELIMITER ;

CALL INSERT_SUPP_PRODUCT(5,7);
CALL INSERT_SUPP_PRODUCT(3,778);
SELECT * FROM supp_prod;

