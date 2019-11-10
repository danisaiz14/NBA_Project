# NBA Project Proposal

## Domain of interest

Sports are one of the best data providers to perform awesome analysis. Despite football (also named soccer in the USA) is the king sport in Spain, we think the sport which fits better for out project is basketball, because its usage of statistics in a standarized way and the huge ammount of different measures available.

Despite Spain won the last FIBA World Cup, some of our top players ([including the MVP](https://www.marca.com/en/more-sports/2019/09/15/5d7e56b346163f20308b4621.html)) are based in the best league in the world, the NBA.

The NBA is not only the best basketball league in the world, it also follows a public data policy which allows us to gather data related with almost any aspect of the league, from salaries to historical draft data. Moreover, the NBA regular season has 82 games per team which give us a total of 1230 games with at least 16 different players playing each match. Almost all the data related with the game itself is available via an open official API (the API is not documented anyways).


Because there's so many data available, we have chosen to focus our project on different NBA datasets for the **2018-2019 season**.

### Other data drive projects related with our domain

There are a lot of different projects related with the NBA perfomed by sports journalists, the NBA, tipsters (people who gives betting picks)...

We selected the following 3 projects:

- [Goodbye, Mid-Range Shot](https://flowingdata.com/2019/01/15/goodbye-mid-range-shot/): This project states how Golden State Warriors, commanded by Steve Kerr, shifted from Mid-Range shots to 3-pts shots and how all the league is moving with them.
- [Using Data Science to Predict the Next NBA MVP](https://towardsdatascience.com/using-data-science-to-predict-the-next-nba-mvp-30526e0443da): This project models the data more correlated with the MVP award given each year by over one hundred sports media members. For 2019 it failed and gave James Harden as the most probable pick for MVP award with 25.4% of chances, but also gave 24.0% to Giannis Antetokounmpo, the actual [winner of the 2019 MVP Award](https://www.nba.com/article/2019/04/12/kia-mvp-ladder-final-edition-2018-19-season?collection=mvp-ladder).
- [Using Machine Learning to Find the 8 Types of Players in the NBA](https://fastbreakdata.com/classifying-the-modern-nba-player-with-machine-learning-539da03bb824): This project uses machine learning to classify the NBA players on 8 different types and not the classic 5 ones, using [K-Means clustering](https://towardsdatascience.com/understanding-k-means-clustering-in-machine-learning-6a6e67336aa1).

Because there's so many data available, we have chosen to focus our project on different NBA datasets for the 2018-2019 season.

## Finding Data

### Salaries Dataset

This dataset contains information about the salaries of the players of each Team in the NBA.

It have been obtained from [Hoopshype.com](https://hoopshype.com/salaries/2018-2019/ "Hoopshype page for 2018 - 2019 salaries") and extracted using a web scraping [script](../master/utils/player_salary_scrapper.R) that recolects the data from the page of the salaries for the 2018-2019 season.

This dataset consists of two csv files. The first one, [salaries_team.csv](../master/data/salaries_team.csv), is a list of the teams of the NBA and the sum of their players' salaries. It has 30 rows and 4 columns (nameTeam, idTeam, slugTeam and salaries).

The second one, [salaries_player.csv](../master/data/salaries_player.csv), is a list of the players of all the teams of the NBA and his salaries. It has 621 rows and 3 columns (Player, Salary and Team).

What questions (from above) can be answered using the data in this dataset? TBD
