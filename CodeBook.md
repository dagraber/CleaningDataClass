---
title: "CodeBook.md"
author: "David Graber"
date: "June 19, 2016"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown
R code follows:
```{r , results='asis', echo=FALSE}
featfile <- "features.txt"
actlabels <- "activity_labels.txt"
testXfile <- "./test/X_test.txt"
testYfile <- "./test/Y_test.txt"
testSubfile <- "./test/subject_test.txt"
trainXfile <- "./train/X_train.txt"
trainYfile <- "./train/Y_train.txt"
trainSubfile <- "./train/subject_train.txt"

featnames <- read.table(featfile, header = FALSE)

testX = read.table(testXfile, header = FALSE, colClasses = "numeric", fill = TRUE)
testY <- read.table(testYfile, header = FALSE)
testSub <- read.table(testSubfile, header = FALSE)

colnames(testX) <- featnames[,2]
testX[,"subject"] <- testSub
testX[,"activity"] <- testY

trainX = read.table(trainXfile, header = FALSE, colClasses = "numeric", fill = TRUE)
trainY <- read.table(trainYfile, header = FALSE)
trainSub <- read.table(trainSubfile, header = FALSE)
colnames(trainX) <- featnames[,2]
trainX[,"subject"] <- trainSub
trainX[,"activity"] <- trainY

merged <- rbind.data.frame(testX,trainX)

Mini <- merged[,grep("mean|std|subject|activity",colnames(merged) )]

actnames <- read.table(actlabels, header = FALSE)
colnames(actnames) <- c("activity", "activity_description")
Mini <- merge(Mini, actnames, by = "activity")

MiniMeans <- aggregate(Mini, by = list(Mini$activity,Mini$subject), mean)
names(MiniMeans)[names(MiniMeans)=="Group.1"] <- "activity_group"
names(MiniMeans)[names(MiniMeans)=="Group.2"] <- "subject_group"
ActMeans <- aggregate(Mini, by = list(Mini$activity), mean)
names(ActMeans)[names(ActMeans)=="Group.1"] <- "activity_group"

write.csv(merged, file = "tidydata.csv")
write.csv(MiniMeans, file = "summary.csv")
write.csv(ActMeans, file = "activitysummary.csv")
```
Summary of input files:
features.txt contains 561 variable labels for columns
X_test.txt contains 2947 obersvations of 561 variables, no labels
Y_test.txt contains 2947 test labels corresponding to activity types
subject_test.txt contains 2947 test subject identifier numbers
X_train.txt contains 7352 observations of 561 variables, no labels
Y_train.txt contains 7352 training labels corresponding to activity types
subject_train.txt contains 7352 training subject identifier numbers


Summary of code operation:
The script run_analysis.R should be in the same folder as the data due to the use of relative paths.
All the text files from the townloaded dataset are loaded with the read.table() function.
features.txt provides column labels for the data in "X_test.txt" and "X_train.txt".
Y_test.txt and Y_train.txt contain the subject numbers and are added as a new column to identify rows.
Once the test and training datasets have labels, they are added together using rbind().
Mean and Standard Deviation numbers are extracted by subsetting into a new data frame.
The aggregate() function generates mean values grouped by subject and activity. A second instance of aggregate() generated mean values by activity alone.


Summary of outputs:
merged has 10299 observations of 563 variables
merged outputs to "tidydata.csv" with the complete, cleaned dataset

MiniMeans has 180 observations of 84 variables
MiniMeans outputs to "summary.csv" with mean values by subject and activity type

ActMeans has 6 observations of 83 variables- one row for each activity
ActMeans outputs to "activitysummary.csv" with mean values by activity type
