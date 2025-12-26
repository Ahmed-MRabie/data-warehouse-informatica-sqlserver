
CREATE TABLE Dim_Date (
    Date_ID        INT PRIMARY KEY,           -- YYYYMMDD
    full_date      DATE NOT NULL,
    day            TINYINT NOT NULL,
    month          TINYINT NOT NULL,
    month_name     VARCHAR(20) NOT NULL,
    quarter        TINYINT NOT NULL,
    year           SMALLINT NOT NULL,
    day_of_week    TINYINT NOT NULL,          -- 1 = Sunday ... 7 = Saturday
    day_name       VARCHAR(20) NOT NULL,
    week_of_year   TINYINT NOT NULL,
    is_weekend     BIT NOT NULL
);

WITH DateRange AS (
    SELECT CAST('2012-07-04' AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(DAY, 1, DateValue)
    FROM DateRange
    WHERE DateValue < '2026-12-31'
)
INSERT INTO Dim_Date (
    Date_ID,
    full_date,
    day,
    month,
    month_name,
    quarter,
    year,
    day_of_week,
    day_name,
    week_of_year,
    is_weekend
)
SELECT 
    CONVERT(INT, FORMAT(DateValue, 'yyyyMMdd')) AS date_id,
    DateValue AS full_date,
    DATEPART(DAY, DateValue) AS day,
    DATEPART(MONTH, DateValue) AS month,
    DATENAME(MONTH, DateValue) AS month_name,
    DATEPART(QUARTER, DateValue) AS quarter,
    DATEPART(YEAR, DateValue) AS year,
    DATEPART(WEEKDAY, DateValue) AS day_of_week,
    DATENAME(WEEKDAY, DateValue) AS day_name,
    DATEPART(WEEK, DateValue) AS week_of_year,
    CASE WHEN DATENAME(WEEKDAY, DateValue) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END AS is_weekend
FROM DateRange
OPTION (MAXRECURSION 0);


SELECT * FROM Dim_Date;
