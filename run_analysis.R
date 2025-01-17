#Course Project

# features.txt contains 561 variable labels for columns
# X_test.txt contains 2947 obersvations of 561 variables
# Y_test.txt contains 2947 test labels corresponding to activity types
# subject_test.txt contains 2947 test subject identifier numbers
# X_train.txt contains 7352 observations of 561 variables
# Y_train.txt contains 7352 training labels corresponding to activity types
# subject_train.txt contains 7352 training subject identifier numbers


featfile <- "features.txt"
actlabels <- "activity_labels.txt"
testXfile <- "./test/X_test.txt"
testYfile <- "./test/Y_test.txt"
testSubfile <- "./test/subject_test.txt"
trainXfile <- "./train/X_train.txt"
trainYfile <- "./train/Y_train.txt"
trainSubfile <- "./train/subject_train.txt"

featnames <- read.table(featfile, header = FALSE)

#read test data files
testX = read.table(testXfile, header = FALSE, colClasses = "numeric", fill = TRUE)
testY <- read.table(testYfile, header = FALSE)
testSub <- read.table(testSubfile, header = FALSE)
#accX = read.table(testAccXfile, header = FALSE, colClasses = "numeric", fill = TRUE)

#add column names from features.txt
colnames(testX) <- featnames[,2]
testX[,"subject"] <- testSub
testX[,"activity"] <- testY

#repeat for training set
trainX = read.table(trainXfile, header = FALSE, colClasses = "numeric", fill = TRUE)
trainY <- read.table(trainYfile, header = FALSE)
trainSub <- read.table(trainSubfile, header = FALSE)
colnames(trainX) <- featnames[,2]
trainX[,"subject"] <- trainSub
trainX[,"activity"] <- trainY

#Merge datasets:
merged <- rbind.data.frame(testX,trainX)

#subset data frame to obtain mean() and std() columns
Mini <- merged[,grep("mean|std|subject|activity",colnames(merged) )]
#81 columns remain

#add activity descriptive labels to subset:
actnames <- read.table(actlabels, header = FALSE)
colnames(actnames) <- c("activity", "activity_description")
Mini <- merge(Mini, actnames, by = "activity")

#take means by subject and activity:
MiniMeans <- aggregate(Mini, by = list(Mini$activity,Mini$subject), mean)
names(MiniMeans)[names(MiniMeans)=="Group.1"] <- "activity_group"
names(MiniMeans)[names(MiniMeans)=="Group.2"] <- "subject_group"
ActMeans <- aggregate(Mini, by = list(Mini$activity), mean)
names(ActMeans)[names(ActMeans)=="Group.1"] <- "activity_group"

#output to .csv:
# merged has 10299 observations of 563 variables
write.table(merged, file = "tidydata.txt", row.names = FALSE) #because class specifies .txt file
write.csv(merged, file = "tidydata.csv")
# MiniMeans has 180 observations of 84 variables
write.csv(MiniMeans, file = "summary.csv")
# ActMeans has 6 observations of 83 variables- one row for each activity
write.csv(ActMeans, file = "activitysummary.csv")