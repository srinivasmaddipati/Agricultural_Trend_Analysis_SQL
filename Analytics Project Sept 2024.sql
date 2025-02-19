use Vasu

select * from Crop_prod_study

--Find all records with null values
select count(*) from Crop_prod_study
where Production is null

--Droping Null Values
delete from Crop_prod_study
where Production is null

--Calculate crop yield (production per unit area) to assess which crops are the most efficient in production
select Crop, ROUND(SUM(production)/SUM(Area), 2) as Production_per_Unit_Area from Crop_prod_study
group by Crop
order by production_per_unit_area desc;

--calculate the year-over-year percentage growth in crop production for each state and crop
with Yearly_Growth as (select State_Name, Crop, Crop_Year, SUM(Production) as Current_Year_Yeild from Crop_prod_study
			group by State_Name, Crop_Year, Crop)

select yg1.State_Name, yg1.Crop, yg1.Crop_Year, yg1.Current_Year_Yeild, yg2.Current_Year_Yeild as Previous_Year_Yeild,
	case when
		yg2.Current_Year_Yeild is not null and yg2.Current_Year_Yeild != 0
		then round(((yg1.Current_Year_Yeild - yg2.Current_Year_Yeild) / yg2.Current_Year_Yeild) * 100, 2) 
		else null
	end as 'Yeild_Growth_%'
from Yearly_Growth yg1
join Yearly_Growth yg2 on yg1.State_Name = yg2.State_Name and yg1.Crop = yg2.Crop and yg1.Crop_Year = yg2.Crop_Year+1
order by 'Yeild_Growth_%' Desc;

--calculates each state's average yield (production per area) and identifies the top N states with the highest average yield over multiple years
with State_Yeilds as (select State_Name, SUM(Production) as Total_Production, SUM(Area) as Total_Area, ROUND(SUM(Production)/SUM(Area), 2) as Average_Yeild from Crop_prod_study
group by State_Name)

select * from State_Yeilds
order by Average_Yeild desc;

--calculate the variance in production across different crops and states. (tip: use VAR function).
select State_Name, Crop, ROUND(SUM(Production)/SUM(Area), 2) as Average_Yeild, VAR(Production) as Production_Variance from Crop_prod_study
group by State_Name, Crop
order by State_Name, Crop;

--Identifiy states that have the largest increase in cultivated area for a specific crop between two years
with Cultivation as (select State_Name, Crop, Crop_Year, SUM(Production) as Total_Production, SUM(Area) as Total_Area from Crop_prod_study
group by State_Name, Crop, Crop_Year)

select c1.State_Name, c1.Crop, c1.Crop_Year as Year_1, c2.Crop_Year as Year_2, c1.Total_Production as Year_1_Total_Production, c2.Total_Production as Year_2_Total_Production,
	c1.Total_Area as Year_1_Total_Area, c2.Total_Area as Year_2_Total_Area,
	case when
		c2.Total_Area is not null and c2.Total_Area != 0
		then ROUND((c2.Total_Area - c1.Total_Area),0)
		else null
	end as Cultivated_Area_Change
from Cultivation c1
join Cultivation c2 on c1.State_Name = c2.State_Name and c1.Crop = c2.Crop and c2.Crop_Year = c1.Crop_Year+2
where c1.Crop = 'banana'
order by Cultivated_Area_Change desc;

