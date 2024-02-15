select * from PortfolioProject92..[covid-data-deaths]
where continent is not null
order by 3,4


--select * from PortfolioProject92..[covid-vaccitions]
--order by 3,4

-- select data that we are going to be using

select Location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject92..[covid-data-deaths]
where continent is not null
order by 1,2


-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject92..[covid-data-deaths] where location like '%states%' and continent is not null
order by 1,2




-- looking at total cases vs population
-- shows what percentage of population got Covid

select Location, date, population, total_cases, (total_cases/population)*100as CasesPercentage
from PortfolioProject92..[covid-data-deaths] where location like '%states%' and continent is not null
order by 1,2



-- let's break things down by continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject92..[covid-data-deaths]
--where  location like '%states'
where continent is not null
group by continent
order by TotalDeathCount desc




-- showing continents with the highest death count per population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject92..[covid-data-deaths]
--where  location like '%states'
where continent is not null
group by continent
order by TotalDeathCount desc




-- global numbers 

select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from PortfolioProject92..[covid-data-deaths]
--where location like '%states%' 
where continent is not null
--group by date
order by 1,2




-- looking at total population vs vaccinations

-- use CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject92..[covid-data-deaths] dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
and vac.new_vaccinations is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac




-- temp table

Drop Table if exists #PercentPopulationVaccinated
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
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject92..[covid-data-deaths] dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
--where dea.continent is not null
and vac.new_vaccinations is not null
--order by 2,3


select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated







-- creating viewto store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from PortfolioProject92..[covid-data-deaths] dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
and vac.new_vaccinations is not null
--order by 2,3


select * 
from PercentPopulationVaccinated