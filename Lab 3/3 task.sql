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
select department.dept_name from department, course, takes
where department.dept_name = course.dept_name and course.course_id = takes.course_id
and department.dept_name not in (
        select department.dept_name
        from department, course, takes
        where department.dept_name = course.dept_name and course.course_id = takes.course_id
        and takes.grade in ('F','C')
    )
group by department.dept_name;
--d
select instructor.id
from instructor,teaches,takes
where instructor.id = teaches.id
  and teaches.course_id = takes.course_id
  and teaches.sec_id = takes.sec_id
  and teaches.year = takes.year
  and instructor.id not in(
    select instructor.id
    from instructor,teaches,takes
    where instructor.id = teaches.id
      and teaches.course_id = takes.course_id
      and teaches.sec_id = takes.sec_id
      and teaches.year = takes.year
      and takes.grade = 'A'
    )
group by instructor.id
;
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
