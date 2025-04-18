-- Creating Views to represent the complete tables that have been split while conversion to 3NF form and to represent the relationships between different tables.

-- To get the view of the complete matches relational schema, we create a view that joins the matches table and Team table and selects only the required fields.
create view Matches_complete as 
select Matches.MatchNo,Matches.matchdate,Matches.GroundLocation,Team.TeamName as HomeTeamName,Matches.AwayTeamName,Matches.MatchWinner,Matches.ManOfTheMatch
from cricketmatch.matches INNER JOIN cricketmatch.team ON matches.GroundLocation = Team.Home_Ground;

-- Similary creating views to get the complete view of relational schemas HomeTeamBattingStats,AwayTeamBattingStats,HomeTeamBowlingStats,AwayTeamBowlingStats
create view HomeTeamBattingStats_complete
as select HomeTeamBattingStats.MatchNo, HomeTeamBattingStats.PlayerID,Player.Name,HomeTeamBattingStats.InAtPosition, HomeTeamBattingStats.RunsScored, HomeTeamBattingStats.StrikeRate, HomeTeamBattingStats.No_Of_4s, HomeTeamBattingStats.No_Of_6s
from HomeTeamBattingStats INNER JOIN Player ON HomeTeamBattingStats.PlayerID = Player.PlayerID;

create view AwayTeamBattingStats_complete
as select AwayTeamBattingStats.MatchNo, AwayTeamBattingStats.PlayerID,Player.Name,AwayTeamBattingStats.InAtPosition, AwayTeamBattingStats.RunsScored, AwayTeamBattingStats.StrikeRate, AwayTeamBattingStats.No_Of_4s, AwayTeamBattingStats.No_Of_6s
from AwayTeamBattingStats INNER JOIN Player ON AwayTeamBattingStats.PlayerID = Player.PlayerID;

create view HomeTeamBowlingStats_complete as 
select HomeTeamBowlingStats.MatchNo, HomeTeamBowlingStats.PlayerID, Player.Name, HomeTeamBowlingStats.BowlingType, HomeTeamBowlingStats.OversBowled, HomeTeamBowlingStats.WicketsTaken, HomeTeamBowlingStats.EconomyRate
from HomeTeamBowlingStats INNER JOIN Player ON HomeTeamBowlingStats.PlayerID = Player.PlayerID; 

create view AwayTeamBowlingStats_complete as 
select AwayTeamBowlingStats.MatchNo, AwayTeamBowlingStats.PlayerID, Player.Name, AwayTeamBowlingStats.BowlingType, AwayTeamBowlingStats.OversBowled, AwayTeamBowlingStats.WicketsTaken, AwayTeamBowlingStats.EconomyRate
from AwayTeamBowlingStats INNER JOIN Player ON AwayTeamBowlingStats.PlayerID = Player.PlayerID;

-- Creating Views for the relations

create view PlayerPlaysForTeam as
select Team.TeamName, Team.Captain, Team.Coach, Team.No_Of_Wins, Team.Home_Ground, Player.PlayerID, Player.Name, Player.Age, Player.Nationality, Player.Role 
from Team INNER JOIN Player ON Team.TeamName = Player.TeamName;

create view OfficialOfficiatesForMatch as
select MatchOfficials.MatchNo, Matches.MatchDate, Matches.GroundLocation,(select TeamName from Team where Team.Home_Ground = Matches.GroundLocation), Matches.AwayTeamName, MatchOfficials.MatchReferee, MatchOfficials.MatchScorer, MatchOfficials.CheifSecurityOfficer, MatchOfficials.CheifGroundCurator, MatchOfficials.Umpire1,MatchOfficials.Umpire2, MatchOfficials.Umpire3
from Matches INNER JOIN MatchOfficials ON Matches.MatchNo = MatchOfficials.MatchNo;

create view TeamPlaysInMatchAsHomeTeam as
select Matches.MatchNo, Matches.MatchDate, Matches.GroundLocation, (select TeamName as HomeTeamName from Team where Team.Home_Ground = Matches.GroundLocation), Team.Captain as HomeTeamCaptain, Team.Coach as HomeTeamCoach,Team.No_Of_Wins as HomeTeamNoOfWins, Team.Most_Runs as HomeTeamMostRuns, Team.Most_Wickets as HomeTeamMostWickets
from Team INNER JOIN Matches ON Team.Home_Ground = Matches.GroundLocation;

create view TeamPlaysInMatchAsAwayTeam as
select Matches.MatchNo, Matches.MatchDate, Matches.GroundLocation, Matches.AwayTeamName as AwayTeamName, Team.Captain as AwayTeamCaptain, Team.Coach as AwayTeamCoach,Team.No_Of_Wins as AwayTeamNoOfWins, Team.Most_Runs as AwayTeamMostRuns, Team.Most_Wickets as AwayTeamMostWickets
from Team INNER JOIN Matches ON Team.TeamName = Matches.AWayTeamName;

create view MatchHasHomeTeamBattingStats as
select Matches.MatchNo, Matches.MatchDate, Matches.GroundLocation,HomeTeamBattingStats.PlayerID, (select Name from Player WHERE HomeTeamBattingStats.PlayerID = Player.PlayerID), HomeTeamBattingStats.InAtPosition, HomeTeamBattingStats.RunsScored, HomeTeamBattingStats.StrikeRate, HomeTeamBattingStats.No_Of_4s, HomeTeamBattingStats.No_Of_6s
from Matches INNER JOIN HomeTeamBattingStats ON Matches.MatchNo = HomeTeamBattingStats.MatchNo;

create view MatchHasAwayTeamBattingStats as
select Matches.MatchNo, Matches.MatchDate, Matches.GroundLocation,AwayTeamBattingStats.PlayerID, (select Name from Player WHERE AwayTeamBattingStats.PlayerID = Player.PlayerID), AwayTeamBattingStats.InAtPosition, AwayTeamBattingStats.RunsScored, AwayTeamBattingStats.StrikeRate, AwayTeamBattingStats.No_Of_4s, AwayTeamBattingStats.No_Of_6s
from Matches INNER JOIN AwayTeamBattingStats ON Matches.MatchNo = AwayTeamBattingStats.MatchNo;

create view MatchHasHomeTeamBowlingStats as 
select Matches.MatchNo, Matches.MatchDate, Matches.GroundLocation, HomeTeamBowlingStats.PlayerID, (select Name from Player WHERE HomeTeamBowlingStats.PlayerID = Player.PlayerID), HomeTeamBowlingStats.BowlingType, HomeTeamBowlingStats.OversBowled, HomeTeamBowlingStats.WicketsTaken, HomeTeamBowlingStats.EconomyRate
from Matches INNER JOIN HomeTeamBowlingStats ON Matches.MatchNo = HomeTeamBowlingStats.MatchNo; 

create view MatchHasAwayTeamBowlingStats as 
select Matches.MatchNo, Matches.MatchDate, Matches.GroundLocation, AwayTeamBowlingStats.PlayerID, (select Name from Player WHERE AwayTeamBowlingStats.PlayerID = Player.PlayerID), AwayTeamBowlingStats.BowlingType, AwayTeamBowlingStats.OversBowled, AwayTeamBowlingStats.WicketsTaken, AwayTeamBowlingStats.EconomyRate
from Matches INNER JOIN AwayTeamBowlingStats ON Matches.MatchNo = AwayTeamBowlingStats.MatchNo;