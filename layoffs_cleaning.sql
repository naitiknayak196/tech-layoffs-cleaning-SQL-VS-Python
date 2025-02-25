
SELECT * 
FROM layoffs; 
--  Create a staging table
CREATE TABLE layoffs_clean 
LIKE world_layoffs.layoffs;

INSERT layoffs_clean 
SELECT * FROM world_layoffs.layoffs;

SELECT * FROM layoffs_clean;


-- Identifying duplicate
Select *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_clean;
-- Create a CTE to extract duplicate records
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_clean)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

SELECT * FROM layoffs_clean WHERE company = 'Oyster';

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_clean)
DELETE
FROM duplicate_cte
WHERE row_num >1;



CREATE TABLE layoffs_clean2 AS 
SELECT *, 
       ROW_NUMBER() OVER (
           PARTITION BY company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions
       ) AS row_num
FROM layoffs_clean;


SELECT * FROM layoffs_clean2;
-- Removing duplicate records
DELETE FROM layoffs_clean2 
WHERE row_num > 1;

SELECT * FROM layoffs_clean2
WHERE row_num > 1;

-- Standardizing Data by trimming
SELECT company, TRIM(company) 
FROM  layoffs_clean2;

-- Standardizing country names to a uniform format
UPDATE layoffs_clean2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM  layoffs_clean2
ORDER BY 1;

SELECT DISTINCT country
FROM  layoffs_clean2
ORDER BY 1;

UPDATE layoffs_clean2
SET country = 'United States'
WHERE country like 'United States%';

-- Convert date column from text format to DATE
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y') AS formatted_date
FROM layoffs_clean2;

UPDATE layoffs_clean2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_clean2
MODIFY COLUMN `date` DATE;

SELECT * FROM layoffs_clean2;

-- Removing Null Values
SELECT * FROM layoffs_clean2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_clean2
WHERE industry IS NULL 
OR industry = ' ';

UPDATE layoffs_clean2
SET industry = NULL 
WHERE industry = ' ';


SELECT c1.industry, c2.industry
FROM layoffs_clean2 c1
JOIN layoffs_clean2 c2
	ON c1.company = c2.company
WHERE (c1.industry IS NULL OR c1.industry = ' ')
AND c2.industry IS NOT NULL;

UPDATE layoffs_clean2 c1
JOIN layoffs_clean2 c2
	ON c1.company = c2.company
    SET c1.industry = c2.industry
WHERE c1.industry IS NULL 
AND c2.industry IS NOT NULL;

SELECT * FROM layoffs_clean2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Removing rows where both total_laid_off and percentage_laid_off are NULL
DELETE FROM layoffs_clean2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Dropping the row_num column as it's no longer needed
ALTER TABLE layoffs_clean2
DROP COLUMN row_num;

select * from layoffs_clean2;
-- Analyzing layoff trends
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_clean2;

SELECT * FROM layoffs_clean2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_clean2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_clean2;


-- Finding the earliest and latest layoffs recorded in the dataset
SELECT MAX(total_laid_off), industry 
FROM layoffs_clean2
GROUP BY industry
ORDER BY 1 DESC;


-- Summarizing total layoffs per country and sorting by highest layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_clean2
GROUP BY country
ORDER BY 2 DESC;


-- Aggregating layoffs per year to analyze yearly trends
SELECT YEAR(`date`) AS 'Year' , SUM(total_laid_off)
FROM layoffs_clean2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Aggregating layoffs per month to analyze monthly trends
SELECT SUBSTRING(`date`, 1 ,7) AS `MONTH`, SUM(total_laid_off) AS total
FROM layoffs_clean2
GROUP BY SUBSTRING(`date`, 1 ,7)
ORDER BY 1 ASC;


-- Identifying the top 5 companies with the highest layoffs each year
WITH rolling_total AS (

SELECT SUBSTRING(`date`, 1 ,7) AS `MONTH`, SUM(total_laid_off) AS total
FROM layoffs_clean2
GROUP BY SUBSTRING(`date`, 1 ,7)
ORDER BY 1 ASC)
SELECT `MONTH`, total, SUM(total) OVER(ORDER BY  `MONTH`) AS rolling_total 
FROM rolling_total;

SELECT company, YEAR( `date`), SUM(total_laid_off)
FROM layoffs_clean2
GROUP BY company, YEAR( `date`)
ORDER BY 3 DESC;

-- Identifying the top 5 companies with the highest layoffs each year
WITH Company_Year (company, years, total_laid_off) AS
(SELECT company, YEAR( `date`), SUM(total_laid_off)
FROM layoffs_clean2
GROUP BY company, YEAR( `date`)
), Company_Year_Rank AS (SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
