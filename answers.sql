--Q1
SELECT country_id,
	   country_name,
	   avg(session_length) AS session_length
FROM verification_fact
GROUP BY country_id,
		 country_name
ORDER BY 3;

--Q2
SELECT verifier_id,
	   verifier_name,
	   avg(session_length) AS session_length
FROM verification_fact
WHERE country_name = 'New Zealand'
GROUP BY verifier_id,
		 verifier_name
ORDER BY 3 DESC
LIMIT 1;
