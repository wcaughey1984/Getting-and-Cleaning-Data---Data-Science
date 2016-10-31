#################################################################################################
# Title:    run_analysis                                                                        #
# Purpose:  Final project code for 'Getting and Cleaning Data'.  This code is meant to do the   #
#           following:                                                                          #
#               1 - Merge training and the test sets to create one data set.                    #
#               2 - Extracts only measurements on the mean and standard deviation for each      #
#                   measurement.                                                                #
#               3 - Uses descriptive activity names to name the activities in the data set.     #
#               4 - Appropriately lables the data set with descriptive variables names.         #
#               5 - From the data in part 4, creates a second, indepdent tidy data set with the #
#                   average of each variable for each activity and each subject.                #
# Author:   Billy Caughey                                                                       #
# Date:     2016.10.26 - Initial Build                                                          #
#           2016.10.27 - 'method = curl' acting up, need a different solution                   #
#           2016.10.28 - error in unzip command - what is going on?                             #
#           2016.10.29 - playing around with different ways to label variable fields            #
#           2016.10.30 - FINAL                                                                  #
#################################################################################################

##### Set Working directory #####
setwd(paste(personal,"/Coursera/Getting and Cleaning Data/Final Project/Data",sep=""))

##### local vars #####
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "ucidata.zip"

##### Download file #####
if(!file.exists(filename)){
    download.file(fileURL, filename)
}
if(!file.exists("UCI HAR Dataset")){
    unzip(filename)
}

##### Bring in labels and features #####
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
features <- read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)

##### Keep only features that correspond to mean and standard deviations ####

# Identify which labels are in reference to the mean and the standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])

# Keep only the labels that are in reference to the mean and standard deviation
featuresWanted.names <- features[featuresWanted,2]

# Clean up labels
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'StDev', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

##### Bring in training and test data sets #####

# Training set
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

# Test set
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

##### Merge data set #####
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

# convert subject and activity to factor type
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

# Convert from wide format to long format
allData.melted <- melt(allData, id = c("subject", "activity"))

# Find average on subject + activity combination for all variables
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

##### Export Final Data #####
write.table(allData.mean, "tidy_mean.txt", row.names = FALSE, quote = FALSE)
