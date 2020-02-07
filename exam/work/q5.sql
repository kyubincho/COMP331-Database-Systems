-- COMP3311 12s1 Exam Q5
-- The Q5 view must have attributes called (team,reds,yellows)

drop view if exists yellow;
create view yellow
as
select T.country as country, count(C.id) as yellow
from Teams T join Players P on P.memberOf = T.id
             join Cards C on C.givenTo = P.id
where  C.cardType = 'yellow'
group by T.country
order by T.country
;

drop view if exists red;
create view red
as
select T.country as country, count(C.id) as red
from Teams T join Players P on P.memberOf = T.id
             join Cards C on C.givenTo = P.id
where  C.cardType = 'red'
group by T.country
order by T.country
;

drop view if exists Q5;
create view Q5
as
select Y.country as team, R.red as red, Y.yellow as yellow
from yellow Y, red R
where Y.country = R.country
;
