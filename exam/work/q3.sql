-- COMP3311 12s1 Exam Q3
-- The Q3 view must have attributes called (team,players)

drop view if exists playersGoals;
create view playersGoals
as
select P.id as player, T.country as team, count(G.id) as goals
from Teams T join Players P on P.memberOf = T.id
             left outer join Goals G on G.scoredBy = P.id
group by p.id, t.country
;

drop view if exists zeroGoals;
create view zeroGoals
as
select team, count(*) as players
from playersGoals
where goals = 0
group by team
;

drop view if exists Q3;
create view Q3
as
select team, players
from zeroGoals
where players = (select max(players) from zeroGoals)
;
