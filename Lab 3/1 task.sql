select * from course where credits>3;

select * from classroom where building = 'Watson' or building = 'Packard';

select * from course where dept_name = 'Comp. Sci.';

select distinct course_id from section where semester = 'Fall';

select * from student where tot_cred > 45 and tot_cred<90;

select * from student where name like '%a' or name like '%e' or name like '%i' or name like '%o' or name like 'u';

select course_id from prereq where prereq_id = 'CS-101';
