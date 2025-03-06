SELECT count(*) FROM debit_credit;   #Total Number of Rows in the Table
SELECT * FROM debit_credit;          #Entire Table

-- KPI 1 --

SELECT round(sum(amount),2) AS Total_Credit_Amount FROM debit_credit WHERE Transaction_Type = "Credit";

#Another way
SELECT round(sum(CASE WHEN Transaction_Type = "Credit" THEN Amount ELSE 0 END),2) 
AS Total_Credit_Amount FROM debit_credit;

-- KPI 2--

SELECT round(sum(amount),2) AS Total_Debit_Amount FROM debit_credit WHERE Transaction_Type = "Debit";

-- KPI 3 --

SELECT round(sum(CASE WHEN Transaction_Type = "Credit" THEN Amount ELSE 0 END)/
       sum(CASE WHEN Transaction_Type = "Debit" THEN Amount ELSE 0 END),4) AS 
       Credit_To_Debit_Ratio FROM debit_credit;
 
-- KPI 4 -- 
 
 SELECT round(sum(CASE WHEN Transaction_type = "Credit" THEN Amount ELSE 0 END)-
			 sum(CASE WHEN Transaction_type = "Debit" THEN Amount ELSE 0 END),2)
            AS Net_Transaction_Amount
            FROM debit_credit;
 
-- KPI 5 --

SELECT 
concat(round((Count(Amount) / Sum(Balance)) * 100, 2), "%")
    AS account_activity_ratio
    FROM debit_credit;
    
-- KPI 6 --    

SELECT 
    Transaction_date,
    weekofyear(transaction_date) AS weekly_transaction,
    monthname(transaction_date) AS monthly_transaction,
    COUNT(*) AS total_transactions
FROM debit_credit
GROUP BY transaction_date, weekly_transaction, monthly_transaction
ORDER BY transaction_date;

-- KPI 7 -- 
SELECT 
Branch, Round(Sum(Amount), 2) AS Total_Amount
From debit_credit
GROUP BY Branch
ORDER BY Total_Amount; 
       
-- KPI 8 -- 
SELECT
Bank_Name, Round(Sum(Amount), 2) AS Total_Amount
FROM debit_credit
GROUP BY Bank_Name
ORDER BY Total_Amount;

-- KPI 9 -- 
SELECT 
Transaction_Method, Round(Sum(Amount), 2) AS Total_Amount
FROM debit_credit
GROUP BY Transaction_Method
ORDER BY Total_Amount;

-- KPI 10 -- 

WITH MonthlyTotals AS (
    SELECT 
        Branch,
        YEAR(Transaction_Date) AS trans_year,
        MONTH(Transaction_Date) AS trans_month,
        SUM(Amount) AS total_transaction_amount
    FROM debit_credit
    GROUP BY branch, trans_year, trans_month
)
SELECT 
    Branch,
    trans_year,
    trans_month,
    total_transaction_amount,
    LAG(total_transaction_amount) OVER (PARTITION BY Branch ORDER BY trans_year, trans_month) AS previous_month_amount,
    ROUND(
        ((total_transaction_amount - LAG(total_transaction_amount) OVER (PARTITION BY branch ORDER BY trans_year, trans_month)) / 
        NULLIF(LAG(total_transaction_amount) OVER (PARTITION BY branch ORDER BY trans_year, trans_month), 0)) * 100, 
        2
    ) AS percentage_change
FROM MonthlyTotals
ORDER BY branch, trans_year, trans_month;

-- KPI 11 --

SELECT
Flag_Transaction, round(Count(Amount), 2) AS Total_Amount
FROM debit_credit
GROUP BY Flag_Transaction
ORDER BY Total_Amount;

-- KPI 12 --

SELECT 
    YEAR(Transaction_Date) AS Trans_Year,
    MONTH(Transaction_Date) AS Trans_Month,
    COUNT(*) AS high_risk_count
FROM debit_credit
WHERE Amount > 4000.00
GROUP BY Trans_year, Trans_month
ORDER BY Trans_year, Trans_month;