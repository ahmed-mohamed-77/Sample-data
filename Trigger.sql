USE sales;
USE production;
USE login;

-- ORIGINAL DATA
CREATE TABLE login.users(
    id INT  AUTO_INCREMENT,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    status INT NOT NULL DEFAULT 1,
    CONSTRAINT users_PK PRIMARY KEY (id)
);

CREATE TABLE login.users_logs (
    id INT  AUTO_INCREMENT,
    new_user_id INT NOT NULL ,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20),
    status INT NOT NULL DEFAULT 1,
    CONSTRAINT users_PK PRIMARY KEY (id)
);

DESCRIBE login.users;
DESCRIBE login.users_logs;

CREATE TABLE new_users_id(
    id INT AUTO_INCREMENT PRIMARY KEY ,
    new_user_id INT NOT NULL
);

CREATE TABLE production.products_backup (
    id INT AUTO_INCREMENT PRIMARY KEY,
	backup_product_id INT NOT NULL,
	product_name VARCHAR (255) NOT NULL,
	brand_id INT NOT NULL,
	category_id INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id) REFERENCES production.categories (category_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id) REFERENCES production.brands (brand_id) ON DELETE CASCADE ON UPDATE CASCADE
);
DROP TABLE login.updated_product_user_log;
CREATE TABLE login.updated_product_user_log(
    id INT AUTO_INCREMENT PRIMARY KEY ,
    product_id INT NOT NULL ,
    user_id VARCHAR(255) NOT NULL
);

SELECT * FROM updated_product_user_log;

-- Insert 20 unique rows into the users table
INSERT INTO login.users (name, email, phone, status)
VALUES
    ('John Doe', 'john.doe@example.com', '123-456-7890', 1),
    ('Jane Smith', 'jane.smith@example.com', '987-654-3210', 1),
    ('Alice Johnson', 'alice.johnson@example.com', '555-555-5555', 1),
    ('Bob Williams', 'bob.williams@example.com', '777-777-7777', 1),
    ('Eva Davis', 'eva.davis@example.com', '888-888-8888', 1),
    ('Michael Brown', 'michael.brown@example.com', '333-333-3333', 1),
    ('Olivia Wilson', 'olivia.wilson@example.com', '666-666-6666', 1),
    ('Daniel Miller', 'daniel.miller@example.com', '444-444-4444', 1),
    ('Sophia Moore', 'sophia.moore@example.com', '999-999-9999', 1),
    ('Liam Taylor', 'liam.taylor@example.com', '222-222-2222', 1),
    ('Ava Anderson', 'ava.anderson@example.com', '111-111-1111', 1),
    ('Noah White', 'noah.white@example.com', '777-888-9999', 1),
    ('Emma Brown', 'emma.brown@example.com', '333-444-5555', 1),
    ('Jackson Harris', 'jackson.harris@example.com', '666-111-2222', 1),
    ('Mia Martin', 'mia.martin@example.com', '555-777-9999', 1),
    ('William Davis', 'william.davis@example.com', '444-666-1111', 1),
    ('Sophia Martinez', 'sophia.martinez@example.com', '888-333-2222', 1),
    ('Alexander Adams', 'alexander.adams@example.com', '222-111-9999', 1),
    ('Emily Harris', 'emily.harris@example.com', '777-555-4444', 1),
    ('James Robinson', 'james.robinson@example.com', '333-888-6666', 1);

CALL login.user_insertion('ahmed', 'ahmed@fmail.com', '15919321689', 1);

INSERT INTO login.users (name, email, phone, status)
VALUES
    ('Ajay', 'ajay@fmail.com', '1234568796', 1);

CALL login.user_insertion
('Alice Smith', 'alice@example.com', '5551234567', 1);

-- BACKUP DATA FROM users DATA
-- AUTOMATIC CODE FROM TRIGGER

-- TRIGGER TO KEEP TRACK OF DELETED USERS
DELIMITER $$
CREATE TRIGGER before_users_delete BEFORE DELETE
    ON login.users FOR EACH ROW
    BEGIN
        INSERT INTO login.users_logs (new_user_id, name, email, phone, status)
            VALUES (OLD.id, OLD.name, OLD.email, OLD.phone, OLD.status);
    END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER after_user_insert AFTER INSERT
    ON login.users FOR EACH ROW
    BEGIN
        INSERT INTO new_users_id (new_user_id)
            VALUES (NEW.id);
    END $$
DELIMITER ;

-- BEFORE USER UPDATE ANY ROWS
DELIMITER $$
CREATE TRIGGER before_users_update BEFORE UPDATE
    ON login.users FOR EACH ROW
    BEGIN
        INSERT INTO login.users_logs (new_user_id, name, email, phone, status)
            VALUES (OLD.id, OLD.name, OLD.email, OLD.phone, OLD.status);
    END $$
DELIMITER ;

-- MAKE PROCEDURE TO CHECK FOR THE INSERTION
DELIMITER $$
CREATE PROCEDURE login.user_insertion(
    IN p_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(25),
    IN p_status INT
)
BEGIN
    -- declare a variable for sqlstate and sql_error_msg
    DECLARE sql_state CHAR(5);
    DECLARE sql_err_msg varchar(255);

    -- to check for the error in the insertion
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                sql_state = returned_sqlstate ,
                sql_err_msg = MESSAGE_TEXT ;
            SELECT CONCAT('SQL Exception - state: ', sql_state,
                          ', Message: ', sql_err_msg) AS "ERROR MESSAGE";
        END ;
    -- insert statement
    INSERT INTO login.users (name, email, phone, status)
    VALUES (p_name, p_email, p_phone, p_status);
END $$
DELIMITER ;

DELIMITER &&
CREATE TRIGGER after_product_update AFTER UPDATE
    ON production.products FOR EACH ROW
    BEGIN
        INSERT INTO production.products_backup (backup_product_id, product_name,
                                                brand_id, category_id, model_year, list_price)
            VALUES (OLD.product_id,OLD.product_name, OLD.brand_id, OLD.category_id,
                    OLD.model_year, OLD.list_price);
    end &&
DELIMITER ;

DELIMITER &&
CREATE TRIGGER after_product_update_2 AFTER UPDATE
    ON production.products FOR EACH ROW
    FOLLOWS after_product_update
    BEGIN
        INSERT INTO login.updated_product_user_log (product_id, user_id)
            VALUES (OLD.product_id, USER());
    end &&
DELIMITER ;

SELECT * FROM production.products;

UPDATE production.products SET list_price = 453.35
WHERE product_id = 18;

UPDATE production.products SET list_price = 253.35
WHERE product_id = 1;

SELECT * FROM production.products_backup;
SELECT * FROM login.updated_product_user_log;

UPDATE login.users SET name = 'Ahmed', email = 'ahmedmohamed@gmail.com'
WHERE id = 7;

