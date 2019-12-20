library(tidyverse)
library(rvest)

urls <- c("http://hoopshype.com/salaries/atlanta_hawks/2018-2019/",
          "http://hoopshype.com/salaries/boston_celtics/2018-2019/",
          "http://hoopshype.com/salaries/brooklyn_nets/2018-2019/",
          "http://hoopshype.com/salaries/charlotte_hornets/2018-2019/",
          "http://hoopshype.com/salaries/chicago_bulls/2018-2019/",
          "http://hoopshype.com/salaries/cleveland_cavaliers/2018-2019/",
          "http://hoopshype.com/salaries/dallas_mavericks/2018-2019/",
          "http://hoopshype.com/salaries/denver_nuggets/2018-2019/",
          "http://hoopshype.com/salaries/detroit_pistons/2018-2019/",
          "http://hoopshype.com/salaries/golden_state_warriors/2018-2019/",
          "http://hoopshype.com/salaries/houston_rockets/2018-2019/",
          "http://hoopshype.com/salaries/indiana_pacers/2018-2019/",
          "http://hoopshype.com/salaries/los_angeles_clippers/2018-2019/",
          "http://hoopshype.com/salaries/los_angeles_lakers/2018-2019/",
          "http://hoopshype.com/salaries/memphis_grizzlies/2018-2019/",
          "http://hoopshype.com/salaries/miami_heat/2018-2019/",
          "http://hoopshype.com/salaries/milwaukee_bucks/2018-2019/",
          "http://hoopshype.com/salaries/minnesota_timberwolves/2018-2019/",
          "http://hoopshype.com/salaries/new_orleans_pelicans/2018-2019/",
          "http://hoopshype.com/salaries/new_york_knicks/2018-2019/",
          "http://hoopshype.com/salaries/oklahoma_city_thunder/2018-2019/",
          "http://hoopshype.com/salaries/orlando_magic/2018-2019/",
          "http://hoopshype.com/salaries/philadelphia_76ers/2018-2019/",
          "http://hoopshype.com/salaries/phoenix_suns/2018-2019/",
          "http://hoopshype.com/salaries/portland_trail_blazers/2018-2019/",
          "http://hoopshype.com/salaries/sacramento_kings/2018-2019/",
          "http://hoopshype.com/salaries/san_antonio_spurs/2018-2019/",
          "http://hoopshype.com/salaries/toronto_raptors/2018-2019/",
          "http://hoopshype.com/salaries/utah_jazz/2018-2019/",
          "http://hoopshype.com/salaries/washington_wizards/2018-2019/")

getTeamSalaries <- function(url) {
  html <- read_html(url)
  team_name <- html %>% html_nodes("#content-container > div > div.payroll-team > div.salaries-team-selector-top > ul:nth-child(1) > li > a") %>% html_text() %>% str_replace_all("[\n\t]","")
  htmlTable <- html %>% html_nodes("table")
  html_table(htmlTable[[1]], header = F) %>% select(X1,X2) %>% rename("Player" = X1, "Salary" = X2) %>% mutate(Team = team_name, Salary = as.numeric(str_replace_all(Salary, "[,$]",""))) %>% filter(!is.na(Salary), Player != "Totals")
}

getPlayerSalaries <- function() {
  print('Retrieving the players salary for season 2018-2019')
  final_dataframe <- data.frame()
  for (teamUrl in urls) {
    aux_dataframe <- data.frame(getTeamSalaries(teamUrl))
    final_dataframe <- rbind(final_dataframe, aux_dataframe)
  }
  final_dataframe
}
