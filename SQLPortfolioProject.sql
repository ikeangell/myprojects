Select *
From PortfolioProject..CovidDeaths
order by 3,4

-- Select Data to be used 
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2

-- Death percentage in United States 
Select location, date, total_deaths, total_cases, (total_deaths/total_cases)*100 as DeathPercent
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

-- Case percent in United States
Select location, date, population, total_cases, (total_cases/population)*100 as CasePercent
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2

--Highest infecton rate amongst countries
Select location, population, MAX(total_cases) as MaxInfection, MAX((total_cases/population))*100 as CasePercentInfected
From PortfolioProject..CovidDeaths
Group by location,population
order by CasePercentInfected desc

-- Countries with highest death count 
Select location, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by TotalDeaths desc

-- Death count by continent 
Select continent, MAX(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeaths desc

--New cases each day across the world 
Select date, SUM(new_cases) as GlobalNew
From PortfolioProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

--New deaths based on new cases across the world 
Select date, SUM(new_cases) as GlobalNew, SUM(cast(new_deaths as int)) as GlobalNewDeaths
From PortfolioProject..CovidDeaths
where continent is not null
Group by date 
order by 1,2

-- Percentage of new deaths based on new cases across the world 
Select date, SUM(new_cases) as GlobalNew, SUM(cast(new_deaths as int)) as GlobalNewDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as GlobalNewDeathsPercent
From PortfolioProject..CovidDeaths
where continent is not null
Group by date 
order by 1,2

-- Death percentage across the world 
Select SUM(new_cases) as GlobalCases, SUM(cast(new_deaths as int)) as GlobalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as GlobalDeathPercent
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

-- Joining two tables
Select *
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
On dea.location = vax.location 
and dea.date = vax.date

-- Total amount of people who have been vaccinated by population
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
On dea.location = vax.location 
and dea.date = vax.date
where dea.continent is not null
order by 2,3

-- Continous count of people vaccinated by date 
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(cast(vax.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
On dea.location = vax.location 
and dea.date = vax.date
where dea.continent is not null
order by 2,3

-- Creating a CTE
With PopVsVax (continent, location, date, population, new_vaccinations, PeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations,
SUM(cast(vax.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinated 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vax
On dea.location = vax.location 
and dea.date = vax.date
where dea.continent is not null
)
-- Continous percentage count of people vaccinated 
Select *, (PeopleVaccinated/population)*100
From PopVsVax