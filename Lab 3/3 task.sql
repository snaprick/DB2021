--a
select distinct id, name
from student
where id in (
        select id
        from takes
        where grade in('A','A-') and course_id in(
                select course_id
                from course
                where course.dept_name = 'Comp. Sci.'
            )
    )
order by name;
--b
select distinct i_id
from advisor
where s_id in (
        select id
        from takes
        where grade not in ('A','A-','B+','B')
    );
--c
select distinct dept_name
from course
where dept_name not in (
        select dept_name
        from course
        where course_id in(
            select course_id
            from takes
            where takes.grade in ('F','C')
            )
    );
--d
select distinct id
from teaches
where id not in(
    select teaches.id
    from teaches
    where (course_id,sec_id,year) in (
            select course_id,sec_id,year
            from takes
            where grade = 'A'
        )
    );
--e
select course_id,title
from course
where course_id in (
        select course_id
        from section
        where time_slot_id  in (
            select distinct time_slot_id
            from time_slot
            where time_slot_id not in (
            select time_slot_id
            from time_slot
            where end_hr > 12)
        )
    );
