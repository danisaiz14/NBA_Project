# NBA Project Proposal

## Domain of interest

Sports are one of the best data providers to perform awesome analysis. Despite football (also named soccer in the USA) is the king sport in Spain, we think the sport which fits better for out project is basketball, because its usage of statistics in a standarized way and the huge ammount of different measures available.

Despite Spain won the last FIBA World Cup, all our top players are based in the best league in the world, the NBA. The NBA is not only the best league with the best players but also the organization with more open official data provided via an API (the API is not documented anyways).

The NBA is not only the best basketball league in the world, it also follows a public data policy which allows us to gather data related with almost any aspect of the league, from salaries to historical draft data. Moreover, the NBA regular season has 82 games per team which give us a total of 1230 games with at least 16 different players playing each match.

Because there's so many data available, we have chosen to focus our project on different NBA datasets for the 2018-2019 season.

## Finding Data

### Salaries Dataset

This dataset contains information about the salaries of the players of each Team in the NBA.

It have been obtained from [Hoopshype.com](https://hoopshype.com/salaries/2018-2019/ "Hoopshype page for 2018 - 2019 salaries") and extracted using a web scraping [script](../master/utils/player_salary_scrapper.R) that recolects the data from the page of the salaries for the 2018-2019 season.

This dataset consists of two csv files. The first one, [salaries_team.csv](../master/data/salaries_team.csv), is a list of the teams of the NBA and the sum of their players' salaries. It has 30 rows and 4 columns (nameTeam, idTeam, slugTeam and salaries).

The second one, [salaries_player.csv](../master/data/salaries_player.csv), is a list of the players of all the teams of the NBA and his salaries. It has 621 rows and 3 columns (Player, Salary and Team).


What questions (from above) can be answered using the data in this dataset? TBD
