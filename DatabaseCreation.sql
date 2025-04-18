-- Creating a database named CricketMatch that stores all the tables of our requirement.
create database CricketMatch;
use CricketMatch;

-- The 3NF form of the Player entity contains only one table, Player table. Creating a table named Player for that.
create table Player(
PlayerID numeric(10) PRIMARY KEY,
Name varchar(50) NOT NULL,
Age int unsigned NOT NULL,
Nationality varchar(50) NOT NULL,
TeamName varchar(50) NOT NULL DEFAULT '',
Role varchar(50) NOT NULL,
BattingAverage numeric(5,2) NOT NULL DEFAULT 000.00,
BattingStrikeRate numeric(5,2) NOT NULL DEFAULT 000.00,
BowlingAverage numeric(5,2) NOT NULL DEFAULT 000.00,
BowlingEconomy numeric(5,2) NOT NULL DEFAULT 000.00,
No_Of_Wickets int unsigned NOT NULL DEFAULT 0,
No_Of_100s int unsigned NOT NULL DEFAULT 0,
No_Of_50s int unsigned NOT NULL DEFAULT 0,
constraint chk_Role check (Role IN ('Batsman', 'Bowler', 'All-Rounder', 'Wicket-Keeper'))
);

-- The 3NF form of the Team entity contains only one table, Team Table. Creating a table named Team Table.
create table Team(
TeamName varchar(50) NOT NULL DEFAULT '' PRIMARY KEY,
Captain varchar(50) NOT NULL,
Coach varchar(50) NOT NULL,
No_Of_Wins int unsigned NOT NULL DEFAULT 0,
Home_Ground varchar(50) NOT NULL UNIQUE,
Most_Runs varchar(50) NOT NULL,
Most_Wickets varchar(50) NOT NULL
-- constraint fk_Captain FOREIGN KEY(Captain) references cricketmatch.Player(Name)
-- constraint fk_MostRuns check( Most_Runs in (select Name from Player where Player.TeamName = Team.TeamName)),
-- constraint fk_MostWickets check( Most_Wickets in (select Name from Player where Player.TeamName = Team.TeamName))
);

-- The 3NF form of the Match entity breaks down the original talble into two, where the first one contains all the attributes of the parent table except the Home Team Name.
-- Instead of creating a separate table for GroundNumber and HomeTeamName we can retrive the two from the Team table using the Foreign Key GroundLocation.
create table Matches(
MatchNo int unsigned NOT NULL PRIMARY KEY,
MatchDate date NOT NULL,
GroundLocation varchar(50) NOT NULL,
AwayTeamName varchar(50) NOT NULL,
MatchWinner varchar(50) NOT NULL,
ManOfTheMatch varchar(50) NOT NULL,
constraint fk_AwayTeamName FOREIGN KEY (AwayTeamName) references Team(TeamName),
constraint fk_GroundLocation FOREIGN KEY(GroundLocation) references Team(Home_Ground)
-- constraint ck_MatchWinner check(MatchWinner in ((select TeamName from Team where Team.Home_Ground = GroundLocation), AwayTeamName)),
-- constraint ck_ManOfTheMatch check(ManOfTheMatch in (select Name from Player where Player.TeamName in ((select TeamName from Team where Team.Home_Ground = GroundLocation), AwayTeamName)))
);

-- The match officials table remains as is upon conversion to 3NF.
create table MatchOfficials(
MatchNo int unsigned NOT NULL PRIMARY KEY,
MatchReferee varchar(50) NOT NULL,
MatchScorer varchar(50) NOT NULL,
CheifSecurityOfficer varchar(50) NOT NULL,
CheifGroundCurator varchar(50) NOT NULL,
Umpire1 varchar(50) NOT NULL,
Umpire2 varchar(50) NOT NULL,
Umpire3 varchar(50) NOT NULL,
constraint fk_MatchNo FOREIGN KEY (MatchNo) references Matches(MatchNo)
);

-- The Home Team and Away Team Bowling and Batting Stats tables break down into two in when converted in to 2NF form where the first table contains all the attributes except Name.
-- The second table contains the attributes PlayerID and Name which can be directly taken from the Player table.
create table HomeTeamBattingStats(
MatchNo int unsigned NOT NULL,
PlayerID int unsigned NOT NULL,
InAtPosition int unsigned NOT NULL,
RunsScored int unsigned,
StrikeRate numeric(5,2),
No_Of_4s int unsigned NOT NULL DEFAULT 0,
No_Of_6s int unsigned NOT NULL DEFAULT 0,
constraint pk_HomeTeamBattingStats PRIMARY KEY(MatchNo,PlayerID),
constraint fk_HomeTeamBSMatchNo FOREIGN KEY (MatchNo) references Matches(MatchNo),
-- constraint fk_PlayerID check (PlayerID in (select PlayerID from Player where Player.TeamName = (select TeamName from Team where Team.HomeGround = (select GroundLocation  from Matches where Matches.MatchNo = MatchNo)))),
 constraint ck_InAtPosition check (InAtPosition between 0 AND 12)
);

create table AwayTeamBattingStats(
MatchNo int unsigned NOT NULL,
PlayerID int unsigned NOT NULL,
InAtPosition int unsigned NOT NULL,
RunsScored int unsigned,
StrikeRate numeric(5,2),
No_Of_4s int unsigned NOT NULL DEFAULT 0,
No_Of_6s int unsigned NOT NULL DEFAULT 0,
constraint pk_AwayTeamBattingStats PRIMARY KEY(MatchNo,PlayerID),
constraint fk_AwayTeamBSMatchNo FOREIGN KEY (MatchNo) references Matches(MatchNo),
-- constraint fk_PlayerID check (PlayerID in (select PlayerID from Player where Player.TeamName = (select AwayTeamName from Matches where Matches.MatchNo = MatchNo))),
 constraint ck_AInAtPosition check (InAtPosition between 0 AND 12)
);

create table HomeTeamBowlingStats(
MatchNo int unsigned NOT NULL,
PlayerID int unsigned NOT NULL,
BowlingType varchar(50) NOT NULL,
OversBowled int unsigned,
WicketsTaken int unsigned,
EconomyRate numeric(5,2),
constraint pk_HomeTeamBowlingStats PRIMARY KEY(MatchNo,PlayerID),
constraint fk_HTBoSMatchNo FOREIGN KEY (MatchNo) references Matches(MatchNo),
-- constraint fk_PlayerID check (PlayerID in (select PlayerID from Player where Player.TeamName = (select TeamName from Team where Team.HomeGround = (select GroundLocation  from Matches where Matches.MatchNo = MatchNo)))),
constraint ck_BowlingType check (BowlingType in ('Spin','Pace'))
);
create table AwayTeamBowlingStats(
MatchNo int unsigned NOT NULL,
PlayerID int unsigned NOT NULL,
BowlingType varchar(50) NOT NULL,
OversBowled int unsigned,
WicketsTaken int unsigned,
EconomyRate numeric(5,2),
constraint pk_AwayTeamBowlingStats PRIMARY KEY(MatchNo,PlayerID),
constraint fk_ATBoSMatchNo FOREIGN KEY (MatchNo) references Matches(MatchNo),
-- constraint fk_PlayerID check (PlayerID in (select PlayerID from Player where Player.TeamName = (select AwayTeamName from Matches where Matches.MatchNo = MatchNo))),
constraint ck_ABowlingType check (BowlingType in ('Spin','Pace'))
);