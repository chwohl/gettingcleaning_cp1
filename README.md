# gettingcleaning_cp1
Course project 1 for the course Getting and Cleaning Data

## Dataset description
The file "UCI_means_tidy" contains a dataset created from data obtained from 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip through the code documented in run_analysis.R

The following steps have been performed to obtain the dataset "UCI_tidy" from the orignal data:
1. The training and the test sets have been read in separately, with descriptive  variable names added.
2. The two data sets have been merged to create one data set.
3. Only the measurements on the mean and standard deviation for each measurement have been extracted. 
4. Descriptive activity names to name the activities in the data set have been introduced.

The following steps have been performed to obtain the dataset "UCI_means_tidy" from the dataset "UCI_tidy"
1. The average of each variable for each activity and each subject has been calculated separately.
2. A new dataframe has been created with the data obtained in step 1, with descriptive labels for variables and activities.

See the file "run_analysis.R" for how the dataset was obtained from the original data.

See the codebook for description of the variables. The dataset contains the mean for all measurements per subject per activity.
