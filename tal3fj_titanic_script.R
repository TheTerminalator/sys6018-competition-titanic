#Tyler Lewris
#SYS 6018 Data Mining
#August 23rd 2017
#tal3fj@virginia.edu

#reading in files
titanic_train_df <- read.csv("train.csv", header=TRUE)
titanic_test_df <- read.csv("test.csv", header=TRUE)

#Lets make sure R knows which columns are factors vs numeric
titanic_train_df[,c(4,5,9,11,12)] = lapply(titanic_train_df[c(4,5,9,11,12)],factor)
titanic_test_df[,c(3,4,8,10,11)] = lapply(titanic_test_df[c(3,4,8,10,11)],factor)

#Take a look at gender 
table(titanic_train_df$Sex)
#look at females who survived
females_who_survived <- titanic_train_df[titanic_train_df$Sex == "female" & titanic_train_df$Survived == 1,]
nrow(females_who_survived)/sum(titanic_train_df$Sex == "female")
#74% of females survived. Definitely a good start.

#Take a look at age, see if the "save the women and children first" holds true
summary(titanic_train_df$Age)
#We have missing values
#Filling in missing values for Age with the mean of the age values available for both test and train data sets
titanic_train_df$Age[is.na(titanic_train_df$Age)] = mean(titanic_train_df$Age, na.rm = TRUE)
titanic_test_df$Age[is.na(titanic_test_df$Age)] = mean(titanic_test_df$Age, na.rm = TRUE)

#I'm going to use under 13 as a baseline for the age of a child
children_who_survived <- titanic_train_df[titanic_train_df$Age < 13 & titanic_train_df$Survived == 1,]
nrow(children_who_survived)/sum(titanic_train_df$Age < 13)
#58% of children survived. 
#Lets combine gender and age and write to a csv

#Creating a new column labeled "Survived" and setting everyone equal to 0 unless a female or a child
titanic_test_df$Survived <- ifelse(titanic_test_df$Sex == "female", 1, 0)
titanic_test_df$Survived <- ifelse(titanic_test_df$Age < 13, 1, titanic_test_df$Survived)

#Write to csv with specified column names so Kaggle does not reject the submission
gender_and_age <- data.frame(PassengerId = titanic_test_df$PassengerId, Survived = titanic_test_df$Survived)
write.csv(gender_and_age, file = "tal3fj.csv", row.names = FALSE)