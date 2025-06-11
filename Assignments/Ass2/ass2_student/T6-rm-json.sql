/*****PLEASE ENTER YOUR DETAILS BELOW*****/
--T6-rm-json.sql

--Student ID: 33523061
--Student Name: MUHAMMAD JOHAN ARIEF BIN MULIADEE


/* Comments for your marker:




*/





-- PLEASE PLACE REQUIRED SQL SELECT STATEMENT FOR THIS PART HERE
-- ENSURE that your query is formatted and has a semicolon
-- (;) at the end of this answer

SELECT
  JSON_OBJECT(
    '_id'               VALUE t.team_id,
    'carn_name'         VALUE c.carn_name,
    'carn_date'         VALUE TO_CHAR(c.carn_date,'DD/MON/YYYY'),
    'team_name'         VALUE t.team_name,
    'team_leader'       VALUE JSON_OBJECT(
                            'name'  VALUE leader.comp_fname || ' ' || leader.comp_lname,
                            'phone' VALUE leader.comp_phone,
                            'email' VALUE leader.comp_email
                          ),
    'team_members'      VALUE JSON_ARRAYAGG(
                            JSON_OBJECT(
                              'competitor_name'  VALUE mem.comp_fname || ' ' || mem.comp_lname,
                              'competitor_phone' VALUE mem.comp_phone,
                              'event_type'       VALUE et.eventtype_desc,
                              'entry_no'         VALUE m.entry_no,
                              'starttime'        VALUE NVL(TO_CHAR(m.entry_starttime,'HH24:MI:SS'),'-'),
                              'finishtime'       VALUE NVL(TO_CHAR(m.entry_finishtime,'HH24:MI:SS'),'-'),
                              'elapsedtime'      VALUE NVL(TO_CHAR(m.entry_elapsedtime,'HH24:MI:SS'),'-')
                            ) ORDER BY m.entry_no
                          )
  ) AS team_json
FROM team t
JOIN carnival c
  ON t.carn_date = c.carn_date
-- team leader
JOIN entry el
  ON el.event_id = t.event_id
 AND el.entry_no = t.entry_no
JOIN competitor leader
  ON leader.comp_no = el.comp_no
-- team members
LEFT JOIN entry m
  ON m.team_id = t.team_id
LEFT JOIN competitor mem
  ON mem.comp_no = m.comp_no
LEFT JOIN event ev
  ON ev.event_id = m.event_id
LEFT JOIN eventtype et
  ON et.eventtype_code = ev.eventtype_code
GROUP BY
  t.team_id,
  c.carn_name,
  c.carn_date,
  t.team_name,
  leader.comp_fname,
  leader.comp_lname,
  leader.comp_phone,
  leader.comp_email;





