# Agricultural_Trend_Analysis_SQL

![image](https://github.com/user-attachments/assets/cea68723-5699-4a9a-89f2-bc71575630ef)

## Introduction

Crop production year analysis is an important method for evaluating agricultural productivity trends and determining what factors influence crop yields over time. This approach identifies patterns that influence farming success by reviewing data on crop types, production quantities, and seasonal fluctuations over multiple years. It can also demonstrate the impact of weather, soil quality, and farming practices on crop yield. Finally, crop production year analysis helps farmers, politicians, and researchers make better decisions, improve resource management, and increase food security.

## Tools


- MS SQL Server
- Power BI


## Data Analysis using SQL


### 1. Calculate crop yield (production per unit area) to assess which crops are the most efficient in production.

```
SELECT 
    Crop, 
    ROUND(SUM(production)/SUM(Area), 2) AS Production_per_Unit_Area 
FROM Crop_prod_study
GROUP BY Crop
ORDER BY production_per_unit_area DESC;
```
This query is used to calculate the production efficiency for each crop in the Crop_prod_study table by determining the production per unit area.


### 2. Calculate the year-over-year percentage growth in crop production for each state and crop.

```
WITH Yearly_Growth AS (
    SELECT
        State_Name,
        Crop, Crop_Year,
        SUM(Production) AS Current_Year_Yeild
    FROM Crop_prod_study
    GROUP BY State_Name, Crop_Year, Crop
)

SELECT
    yg1.State_Name,
    yg1.Crop, yg1.Crop_Year,
    yg1.Current_Year_Yeild,
    yg2.Current_Year_Yeild AS Previous_Year_Yeild,
	CASE WHEN
		yg2.Current_Year_Yeild IS NOT NULL AND yg2.Current_Year_Yeild != 0
		THEN ROUND(((yg1.Current_Year_Yeild - yg2.Current_Year_Yeild) / yg2.Current_Year_Yeild) * 100, 2) 
        ELSE NULL
	END AS 'Yeild_Growth_%'
FROM Yearly_Growth yg1
JOIN Yearly_Growth yg2 ON yg1.State_Name = yg2.State_Name AND yg1.Crop = yg2.Crop AND yg1.Crop_Year = yg2.Crop_Year+1
ORDER BY 'Yeild_Growth_%' DESC;
```
This query calculates the year-over-year percentage growth in crop production for each crop in each state, ordered by the highest growth.


### 3. Calculate each state's average yield (production per area) and identifies the top N states with the highest average yield over multiple years

```
WITH State_Yeilds AS (
    SELECT State_Name,
        SUM(Production) AS Total_Production,
        SUM(Area) AS Total_Area,
        ROUND(SUM(Production)/SUM(Area), 2) AS Average_Yeild
    FROM Crop_prod_study
    GROUP BY State_Name
)

SELECT * FROM State_Yeilds
ORDER BY Average_Yeild DESC;
```
This query calculates the average crop yield per unit area for each state and ranks the states in descending order based on their average yield.


### 4. Calculate the variance in production across different crops and states. (tip: use VAR function).

```
SELECT
    State_Name,
    Crop,
    ROUND(SUM(Production)/SUM(Area), 2) AS Average_Yeild,
    VAR(Production) AS Production_Variance
FROM Crop_prod_study
GROUP BY State_Name, Crop
ORDER BY State_Name, Crop;
```
This query calculates the average yield per unit area and production variance for each crop across different states. The results are ordered by State_Name and Crop.


### 5. Identifiy states that have the largest increase in cultivated area for a specific crop between two years

```
WITH Cultivation AS (
    SELECT
        State_Name,
        Crop, Crop_Year,
        SUM(Production) AS Total_Production,
        SUM(Area) AS Total_Area
    FROM Crop_prod_study
    GROUP BY State_Name, Crop, Crop_Year
)

SELECT
    c1.State_Name,
    c1.Crop, c1.Crop_Year AS Year_1,
    c2.Crop_Year AS Year_2,
    c1.Total_Production AS Year_1_Total_Production,
    c2.Total_Production AS Year_2_Total_Production,
	c1.Total_Area AS Year_1_Total_Area,
    c2.Total_Area AS Year_2_Total_Area,
	CASE WHEN
		c2.Total_Area IS NOT NULL AND c2.Total_Area != 0
		THEN ROUND((c2.Total_Area - c1.Total_Area),0)
		ELSE NULL
	END AS Cultivated_Area_Change
FROM Cultivation c1
JOIN Cultivation c2 ON c1.State_Name = c2.State_Name AND c1.Crop = c2.Crop AND c2.Crop_Year = c1.Crop_Year+2
WHERE c1.Crop = 'banana'
ORDER BY Cultivated_Area_Change DESC;
```
This query analyzes the change in cultivated area for Banana crops over a 2-year period across different states.



## Data Visualizations using Power BI

![image](https://github.com/user-attachments/assets/b3086ba0-155d-4581-aa9a-b999694555a6)

This Power BI dashboard provides a comprehensive analysis of agricultural crop production in India, highlighting total production, major crops, production trends, and regional insights.

### Key Components & Insights:


#### Total Crop Producing Area & Production:

The Total Crop Producing Area is 2.95 billion hectares out of a possible 5.91 billion hectares.
The Total Crop Production stands at 141.18 billion metric tons out of a potential 282.35 billion metric tons.
These metrics provide a high-level view of agricultural productivity across India.


#### Top 5 Major Crops:

The most highly produced crops include Coconut, Sugarcane, Rice, Wheat, and Potato.
The report provides exact production figures for each crop.


#### Top 3 Districts in Production:

Kozhikode, Malappuram, and Thiruvananthapuram are the top three districts contributing to crop production.
The dashboard highlights their respective production values.


#### State-wise Total Production:

Kerala leads with 69.33% of total crop production.
Andhra Pradesh, Tamil Nadu, and Uttar Pradesh follow, with significantly lower percentages.
The horizontal bar chart provides a comparative view of agricultural output across states.


#### Production Over Years:

The line chart shows crop production trends from 1995 to 2015.
Production peaked around 2010-2015 before experiencing a decline.
This helps identify growth patterns and periods of decline in agricultural productivity.


#### Production by Crop:

The bar chart indicates that Coconut is the dominant crop, contributing to the majority of total production.
Other crops such as Sugarcane, Rice, Wheat, and Potato have significantly lower production levels.


#### Production by Season:

The Whole Year production is 0.13 trillion metric tons.
The seasonal categories (Kharif, Rabi, Winter, Summer, and Autumn) show zero production, suggesting data might be missing or aggregated under “Whole Year.”
This section helps analyze seasonal crop production trends and potential gaps in data collection.


#### Filters & Interactivity:

The dashboard includes filters for Crop, State, District, and Year, allowing users to customize views and analyze specific data points.


