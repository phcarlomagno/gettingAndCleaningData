################################################################################
# Filename : run_analysis.R
# Author   : Carlomagno Anastacio
# Date     : 2018/1/11
# Version  : 1.0 
# Remarks  : Initial version of file
################################################################################

### Load needed packages
if(length(which(installed.packages()=="dplyr"))==0){
    install.packages("dplyr")
}
library(dplyr)

if(length(which(installed.packages()=="reshape2"))==0){
    install.packages("reshape2")
}
library(reshape2)


### Define string constants
downloadFilename <- "Week4CourseProjectSources.zip"
outputFilename <- "Module 3 Tidy Dataset Output - Peer Graded.txt"
baseDir <- "UCI HAR Dataset"                         
strSubjCol <- "SubjectNo"                            
strLabelCol <- "Activity"                               
strActCol <- "Value"
sourceUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


### Download the file if it does not exist in the working directory 
if(!file.exists(downloadFilename)){                           
    download.file(sourceUrl,downloadFilename, mode ="wb")
}


### Extract the contents of the downloaded file if it does not exist 
if(!file.exists(baseDir)){
    unzip(downloadFilename)
}


### Read the feature data from the unzipped files to assign the column names ###
measurements <- read.table("./UCI HAR Dataset/features.txt")
measurements <- measurements[,2]                #get the column with name values


### Read the test set data from the unzipped files (Y,Subject,X) and set the 
### proper column names                                                                 
test_Y <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(test_Y) <- strLabelCol

test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(test_subj) <- strSubjCol

test_X <- read.table("./UCI HAR Dataset/test/X_test.txt")
names(test_X) <- measurements                        


### Read the training set data from the unzipped files (Y,Subject,X) and set the 
### column names                                                                 
train_Y <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(train_Y) <- strLabelCol

train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(train_subj) <- strSubjCol

train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")
names(train_X) <- measurements


################################################################################
# Obective 1: Merge the test and training  sets to create one data set.
# Note      : Include subject, Y, and X values, in order.  [Name, Label,Value]
################################################################################
mergedTest <- cbind(test_Y,test_subj,test_X)
mergedTrain <- cbind(train_Y,train_subj,train_X)

mergedTestTrain <- rbind(mergedTest,mergedTrain)



################################################################################
# Objective 2: Extract only the measurements on the mean and standard deviation
#              for each measurement.
# Note       : Retain fields that contain "mean()" and "std()" in their name
################################################################################
grepPattern <- paste0("(",strLabelCol,")","|","(",strSubjCol,")",
                      "|","mean\\()|std\\()")
mergedMeanSD <- (mergedTestTrain[,grep(grepPattern,names(mergedTestTrain))])



################################################################################
# Objective 3: Use descriptive activity names to name the activities in the 
#              data set
# Note       : Create a reference table [integer value : activity name]
################################################################################
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activityLabels) <- c(strActCol,strLabelCol)#rename columns for readability



################################################################################
# Objective 4: Appropriately label the data set with descriptive variable names
# Note       : Replace the numeric value with activity names
################################################################################
mergedMeanSD$Activity <- factor(mergedMeanSD$Activity, 
                                levels = sort(unique(mergedMeanSD$Activity)),
                                labels = activityLabels[,strLabelCol])



################################################################################
# Objective 5: From the data set in step 4, create a second, independent tidy 
#              data set with the average of each variable for each activity and 
#              each subject.
# Note       : Create a file to be submitted, containing the requirements stated
################################################################################
longDataFormat <- melt(mergedMeanSD, id.vars = c(strLabelCol,strSubjCol))
tidyDataSet <- dcast(longDataFormat, Activity + SubjectNo ~ variable,mean)


### Create file for submission
names(tidyDataSet)[-c(1:2)] <- paste0(names(tidyDataSet[-c(1:2)]), " Averages")
names(tidyDataSet) <- toupper(names(tidyDataSet))
write.table(tidyDataSet,outputFilename,sep = ",",row.names = FALSE)

### Clean up used variables, except for the final, tidy dataset
rm(list=ls()[-c(which(ls()=="tidyDataSet"))])

#EOF