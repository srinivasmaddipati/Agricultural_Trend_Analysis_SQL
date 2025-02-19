# Agricultural_Trend_Analysis_SQL

![image](https://github.com/user-attachments/assets/cea68723-5699-4a9a-89f2-bc71575630ef)

## Introduction

Crop production year analysis is an important method for evaluating agricultural productivity trends and determining what factors influence crop yields over time. This approach identifies patterns that influence farming success by reviewing data on crop types, production quantities, and seasonal fluctuations over multiple years. It can also demonstrate the impact of weather, soil quality, and farming practices on crop yield. Finally, crop production year analysis helps farmers, politicians, and researchers make better decisions, improve resource management, and increase food security.

## Tools

- MS SQL Server
- Power BI

## Data Analysis using SQL

### 1. Calculate crop yield (production per unit area) to assess which crops are the most efficient in production

`
select 
  Crop, 
  ROUND(SUM(production)/SUM(Area), 2) as Production_per_Unit_Area 
from Crop_prod_study
group by Crop
order by production_per_unit_area desc;
`
