select *
from PortofolioProject..CovidDeaths$
where continent is not null
order by 3,4;

--select *
--from PortofolioProject..CovidVaccinations$
--order by 3,4;

-- Select Data that we are going to be using

--Select Location, date, cast(total_cases as float) as total_cases, cast(new_cases as float) as new_cases, total_deaths, population 
--from PortofolioProject..CovidDeaths$
--order by 1,2;

-- Looking at Total Cases vs Total Deaths

-- shows likelihood of dying if you contract covid in your country
Select Location, date, cast(total_cases as float) as total_cases, cast(total_deaths as float) as total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
from PortofolioProject..CovidDeaths$
where location like '%states%'
order by 1,2;

-- Looking at Total Cases vs Population
-- shows what percentage of population got covid
Select Location, date, population, total_cases, (cast(total_cases as float)/cast(population as float))*100 as PercentPopulationInfected
from PortofolioProject..CovidDeaths$
--where location like '%states%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population

Select Location, population, max(cast(total_cases as float)) as HighestInfectionCount, max((cast(total_cases as float)/cast(population as float)))*100 as  PercentPopulationInfected
from PortofolioProject..CovidDeaths$
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, max(cast(total_deaths as float)) as TotalDeathCount
from PortofolioProject..CovidDeaths$
--where location like '%states%'
where continent is null
Group by continent
order by TotalDeathCount desc

-- Showing the continents with highest death count per population

Select continent, max(cast(total_deaths as float)) as TotalDeathCount
from PortofolioProject..CovidDeaths$
--where location like '%states%'
where continent is null
Group by continent
order by TotalDeathCount desc


-- Breaking global numbers (43:06)

Select sum(cast(new_cases as float)), sum(cast(new_deaths as float)) as total_deaths, sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as DeathPercentage
from PortofolioProject..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2;

-- Let's join this two table together (51:44). Join pada
-- Location dan Date.

select *
from PortofolioProject..CovidVaccinations$ as vac
join PortofolioProject..CovidDeaths$ as dea
	on dea.location = vac.location
	and dea.date = vac.date

--Looking at Total Population vs Vaccinations (53:00)

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations  
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated 
from PortofolioProject..CovidVaccinations$ as vac
join PortofolioProject..CovidDeaths$ as dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


-- Use CTE (1:02:11), SHOW TIME

with PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
--jumlah kolom di WITH function harus sama dengan di SELECT
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations  
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated 
from PortofolioProject..CovidVaccinations$ as vac
join PortofolioProject..CovidDeaths$ as dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select * , (RollingPeopleVaccinated)/(Population)*100 

from PopvsVac

-- Temp Table (1:06:58)

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations  
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated 
from PortofolioProject..CovidVaccinations$ as vac
join PortofolioProject..CovidDeaths$ as dea
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select * , (RollingPeopleVaccinated)/(Population)*100 

from #PercentPopulationVaccinated

-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations  
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated 
from PortofolioProject..CovidVaccinations$ as vac
join PortofolioProject..CovidDeaths$ as dea
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3