

SELECT 
a.*
FROM CovidData a

-- Extract 5 rows of the dataset

SELECT TOP 5 a.*
FROM CovidData a

--Get the data on May 12, 2020

SELECT a.*
FROM CovidData a
WHERE a.date = '2020-05-12 00:00:00.000'

--ANALYZING THE DATA
--Getting the total cases , total dealths

SELECT
SUM(a.new_cases) as TotalCases, 
SUM(a.new_deaths) as TotalDeaths
FROM CovidData a

--Getting the overall death rate (ratio of reported deaths to reported cases)
SELECT
ROUND(((SUM(a.new_deaths) / SUM(a.new_cases)) * 100 ),2, 0) as DeathRatio
FROM CovidData a

--Getting the overall death rate (ratio of reported deaths to reported cases)
--With percentage included
SELECT
CONCAT(ROUND(((SUM(a.new_deaths) / SUM(a.new_cases)) * 100 ),2, 0) , '%') as DeathRatio
FROM CovidData a

