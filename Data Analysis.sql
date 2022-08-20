

--ANALYZING DATA
--GET THE TOTAL CASES, TOTAL DEATHS, & ITS DEATH PERCENTAGE TO NEW CASES

Select SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
--We need to make sure that the continent column has a value



--Extract & Analyze the total deaths 
Select location, SUM(cast(new_deaths as int)) as TotalDeaths
From CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeaths desc

--GETTING THE HIGHEST INFECTION COUNT , PERCENT OF THE POPULATION INFECTED 
--SORTING BY THE HIGHEST INFECTION COUNT

Select Location,
Population, 
MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--GETTING THE HIGHEST INFECTION COUNT , PERCENT OF THE POPULATION INFECTED 
--SORTING BY THE HIGHEST PERCENT OF POPULATION INFECTED

Select Location, Population,date, 
MAX(total_cases) as HighestInfectionCount,
Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc


--JOINING WITH COVID VACCINATIONS DATA
--GETTING THE LOCATION & CONTINENT WITH THE HIGHEST VACCINATION NUMBER

SELECT
a.*
FROM CovidVaccinations$ a

Select dea.continent,
dea.location, 
dea.date, 
dea.population,
MAX(vac.total_vaccinations) as PeopleVaccinated
From CovidDeaths dea
Join CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3
