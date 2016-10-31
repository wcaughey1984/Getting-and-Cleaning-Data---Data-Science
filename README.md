README for Getting and Cleaning Data final project.
==================================================================

## Description of Code
The code 'run_analysis' is meant to do the following:

1. Merge training and the test sets to create one data set.                    
2. Extracts only measurements on the mean and standard deviation for each measurement.                                                   
3. Uses descriptive activity names to name the activities in the data set.     
4. Appropriately lables the data set with descriptive variables names.         
5. From the data in part 4, creates a second, indepdent tidy data set with the average of each variable for each activity and each subject. 

## How the code works
To begin, please set the working directory to the directory you will be working out of.  

Data from [UCI] (https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) is downloaded via [zipfile] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  The data is unzipped and ready for use.

Next, the labels and features of fields are broght in.  Appropriate cleaning methods are made to make the labels and fields 'tidy'.  

The training and test data are then brought in.  Thee labels and features of fields are applied after the training and test sets are merged.  

Finally, the means of each field, by subject and activity, are taken.  This final data set is exported.

