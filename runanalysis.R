# You should create one R script called run_analysis.R that does the following. 
#
# 1. Merges the training and the test sets to create one data set.

# First step: Read test set
# Read test dataset
test<-read.table("UCI HAR Dataset/test/X_test.txt", header=F)

# add variable names (from features list)
features<-read.table("UCI HAR Dataset/features.txt", header=F)
names(test)<-features[,2]

# add 1st column: activity performed
activity<-readLines("UCI HAR Dataset/test/Y_test.txt")
activity<-as.numeric(activity) # convert character vector to numeric
test<-cbind(activity, test)

# add another 1st column: subject code
subject<-readLines("UCI HAR Dataset/test/subject_test.txt")
subject<-as.numeric(subject) # convert character vector to numeric
test<-cbind(subject, test)


# Second step: read training set
# Read training dataset
train<-read.table("UCI HAR Dataset/train/X_train.txt", header=F)

# add column names (from features list)
names(train)<-features[,2]

# add 1st column: activity performed
activity<-readLines("UCI HAR Dataset/train/Y_train.txt")
activity<-as.numeric(activity) # convert character vector to numeric
train<-cbind(activity, train)

# add another 1st column: subject code
subject<-readLines("UCI HAR Dataset/train/subject_train.txt")
subject<-as.numeric(subject) # convert character vector to numeric
train<-cbind(subject, train)


# Third step: Merge datasets
merged<-rbind(test, train)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# create vector of variable names for means and standard deviations: return all variable names which include either "mean" or "std"
mean.std<-grep("mean|std", names(merged), value=T)
# exclude values for mean frequency (labeled meanFreq()): return all names which DO NOT include "Freq" (through invert=T)
mean.std<-grep("Freq", mean.std, invert=T, value=T)

# extract corresponding columns from merged dataset
data<-merged[colnames(merged) %in% mean.std]

# add activity variable manually, with variable name "activity"
data<-cbind("activity"=merged$activity, data)

# add subject code variable manually, with variable name "subject"
data<-cbind("subject"=merged$subject, data)



# 3. Uses descriptive activity names to name the activities in the data set

# read activity labels from file "activity_labels.txt"
activities<-readLines("UCI HAR Dataset/activity_labels.txt")

# strip leading numbers and blanks
activities<-gsub("\\d ", "", activities)

# convert activity column to factor and add activity names from vector "activities" as level labels
data$activity<-factor(data$activity, labels=activities)


# 4. Appropriately labels the data set with descriptive variable names.

# I already named all variables in step 2 when reading in test and train data sets.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# create vector of variable names, used for later labeling
variable.names<-colnames(data) 


# split dataset by subject code
data$subject<-as.factor(data$subject)
data.by.subject<-split(data, data$subject)


# create empty matrix with one column per variable
data.means<-matrix(nrow=0, ncol=length(variable.names))

# calculate means per subject
for (i in 1:length(levels(data$subject))) {
  # extract the dataset for this subject
  data.subject<-data.by.subject[[i]]
  
  # split by activity
  data.act<-split(data.subject, data.subject$activity)
  
  # calculate means separately per activity
  for (j in 1:length(levels(data$activity))) {
    # extract dataset for this activity
    data.subject.activity<-data.act[[j]]
    
    # create a vector of means, with first value = subject code and second value = activity
    means<-c(i, j)
    
    # now calculate means for this activity
    for (h in 3:length(variable.names)) {
      # the first two variables are subject code and activity, which are not used for calculating the mean
      
      # calculate mean for each variable and add mean for this variable to means-vector
      x<-mean(data.subject.activity[,h])
      means<-append(means, x)
    }
    # add means vector for this subject & activity as row to data.means matrix
    data.means<-rbind(data.means, means)
    
  }
  
}

# add variable names as column names to matrix
dimnames(data.means)=list(1:nrow(data.means), variable.names)

# convert to dataframe
data.means<-as.data.frame(data.means)

# convert activity variable to factor and add labels (from the original dataset)
data.means$activity<-factor(data.means$activity, labels=levels(data$activity))

# write dataset to file named "means_tidy.txt"
write.table(data.means, file="UCI_means_tidy.txt", row.name=F)
