-- COMP3311 12s1 Exam Q4
-- The Q4 view must have attributes called (team1, team2, matches)

drop view if exists Match;
create view Match
as
select M.id as matchid, T1.id as team1id, T1.country as team1,
                        T2.id as team2id, T2.country as team2,
                        m.city, m.playedOn
from Matches M join Involves I1 on I1.match = M.id
               join Involves I2 on I2.match = M.id
               join Teams T1 on T1.id = I1.team
               join Teams T2 on T2.id = I2.team
where T1.country < T2.country                 
;

drop view if exists versus;
create view versus
as
select team1, team2, count(*) as matches
from Match
group by team1, team2
;

drop view if exists Q4;
create view Q4
as
select team1, team2, matches 
from versus
where matches = (select max(matches) from versus)
;
