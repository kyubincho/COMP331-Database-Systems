-- COMP3311 12s1 Exam Q2
-- The Q2 view must have one attribute called (player,goals)

drop view if exists Q2;
create view Q2
as
select P.name as player, count(G.id) as goals
from Players P join Goals G on P.id = G.scoredBy
where G.rating = 'amazing'
group by P.name
having count(G.id) > 1
;
