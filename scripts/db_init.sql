# STEP 1/2
DROP DATABASE IF EXISTS ESHOP;
CREATE DATABASE ESHOP;
USE ESHOP;

-- Users 
-- CREATE USER 'worker'@'%' IDENTIFIED BY 'password';
-- GRANT ALL PRIVILEGES ON *.* TO 'worker'@'%';
-- FLUSH PRIVILEGES;

-- Other 

CREATE TABLE CUSTOMER(
	ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    NAME VARCHAR(25) NOT NULL,
    CONTACT VARCHAR(15) UNIQUE NOT NULL,
    AFM VARCHAR(12) UNIQUE NOT NULL
);

CREATE TABLE CATEGORY (
	ID INT NOT NULL PRIMARY KEY,
	NAME VARCHAR(45),
    INFORMATION VARCHAR(100)
);

CREATE TABLE PRODUCT(
	ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    CATEGORY_ID INT,
    NAME VARCHAR(45),
    YEAR DATETIME,
    COST INT,
    AVG_GRADE INT,
    FOREIGN KEY (CATEGORY_ID) REFERENCES CATEGORY(ID)
);

CREATE TABLE ORDERS (
    ORDER_ID INT NOT NULL,
    CUSTOMER_ID INT NOT NULL,
    PRODUCT_ID INT,
    PURCHASE_DATE DATETIME,
    QUANTITY INT NOT NULL,
	TOTAL_COST INT NOT NULL,
    DELIVERY_METHOD TEXT,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT (ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (ID)
);

CREATE TABLE GRADE (
	PRODUCT_ID INT NOT NULL,
    GRADE INT,
    FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCT(ID)
);

DELIMITER //

-- Triggers
-- • Βήμα 6: Δημιουργείστε triggers που θα ενημερώνουν αυτόματα την τελική βαθμολογία των προϊόντων

CREATE TRIGGER make_score AFTER INSERT ON GRADE
FOR EACH ROW
BEGIN
   DECLARE avg_grade INT;   
   SELECT AVG(G.GRADE) INTO avg_grade FROM GRADE G WHERE G.PRODUCT_ID = NEW.PRODUCT_ID;   
   UPDATE PRODUCT SET AVG_GRADE = avg_grade WHERE ID = NEW.PRODUCT_ID;
END //

-- Functions
-- • Βήμα 7: Δημιουργήστε μια function η οποία θα επιστρέφει το συνολικό κόστος των παραγγελιών
-- λαμβάνοντας υπόψιν την κατηγορία των προϊόντων.

CREATE PROCEDURE GetTotalPrice(category_id INT)
BEGIN
	SELECT SUM(ORDERS.TOTAL_COST) FROM ORDERS WHERE ORDERS.PRODUCT_ID = CATEGORY_ID;
END //

-- Procedures
-- • Βήμα 8: Δημιουργήστε μια procedure η οποία θα δέχεται σαν είσοδο τον τρόπο
-- παράδοσης μιας παραγγελίας και μια ημερομηνία και θα επιστρέφει τον αριθμό των παραγγελιών (το πλήθος)
--  για εκείνη την ημερομηνία, καθώς επίσης και το συνολικό κόστος των παραγγελιών .

CREATE PROCEDURE GetOrderByDeliveryMethod(delivery_method TEXT, n_date DATE)
BEGIN
	SELECT COUNT(*) "Παραγγελείες" FROM ORDERS
		WHERE ORDERS.PURCHASE_DATE = n_date AND ORDERS.DELIVERY_METHOD = delivery_method;
END //

DELIMITER ;

-- STEP 3 DATA INSERTION
INSERT INTO CUSTOMER(NAME, CONTACT, AFM) 
	VALUES 
		("Mpampis Poteridis", "6991233241", "995538170"),
        ("David Martinez", "6982102345", "817489001"),
		("Rebecca", "8993231293", "664133579");
        
INSERT INTO CATEGORY(ID, NAME, INFORMATION)
	VALUES
		(1, "Phone/Tablet", "Ισχυρά μεταφερόμενα κινητά και τάμπλετ"),
        (2, "Computer", "Σταθεροί και Λάπτοπ"),
        (3, "Gadget", "Γκατζετάκια, Καλώδια και Accesories για τους tech savvies");

INSERT INTO PRODUCT(CATEGORY_ID, NAME, YEAR, COST)
	VALUES 
		(1, "Motoroloda Edge 5G", '2022-08-10', 300),
		(2, "Alienware Gaming Laptop", '2018-10-09', 1800),
        (3, "Meta Quest 2 256GB", '2022-08-23', 600);
        
INSERT INTO GRADE(PRODUCT_ID, GRADE) 
	VALUES 
		(1, 7),
        (2, 9),
        (3, 10);
        
INSERT INTO ORDERS (ORDER_ID, CUSTOMER_ID, PRODUCT_ID, PURCHASE_DATE, QUANTITY, TOTAL_COST, DELIVERY_METHOD)
	VALUES
		(1, 1, 1, '2023-10-01', 1, 300, 'DELIVERY'),
        (1, 1, 2, '2023-10-01', 1, 300, 'DELIVERY'),
		(2, 2, 2, '2022-01-10', 2, 1800, 'ON-SITE'),
		(3, 3, 3, '2023-05-05', 3, 600, 'ON-SITE');

-- STEP 4 VIEWS

-- Updated view
CREATE VIEW TOTAL_SALES AS 
SELECT CATEGORY.NAME, PRODUCT.YEAR, SUM(ORDERS.QUANTITY) "SALES" 
	FROM CATEGORY JOIN PRODUCT ON CATEGORY.ID = PRODUCT.CATEGORY_ID
    JOIN ORDERS ON ORDERS.PRODUCT_ID = PRODUCT.ID
		GROUP BY CATEGORY.NAME, PRODUCT.YEAR;
        
-- Unupdated view
CREATE VIEW CUSTOMERS_BEFORE_NEWYEARS AS 
SELECT CUSTOMER.NAME "CUSTOMERS WHO CAME IN-HOUSE BEFORE NEW YEARS"
	FROM CUSTOMER JOIN ORDERS ON CUSTOMER.ID = ORDERS.CUSTOMER_ID
    WHERE ORDERS.DELIVERY_METHOD="ON-SITE" AND ORDERS.PURCHASE_DATE < "2023-01-01";
    
-- #### Συνθήκες και Selects ####

-- SELECT * FROM GRADE;
-- SELECT * FROM PRODUCT;

-- SELECT * FR0K TOTAL_SALES;

-- SELECT * FROM CUSTOMERS_BEFORE_NEWYEARS;

-- CALL GetTotalPrice(2);
-- CALL GetOrderByDeliveryMethod('DELIVERY', '2023-10-01');

-- STEP 5 
-- Παρουσιάστε τον αριθμό των παραγγελιών ανά πελάτη μαζί με το συνολικό κόστος. 
SELECT ORDERS.QUANTITY, ORDERS.TOTAL_COST 
	FROM ORDERS JOIN CUSTOMER ON CUSTOMER.ID = ORDERS.CUSTOMER_ID;

-- Παρουσιάστε τα προϊόντα ταξινομημένα σύμφωνα με τον μέσο όρο της βαθμολογίας τους (από μεγαλύτερο σε μικρότερο).
SELECT GRADE.PRODUCT_ID, AVG(GRADE.GRADE) "AVERAGE GRADE" FROM GRADE
	GROUP BY GRADE.PRODUCT_ID ORDER BY AVG(GRADE.GRADE) DESC;
