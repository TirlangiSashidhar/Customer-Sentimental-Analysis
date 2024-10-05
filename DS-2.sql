-- CREATING DATABASE CS_DATA
USE CS_DATA;

-- DISPLAYING THE TABLES 
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- DISPLAYING THE MEMBERS TABLE CONTENT
SELECT * 
FROM Members  

-- DISPLAYING THE CUSTOMER TABLE CONTENT
SELECT * 
FROM Customers 



-- PERFORM INNER JOIN ON MEMBERS AND CUSTOMERS BASED ON EMAIL
SELECT *
FROM Customers AS c
INNER JOIN Members AS m ON c.Customer_Email = m.Email;



-- FIND CUSTOMERS WHO HAVE NOT MADE A PURCHASE IN THE LAST YEAR
SELECT c.Customer_Name, c.Customer_Email, c.Purchases_Count, c.Member_Since
FROM Customers AS c
LEFT JOIN (
    SELECT Email, MAX(Customer_Since) AS last_purchase_year
    FROM Members
    GROUP BY Email
) AS m ON c.Customer_Email = m.Email
WHERE m.last_purchase_year < '2024' OR m.last_purchase_year IS NULL;



-- SQL FUNCTION TO CALCULATE AVERAGE PURCHASE VALUE
CREATE FUNCTION calculate_avg_purchase_value(@Customer_Email VARCHAR(255))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @avg_value DECIMAL(10, 2);

    -- CALCULATE AVERAGE PURCHASE VALUE FOR THE GIVEN CUSTOMER
    SELECT @avg_value = AVG(Amount_Spent)
    FROM purchases
    WHERE Customer_Email = @Customer_Email;

    -- IF THERE ARE NO PURCHASES, SET @AVG_VALUE TO NULL
    IF @avg_value IS NULL
    BEGIN
        SET @avg_value = NULL; 
    END

    -- RETURN THE CALCULATED AVERAGE VALUE
    RETURN @avg_value;
END;




-- SQL VIEW FOR CUSTOMER SEGMENTATION:
CREATE VIEW segmented_customers AS
SELECT 
    Customer_Name,
    Amount_Spent,
    CASE 
        WHEN Amount_Spent > 10000 THEN 'High Spender'
        WHEN Amount_Spent BETWEEN 5000 AND 10000 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spend_category
FROM 
    Customers;

--output
SELECT * FROM segmented_customers;













