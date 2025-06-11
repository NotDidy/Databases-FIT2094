/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T5-rm-select.sql

--Student ID: 33523061
--Student Name: MUHAMMAD JOHAN ARIEF BIN MULIADEE


/* Comments for your marker:




*/


/* (a) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
  t.team_name AS TEAM_NAME,
  t.carn_date AS CARNIVAL_DATE,
  comp.comp_fname || ' ' || comp.comp_lname AS TEAMLEADER,
  (SELECT COUNT(*) FROM entry e2 WHERE e2.team_id = t.team_id) AS TEAM_NO_MEMBERS
FROM team t
JOIN entry leader_entry
  ON leader_entry.event_id = t.event_id
 AND leader_entry.entry_no  = t.entry_no
JOIN competitor comp
  ON comp.comp_no = leader_entry.comp_no
WHERE t.carn_date < SYSDATE
  AND (
    SELECT COUNT(*)
      FROM team t2
     WHERE t2.team_name = t.team_name
       AND t2.carn_date < SYSDATE
  ) = (
    SELECT MAX(cnt) FROM (
      SELECT COUNT(*) AS cnt
        FROM team t3
       WHERE t3.carn_date < SYSDATE
       GROUP BY t3.team_name
    )
  )
ORDER BY t.team_name, t.carn_date
;




/* (b) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
  et.eventtype_desc AS "Event",
  c.carn_name || ', ' || TO_CHAR(c.carn_date,'fmDay DD-Mon-YYYY') AS "Carnival",
  TO_CHAR(en.entry_elapsedtime,'HH24:MI:SS')            AS "Current Record",
  en.comp_no || ' ' || comp.comp_fname || ' ' || comp.comp_lname AS "Competitor No and Name",
  TRUNC(MONTHS_BETWEEN(c.carn_date, comp.comp_dob)/12)  AS "Age at Carnival"
FROM entry en
JOIN event e
  ON en.event_id = e.event_id
JOIN eventtype et
  ON e.eventtype_code = et.eventtype_code
JOIN carnival c
  ON e.carn_date = c.carn_date
JOIN competitor comp
  ON en.comp_no = comp.comp_no
WHERE en.entry_elapsedtime IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
      FROM entry en2
      JOIN event e2 ON en2.event_id = e2.event_id
     WHERE en2.entry_elapsedtime IS NOT NULL
       AND e2.eventtype_code = e.eventtype_code
       AND en2.entry_elapsedtime < en.entry_elapsedtime
  )
ORDER BY et.eventtype_desc, en.comp_no
;



/* (c) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer


