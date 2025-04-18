-- Queries of format 1 to 6 have been done in the previous sql scripts.

-- Query7 : Updating name of coach of TeamName 'Pune Warriors India' to 'Ravi Shastri';

	update team set team.Coach = 'Ravi Shastri' 
	where team.TeamName = 'Pune Warriors India';
    
	--  select * from team; 
    
-- Query8: Delete all records from the HomeTeamBattingStats and AwayTeamBattingStats tables where runs_scored is less than 50.

    delete from hometeambattingstats where hometeambattingstats.RunsScored < 50;
    delete from awayteambattingstats where awayteambattingstats.RunsScored < 50;
    
    -- select * from hometeambattingstats;
    -- select * from awayteambattingstats;

-- Query9: Insert a new match record with match_date “2019-03-15", ground location “Wankhede Stadium”, and competing team Names 'Mumbai Indians' and 'Chennai Super Kings'.
	INSERT INTO Matches (MatchNo, MatchDate, GroundLocation, AwayTeamName, MatchWinner, ManOfTheMatch) VALUES
	(11, '2019-03-15', 'Wankhede Stadium', 'Chennai Super Kings', 'Chennai Super Kings', 'MS Dhoni');
	-- select * from matches;
    
-- Query10: Update the MatchWinner of MatchNo 5 to Rajasthan Royals and ManOfTheMatch to 'Sanju Samson'  
	update matches set matches.MatchWinner = 'Rajasthan Royals', matches.ManOfTheMatch = 'Sanju Samson' where matches.MatchNo = 5;
	-- select * from matches;

-- Query11: Retrieve the highest runs scored by a player in a match, in the whole season/of all the matches played till now.
	Select max(RunsScored) as MaxRunsScoredByAPlayerInAMatch from (select RunsScored from HomeTeamBattingStats 
    UNION select RunsScored from AwayTeamBattingStats) AS BattingStats;

-- Query12: Retrieve the total number of matches won by each team till now.
	Select TeamName,No_Of_Wins from Team;
    
-- Query13: Retrieve the average age of players in each team.
	select TeamName,avg(Age) from playerplaysforteam group by TeamName;
    
-- Query14: Retrieve the highest wickets taken by a player in a match, in the whole season/of all the matches played till now.
	Select max(WicketsTaken) as MaxWicketsTakenByAPlayerInAMatch from (select WicketsTaken from hometeambowlingstats 
    UNION select WicketsTaken from awayteambowlingstats) as BowlingStats;

--     Query15: Retrive the team with the most number of runs scored across all matches
     select teamname, max(SumRunsScored) from (select teamname, sum(RunsScored) as SumRunsScored from 
     (Select teamname,Runsscored from((select HomeTeamName as TeamName, RunsScored from matches_complete 
     inner join matchhashometeambattingstats on matchhashometeambattingstats.matchno = matches_complete.matchno)
     UNION (select AwayTeamName as TeamName, RunsScored as SumOfRuns from matches_complete inner join  matchhasawayteambattingstats on 
     matchhasawayteambattingstats.matchno = matches_complete.matchno)) as RunSums) as TeamsRunsScored group by teamname) as MaxTeamRunsScored;
    
-- Query16: Retrive the PlayerName and InAtPosition for Mumbai Indians in different matches.
select TeamName, matchno, Name, InAtPosition from 
(( select HomeTeamName as TeamName,matches_complete.matchno,Name_exp_5 as Name,InAtPosition from matches_complete 
inner join matchhashometeambattingstats on matchhashometeambattingstats.matchno = matches_complete.matchno)UNION 
 (select AwayTeamName as TeamName, matches_complete.matchno,Name_exp_5 as Name,InAtPosition from matches_complete 
 inner join  matchhasawayteambattingstats on matchhasawayteambattingstats.matchno = matches_complete.matchno)) 
 as TotalBattingStats where TeamName = 'Mumbai Indians';
 
-- Query17 : Retrieve the TeamName, CoachName of the Winning Teams in different matches.
Select matchno,TeamName as WinningTeamName,Coach as WinningTeamCoach from( select matchno,MatchWinner as TeamName, coach from matches 
inner join team on matches.MatchWinner = Team.TeamName) as WinningTeamDetails;

-- Query18 : Retrive the match_date,location and player name for all the matches played by 'Hardik Pandya'
 Select matchdate,groundlocation,name from ((select matchdate,groundlocation,name from matches_complete inner join player 
 where matches_complete.hometeamname = player.teamname) UNION
 (select matchdate,groundlocation,name from matches_complete inner join player where matches_complete.awayteamname = player.teamname)) 
 AS Allplayerdetails where name = 'Hardik Pandya';
 
 -- Query19 : Retrieve the team_name,match_date and runs_scored for all matches where a specific player scored more than 50 runs.
 select TeamName,MatchDate,RunsScored from ((select HomeTeamName as TeamName,matches_complete.matchdate,RunsScored from matches_complete 
 inner join matchhashometeambattingstats on matches_complete.matchno = matchhashometeambattingstats.matchno) 
 union 
 (select AwayTeamName as TeamName,matches_complete.matchdate,RunsScored from matches_complete 
 inner join matchhasawayteambattingstats on matches_complete.matchno = matchhasawayteambattingstats.matchno)) as AllBattingStats where RunsScored > 50;
 
 -- Query20 : Retrieve player_name, match_date, wickets_taken where no of wickets taken is greater than 2.
 select name as PlayerName,matchdate,wicketstaken from ((select name_exp_5 as name,matchdate,wicketstaken from matchhashometeambowlingstats) 
 union (select name_exp_5 as name,matchdate,wicketstaken from matchhasawayteambowlingstats)) as totalbowlingstats where wicketstaken > 2;