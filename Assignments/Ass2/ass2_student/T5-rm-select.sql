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





/* (c) */
-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer


