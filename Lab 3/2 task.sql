--a
select dept_name, avg(salary)
from instructor
group by dept_name
order by avg(salary);
--b
select foo.building,count(*)
from (select distinct building,course_id from section) as foo
group by foo.building
having count(*) =
       (select max(cnt)
        from (
                select count(*) as cnt
                from (select distinct building,course_id from section) as foo
                group by foo.building
             ) as mx
       );
--c
select foo.dept_name,count(*)
from (select dept_name,course_id from course) as foo
group by foo.dept_name
having count(*) =
       (select min(cnt)
        from (
                select count(*) as cnt
                from (select dept_name,course_id from course) as foo
                group by foo.dept_name
             ) as mn
       );

--d
select student.id,student.name, count(takes.id) as count
from takes,student, course
where takes.id = student.id and takes.course_id=course.course_id
and course.dept_name = 'Comp. Sci.'
group by student.id, student.name
having count(*) > 3;
--e
select * from instructor
where dept_name in ('Music','Biology','Philosophy');
--f
select distinct id,name
from instructor
where id in (
        select id
        from teaches
        where year=2018 and id not in(
                select id
                from teaches
                where year = 2017
            )
    );