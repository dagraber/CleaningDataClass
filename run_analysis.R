#Course Project

# X_test.txt contains 2947 obersvations of 561 variables
# Y_test.txt contains 2947 test labels corresponding to activity types
# features.txt contains 561 variable labels for columns
# subject_test.txt contains 2947 subject identifier numbers
# body_acc_x_test.txt containt 2947 observations of 128 variables

featfile <- "features.txt"
actlabels <- "activity_labels.txt"
testXfile <- "./test/X_test.txt"
testYfile <- "./test/Y_test.txt"
testSubfile <- "./test/subject_test.txt"
trainXfile <- "./train/X_train.txt"
trainYfile <- "./train/Y_train.txt"
trainSubfile <- "./train/subject_train.txt"

#testAccXfile <- "./test/Inertial Signals/body_acc_x_test.txt"
#testAccYfile <- "./test/Inertial Signals/body_acc_y_test.txt"
#testAccZfile <- "./test/Inertial Signals/body_acc_z_test.txt"
#testGyroXfile <- "./test/Inertial Signals/body_gyro_x_test.txt"
#testGyroYfile <- "./test/Inertial Signals/body_gyro_y_test.txt"
#testGyroZfile <- "./test/Inertial Signals/body_gyro_z_test.txt"
#testTotXfile <- "./test/Inertial Signals/total_acc_x_test.txt"
#testTotYfile <- "./test/Inertial Signals/total_acc_y_test.txt"
#testTotZfile <- "./test/Inertial Signals/total_acc_y_test.txt"

#flist <- list(testXfile,testYfile,testSubFile,testAccXfile,testAccYfile,testAccZfile,testGyroXfile,testGyroYfile, testGyroZfile, testTotXfile, testTotYfile, testTotZfile)

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

#add subject and activity columns to subset:
#testMini[,"subject"] <- testSub
#testMini[,"activity"] <- testY

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
write.csv(merged, file = "tidydata.csv")
# MiniMeans has 180 observations of 84 variables
write.csv(MiniMeans, file = "summary.csv")

write.csv(ActMeans, file = "activitysummary.csv")