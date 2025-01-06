Select Top 10*
From [Apple Stocks];

-- Minimum, Maximum and Average values

Select Min("open") as MinOpen,
Max("open") as MaxOpen,
Avg("open") as AvgOpen,
Min("close") as MinClose,
Max("close") as MaxClose,
Avg("close") as AvgClose
From [Apple Stocks];

-- Daily Price Changes

Select("date"),
("close"-"open") as daily_change,
(("close" - "open")/"open")* 100 as daily_percentage_change
From [Apple Stocks];

-- 7 Day moving price

Select ("date"),
AVG("close") over (Order by Date rows between 6 preceding and current row) as Moving_Avg_7
From [apple stocks];

-- 30 Day moving price

Select ("date"),
AVG("close") over (Order by Date rows between 29 preceding and current row) as Moving_Avg_30
From [apple stocks];

-- Trading volume trends by Month and year

Select Year("Date") as Year,
Month("Date") as Month,
Sum("volume") as Total_volume
From [apple stocks]
Group by Year("date"),Month("Date")
Order by Year,month;

--Highest Daily Trading Volume

SELECT TOP 1
    ("Date"),("Volume") 
FROM [Apple Stocks]
ORDER BY Volume desc;

-- Lowest Daily Trading Volume

SELECT TOP 1 
    ("Date"),("Volume") 
FROM [Apple Stocks]
ORDER BY Volume asc;

-- Average Monthly closing price

SELECT 
    YEAR("Date") AS Year,
    MONTH("Date") AS Month,
    AVG("Close") AS AvgClosingPrice
FROM [Apple Stocks]
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;

--Maximum Price Difference in a Day

SELECT TOP 1 
    "Date", 
    "High" - "Low" AS Max_Difference
FROM [Apple Stocks]
ORDER BY Max_Difference DESC;

--Count of Positive and Negative Days

SELECT 
    CASE 
        WHEN "Close" > "Open" THEN 'Positive'
        ELSE 'Negative'
    END AS Day_Type,
   COUNT(*) AS Day_Count
FROM [Apple Stocks]
GROUP BY CASE 
        WHEN "Close" > "Open" THEN 'Positive'
        ELSE 'Negative'
   End;

--Top 5 Highest Adjusted Closing Prices

SELECT TOP 5 
    "Date", 
    "Adj Close"
FROM [Apple Stocks]
ORDER BY "Adj Close" DESC;

--Average Opening Price by Year

SELECT 
    YEAR("Date") AS Year, 
    AVG("Open") AS Avg_Opening_Price
FROM [Apple Stocks]
GROUP BY YEAR("Date")
ORDER BY Year;

--Longest Streak of Positive Days

WITH PositiveDays AS (
    SELECT 
        "Date",
        CASE 
            WHEN "Close" > "Open" THEN 1
            ELSE 0
        END AS IsPositive
    FROM [Apple Stocks]
),
Streaks AS (
    SELECT 
        "Date",
        IsPositive,
        SUM(CASE WHEN IsPositive = 1 THEN 1 ELSE 0 END) 
        OVER (ORDER BY Date ROWS UNBOUNDED PRECEDING) AS Streak
    FROM PositiveDays
)
SELECT Max(Streak) AS Longest_Positive_Streak FROM Streaks;

--Average Volume by Day of the Week

SELECT 
    DATENAME(WEEKDAY, Date) AS Weekday, 
    AVG("Volume") AS AvgVolume
FROM [Apple Stocks]
GROUP BY DATENAME(WEEKDAY, Date)
ORDER BY CASE 
    WHEN DATENAME(WEEKDAY, Date) = 'Monday' THEN 1
    WHEN DATENAME(WEEKDAY, Date) = 'Tuesday' THEN 2
    WHEN DATENAME(WEEKDAY, Date) = 'Wednesday' THEN 3
    WHEN DATENAME(WEEKDAY, Date) = 'Thursday' THEN 4
    WHEN DATENAME(WEEKDAY, Date) = 'Friday' THEN 5
END;

-- Weekly Trading Volume

SELECT 
    DATEPART(YEAR, Date) AS Year,
    DATEPART(WEEK, Date) AS Week,
    SUM("Volume") AS Weekly_Volume
FROM [Apple Stocks]
GROUP BY DATEPART(YEAR, Date), DATEPART(WEEK, Date)
ORDER BY Year, Week;

--Median Daily Closing Price

SELECT 
    "Date",
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY "Close") OVER () AS Median_Closing_Price
FROM [Apple Stocks];

--Top 10 Days to Buy and Sell

SELECT TOP 10 
    "Date", 
    "High" - "Low" AS Max_Profit
FROM [Apple Stocks]
ORDER BY Max_Profit DESC;

-- Yearly Closing Price Growth

WITH Yearly_Close AS (
    SELECT 
        YEAR("Date") AS Year, 
        FIRST_VALUE("Close") OVER (PARTITION BY YEAR(Date) ORDER BY Date) AS First_Close,
        LAST_VALUE("Close") OVER (PARTITION BY YEAR(Date) ORDER BY Date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_Close
    FROM [Apple Stocks]
)
SELECT 
    Year, 
    ((Last_Close - First_Close) / First_Close) * 100 AS Growth_Percent
FROM Yearly_Close
GROUP BY Year, First_Close, Last_Close
Order by Year;

-- Month with Maximum Trading Volume

SELECT TOP 1 
    YEAR("Date") AS Year, 
    MONTH("Date") AS Month, 
    SUM("Volume") AS Total_Volume
FROM [Apple Stocks]
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Total_Volume DESC;

-- Average Price Change Across All Days

SELECT 
    AVG("Close" - "Open") AS Avg_Daily_Price_Change
FROM [Apple Stocks];

