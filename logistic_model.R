library(knitr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(devtools)
library(rvest)
library(patchwork)
library(Hmisc)
library(mlbench)

library(caret)
set.seed(2403)

salaries_players <- read.csv('data/salaries_player.csv', stringsAsFactors = F) %>%
  group_by(Player) %>%
  summarise(Salary = as.integer(mean(Salary)))
salaries_teams <- read.csv('data/salaries_team.csv', stringsAsFactors = F)
info_players <- read.csv('data/players.csv', stringsAsFactors = F)
stats_players <- read.csv('data/logs_players.csv', stringsAsFactors = F)

totalSalary <- sum(salaries_teams$salaries)

salaries_joined <- salaries_players %>%
  left_join(select(info_players, namePlayer, idTeam),
            by = c('Player' = 'namePlayer')) %>%
  filter(!is.na(idTeam)) %>%
  left_join(select(salaries_teams, -nameTeam) %>%
              rename(TeamSalary = salaries),
            by = 'idTeam') %>%
  mutate(pctSalaryTeam = Salary / TeamSalary,
         pctSalaryTotal = Salary / totalSalary)

stats_aggr <- stats_players %>%
  group_by(namePlayer) %>%
  summarize(winrate = mean(isWin == TRUE),
            minutes = mean(minutes, na.rm=TRUE),
            pts = mean(pts, na.rm=TRUE),
            ast = mean(ast, na.rm=TRUE),
            plusminus = mean(plusminus, na.rm=TRUE),
            blk = mean(blk, na.rm=TRUE),
            stl = mean(stl, na.rm=TRUE),
            pctFG3 = mean(pctFG3, na.rm=TRUE),
            tov = mean(tov, na.rm=TRUE),
            pctFG = mean(pctFG, na.rm=TRUE),
            oreb = mean(oreb, na.rm=TRUE),
            dreb = mean(dreb, na.rm=TRUE),
            pf = mean(pf, na.rm=TRUE),
            treb = mean(treb, na.rm=TRUE),
            fg2m = mean(fg2m, na.rm=TRUE),
            fg2a = mean(fg2a, na.rm=TRUE),
            fga = mean(fga, na.rm=TRUE),
            fgm = mean(fgm, na.rm=TRUE),
            ftm = mean(ftm, na.rm=TRUE))%>%
  ungroup()

merged_player_tables <- info_players %>%
  filter(yearSeasonFirst < 2019) %>%
  left_join(salaries_joined, by = c('namePlayer' = 'Player')) %>%
  select(namePlayer, countSeasons, Salary, TeamSalary, pctSalaryTeam, pctSalaryTotal) %>%
  filter(!is.na(Salary))

player_seasons <- info_players %>% select(namePlayer, countSeasons)

ggplot(merged_player_tables, aes(x = countSeasons, y = sqrt(Salary))) +
  geom_point() +
  stat_summary(aes(y = sqrt(Salary), group = 1), fun.y = mean, colour = 'red', geom = 'line', group = 1)

reduced_aggr_data <- stats_aggr %>%
  left_join(select(salaries_joined,
                   -idTeam,
                   slugTeam), by = c('namePlayer' = 'Player')) %>%
  left_join(player_seasons) %>%
  filter(!is.na(countSeasons), pctFG != 'NaN') %>%
  select(-slugTeam)


#explain why removed
pre_ml_data <- reduced_aggr_data %>%
  select(-namePlayer, -TeamSalary, -pctSalaryTeam, -Salary)

#---------------------------------------------------
#Correlation tests
#---------------------------------------------------

res2 <- rcorr(as.matrix(pre_ml_data))
res2
res2$r

cor_matrix <- cor(pre_ml_data, method = "pearson")[20,] %>% sort(T)
cor_matrix

#correlation between attributes
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

#data without the class salaries
pre_ml_data_noclass <- pre_ml_data[,-20]

res2<-rcorr(as.matrix(pre_ml_data_noclass[,1:20]))
corrmatr <-flattenCorrMatrix(res2$r, res2$P)
corrmatr %>% as.data.frame() %>% arrange(desc(cor))


correlationMatrix <- cor(pre_ml_data[,1:21])
print(correlationMatrix)

# find attributes that are highly correlated
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.95)
# print indexes of highly correlated attributes
print(highlyCorrelated)
#name of variables
highcorvars <- pre_ml_data[0, highlyCorrelated]

#analysis of variance
dd <- data.frame(pre_ml_data)
aov(winrate~ast,dd)


#---------------------------------------------------
#First model
#---------------------------------------------------


fitControl <- trainControl(
  method = "repeatedcv", # Cross validation
  number = 10,    # 10 fold
  repeats = 3
)

tune_grid <- expand.grid(.mtry = c(2,6,10))

trainIndex <- createDataPartition(ml_data$pctSalaryTotal, p = .80, list = FALSE, times = 1)

training_set <- ml_data[ trainIndex, ]
test_set <- ml_data[ -trainIndex, ]

model_fit <- train(pctSalaryTotal ~ .,
                   data = ml_data,
                   method = "parRF", # Parallel Random Forest
                   trControl = fitControl,
                   tuneGrid = tune_grid,
                   na.action = na.exclude)
model_preds <- predict(model_fit, test_set)

test_predicted <- test_set %>% mutate(predictions = model_preds) %>% select(pctSalaryTotal, predictions)

mae_value <- MAE(model_preds, test_set$pctSalaryTotal)

mae_salary <- mae_value * totalSalary


#---------------------------------------------------
#Second model
#---------------------------------------------------

#measure important attributes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
model <- train(pctSalaryTotal~., data=pre_ml_data, method="parRF", preProcess="scale", trControl=control, importance=T)
importance <- varImp(model, scale=FALSE)
print(importance)
ggplot(importance)

pre_ml_data_noclass<- pre_ml_data[,-20]


#variables vs. RMSE
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
results <- rfe(pre_ml_data_noclass, as.matrix(pre_ml_data[,20]), sizes=c(1:20), rfeControl=control)
print(results)
predictors(results)
ggplot(results, type=c("g", "o"))


#second model with the 3 chosen attributes

ml_data2 <- pre_ml_data %>%
  select(countSeasons, minutes, tov, pctSalaryTotal)

fitControl <- trainControl(
  method = "repeatedcv", # Cross validation
  number = 10,    # 10 fold
  repeats = 3
)

tune_grid <- expand.grid(.mtry = c(2,6,10))

trainIndex <- createDataPartition(ml_data2$pctSalaryTotal, p = .80, list = FALSE, times = 1)

training_set <- ml_data2[ trainIndex, ]
test_set <- ml_data2[ -trainIndex, ]

model_fit <- train(pctSalaryTotal ~ .,
                   data = ml_data2,
                   method = "parRF", # Parallel Random Forest
                   trControl = fitControl,
                   tuneGrid = tune_grid,
                   na.action = na.exclude)
model_preds <- predict(model_fit, test_set)

test_predicted <- test_set %>% mutate(predictions = model_preds) %>% select(pctSalaryTotal, predictions)

mae_value <- MAE(model_preds, test_set$pctSalaryTotal)

mae_salary <- mae_value * totalSalary

