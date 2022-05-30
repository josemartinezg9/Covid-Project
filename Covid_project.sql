SELECT *
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 3, 4;


-- Select data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;


-- Looking at Total cases vs Total deaths
-- show likelihood of dying if you contract covid in your country--

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM covid_project.covid_deaths
WHERE location = 'colombia'
AND continent IS NOT NULL
ORDER BY 1, 2;


-- looking at total_cases vs population--
-- shows what percentage of population got covid--

SELECT location, date, population,total_cases,(total_cases/population)*100 AS percent_population_infected
FROM covid_project.covid_deaths
WHERE location = 'colombia'
AND continent IS NOT NULL
ORDER BY 1, 2;


-- looking at countries with highests infection rates compared to population--

SELECT location,population, MAX(total_cases) AS highest_infection_count,MAX((total_cases/population))*100 AS percent_population_infected
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY percent_population_infected DESC;


-- showing countries with highest death count per population --
SELECT location, MAX( CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;


-- let´s breakdown by continent --
SELECT continent, MAX( CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Showing continent by the highest death count --
SELECT continent, MAX( CAST(total_deaths AS UNSIGNED)) AS total_death_count
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;


-- Global count per day --
SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths) / SUM(new_cases)*100 AS deaths_percentage
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2;


-- Global count --
SELECT SUM(population)AS Global_Population, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths) / SUM(new_cases)*100 AS death_percentages
FROM covid_project.covid_deaths
WHERE continent IS NOT NULL
-- GROUP BY date --
ORDER BY 1, 2;


-- Looking at total population vs vaccination (CTE) --

WITH pop_vs_vac (contitent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- (rolling_people_vaccinated/population)*100 --
FROM covid_project.covid_deaths dea
JOIN covid_project.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL)
SELECT * 
FROM pop_vs_vac
;

-- select creating to store data for later visualization --
CREATE VIEW pop_vs_vac AS
 WITH pop_vs_vac (contitent, location, date, population, new_vaccinations, rolling_people_vaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
-- (rolling_people_vaccinated/population)*100 --
FROM covid_project.covid_deaths dea
JOIN covid_project.covid_vaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL)
SELECT * 
FROM pop_vs_vac
;


