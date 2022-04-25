--select *
--from PortofolioProject..CovidDeaths$
--order by 3,4;

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
--Select Location, date, population, total_cases, (cast(total_cases as float)/cast(population as float))*100 as PercentPopulationInfected
--from PortofolioProject..CovidDeaths$
----where location like '%states%'
--order by 1,2;

-- Looking at countries with highest infection rate compared to population

Select Location, population, max(cast(total_cases as float)) as HighestInfectionCount, max((cast(total_cases as float)/cast(population as float)))*100 as  PercentPopulationInfected
from PortofolioProject..CovidDeaths$
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population

Select Location, max(cast(total_deaths as float)) as TotalDeathCount
from PortofolioProject..CovidDeaths$
--where location like '%states%'
Group by Location
order by TotalDeathCount desc
