/*
====================================================================
PROJECT     : AmbitionBox Analysis
AUTHOR      : Daffa Kumara
DESCRIPTION : PostgreSQL queries for aggregating and analyzing
              company reviews to debunk workplace culture myths 
              related to company size, type, and age.
====================================================================
*/

-- -----------------------------------------------------------------
-- EXPERIMENT 1: Company Size vs. Employee Satisfaction
-- Objective: Test the myth that small companies have better culture 
--            than large corporate giants.
-- -----------------------------------------------------------------
SELECT 
    CASE
        WHEN employees > 6000 THEN 'Raksasa'
        WHEN employees BETWEEN 1000 AND 6000 THEN 'Menengah'
        ELSE 'Kecil'
    END AS company_size,
    ROUND(AVG(rating)::numeric, 2) AS avg_rating,
    COUNT(name) AS total_companies
FROM company_data
WHERE employees IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;


-- -----------------------------------------------------------------
-- EXPERIMENT 2: Low-Performing Company Types & Review Ratios
-- Objective: Identify company types struggling with satisfaction 
--            (rating < 4.0) and analyze their review-to-employee ratio.
-- -----------------------------------------------------------------
SELECT
    type,
    ROUND(AVG(rating)::numeric, 2) AS avg_rating,
    ROUND(SUM(reviews)::numeric / SUM(employees)::numeric, 2) AS review_ratio
FROM company_data
WHERE type != 'Unknown'
GROUP BY 1
HAVING ROUND(AVG(rating)::numeric, 2) < 4.0
ORDER BY 3 DESC;


-- -----------------------------------------------------------------
-- EXPERIMENT 3: Company Generation vs. Employee Satisfaction
-- Objective: Compare satisfaction across Legacy (>50y), Established, 
--            and Agile/Startup (<10y) companies.
-- -----------------------------------------------------------------
SELECT 
    CASE
        WHEN old > 50 THEN 'Legacy'
        WHEN old BETWEEN 10 AND 50 THEN 'Established'
        WHEN old < 10 THEN 'Agile'
    END AS company_generation,
    ROUND(AVG(rating)::numeric, 2) AS avg_rating,
    COUNT(name) AS total_companies
FROM company_data
WHERE old IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;
