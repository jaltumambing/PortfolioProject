--Select * 
--From PortfolioProject..CovidDeaths
--Order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--Order by 3,4 

--Select location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths
--Order by 1,2

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
--From PortfolioProject..CovidDeaths
--Where location like 'Philippines'
--Order by 1,2

--Select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as Death_Percentage
--From PortfolioProject..CovidDeaths
--Where location like 'Philippines'
--Order by 1,2

--Select location, population, Max(total_cases) as Highest_Infection_Count, max((total_cases/population))*100 as Infection_Rate
--From PortfolioProject..CovidDeaths
--Group by Location, Population
----Where location like 'Philippines'
--Order by 4 desc

--Select location, population, max(total_cases) as MaxCases, max(cast(total_deaths as int)) as MaxDeaths, max(cast(total_deaths as int))/max(total_cases)*100
--From PortfolioProject..CovidDeaths
--Group By location, population
--Order by 5 desc

--Select continent, max(population) as HighestPopulation
--From PortfolioProject..CovidDeaths
--Where continent is not null
--group by continent
--Order by 2 

--Select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as TotalDeathRate
--From PortfolioProject..CovidDeaths
Drop Table if exists #RollingPeopleVaccinated
Create Table #RollingPeopleVaccinated
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_Vaccinations bigint,
	RollingPeopleVaccinated bigint
)
Insert into #RollingPeopleVaccinated
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	convert(bigint,vac.new_vaccinations), 
sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And	dea.date = vac.date
Where dea.continent is not null
Order by 1,2

Select *, (RollingPeopleVaccinated/Population)*100
From #RollingPeopleVaccinated

Create View RollingPeopleVaccinated as
Select 
	dea.continent, 
	dea.location, 
	dea.date, 
	dea.population, 
	convert(bigint,vac.new_vaccinations) as NewVaccinations, 
	sum(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	And	dea.date = vac.date
Where dea.continent is not null