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
  TO_CHAR(t.carn_date, 'DD-Mon-YYYY') AS CARNIVAL_DATE,
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
  c.carn_name || ' held ' || TO_CHAR(c.carn_date,'fmDy DD-Mon-YYYY') AS "Carnival",
  TO_CHAR(en.entry_elapsedtime,'HH24:MI:SS')            AS "Current Record",
  en.comp_no || ' ' || comp.comp_fname || ' ' || comp.comp_lname AS "Competitor No and Name",
  FLOOR((c.carn_date - comp.comp_dob) / 365)           AS "Age at Carnival"
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

SELECT
  c.carn_name AS "Carnival Name",
  TO_CHAR(c.carn_date,'DD Mon YY') AS "Carnival Date",
  et.eventtype_desc AS "Event Description",
  CASE WHEN NVL(ce.cnt,0) = 0 THEN 'Not offered'
       ELSE TO_CHAR(ce.cnt)
  END                         AS "Number of Entries",
  CASE WHEN NVL(ce.cnt,0) = 0 THEN ''
       ELSE TO_CHAR(ROUND(ce.cnt * 100 / tot.total_entries, 0))
  END                         AS "% of Carnival Entries"
FROM carnival c
CROSS JOIN eventtype et
LEFT JOIN (
  SELECT e.carn_date, e.eventtype_code, COUNT(*) AS cnt
    FROM entry en
    JOIN event e ON en.event_id = e.event_id
   GROUP BY e.carn_date, e.eventtype_code
) ce
  ON ce.carn_date       = c.carn_date
 AND ce.eventtype_code  = et.eventtype_code
LEFT JOIN (
  SELECT e.carn_date, COUNT(*) AS total_entries
    FROM entry en
    JOIN event e ON en.event_id = e.event_id
   GROUP BY e.carn_date
) tot
  ON tot.carn_date = c.carn_date
ORDER BY c.carn_date, NVL(ce.cnt,0) DESC, et.eventtype_desc
;

