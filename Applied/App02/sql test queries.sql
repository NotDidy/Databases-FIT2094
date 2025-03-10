/*Select everything from students table */
select * from student;

/*Displays all students who live in Moorabbin*/
select * 
from student 
where studaddress like '%Moorabbin';

/*Displays the first name and last name of all students who live in Moorabbin*/
select studfname, studlname 
from student 
where studaddress like '%Moorabbin';