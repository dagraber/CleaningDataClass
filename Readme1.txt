Readme:

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