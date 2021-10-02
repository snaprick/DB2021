select * from course where credits>3;

select * from classroom where building = 'Watson' or building = 'Packard';

select * from course where dept_name = 'Comp. Sci.';

select * from course
where course_id in (
        select section.course_id
        from section
        where semester = 'Fall'
    );

select * from student where tot_cred > 45 and tot_cred<90;

select * from student where lower(name) like '%a' or lower(name) like '%e' or lower(name) like '%i' or lower(name) like '%o' or lower(name) like '%u';

select * from course
where course_id in (
        select course_id
        from prereq
        where prereq_id = 'CS-101'
    );
