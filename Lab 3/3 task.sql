--a
select distinct student.id, name
from takes, course, student
where takes.course_id = course.course_id
  and takes.id = student.id
  and course.dept_name = 'Comp. Sci.'
  and grade in('A','A-')
order by name;
--b
select instructor.name, instructor.id
from instructor, advisor, student, takes
where instructor.id = advisor.i_id
  and advisor.s_id = student.id
  and student.id = takes.id
  and takes.grade not in ('A','A-','B')
group by instructor.name, instructor.id;
--c
select course.dept_name from course, takes
where course.course_id = takes.course_id
and course.dept_name not in (
        select course.dept_name
        from course, takes
        where course.course_id = takes.course_id
        and takes.grade in ('F','C')
    )
group by course.dept_name;
--d
select id
from teaches
where id not in(
    select teaches.id
    from teaches,takes
    where teaches.course_id = takes.course_id
      and teaches.sec_id = takes.sec_id
      and teaches.year = takes.year
      and takes.grade = 'A'
    )
group by id;
--e
select course_id,title
from course
where course_id in (
        select course_id
        from section, time_slot
        where section.time_slot_id = time_slot.time_slot_id
        and time_slot.time_slot_id in (
            select distinct time_slot_id
            from time_slot
            where time_slot_id not in (
            select time_slot_id
            from time_slot
            where end_hr > 12)
        )
    );
