CREATE PROCEDURE procedure_edw() 
LANGUAGE plpgsql    
AS $$
BEGIN
	TRUNCATE TABLE session_dim;

	TRUNCATE TABLE verification_fact;


	INSERT INTO session_dim (session_uuid, start_event_id, end_event_id, start_time, end_time)
	SELECT a.session_uuid,
		   a.start_event_id,
		   b.end_event_id,
		   a.start_time,
		   b.end_time
	FROM
	  (SELECT session_uuid,
			  Min(created_at) AS start_time,
			  Max(UUID) AS start_event_id
	   FROM events_lnd a
	   WHERE event_type = 'session_started' GROUP  BY session_uuid)a
	LEFT JOIN
	  (SELECT session_uuid,
			  Max(created_at) AS end_time,
			  Max(UUID) AS end_event_id
	   FROM events_lnd a
	   WHERE event_type = 'session_finished' GROUP  BY session_uuid)b ON a.session_uuid = b.session_uuid;


	INSERT INTO verification_fact (session_key, session_uuid, country_id, verifier_id, status, start_time, end_time, country_name, verifier_name, session_length)
	SELECT a.id AS session_key,
		   a.session_uuid AS session_uuid,
		   c.uuid AS country_id,
		   d.uuid AS verifier_id,
		   b.status AS status,
		   start_time,
		   end_time,
		   c.country AS country_name,
		   d.verifier_name AS verifier_name,
		   Extract(epoch
				   FROM (end_time) - (start_time)) AS session_length
	FROM session_dim a
	JOIN sessions_lnd b ON a.session_uuid = b.uuid
	JOIN countries_lnd c ON b.country_uuid = c.uuid
	JOIN verifiers_lnd d ON b.verifier_uuid = d.uuid;

END;
$$