# Coursera Project Contents

As part of the course requirements of the Getting and Cleaning Data module, students are required to make a project that will exhibit skills on:
collecting, working with, and cleaning a data set.  For this course, a script written in R is needed to accomplish set objectives.

## Script objectives
The script will take the source file, and perform the following:
1. Merge the training and the test sets to create one data set.
2. Extract only the measurements on the mean and standard deviation for each 
   measurement.
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names.
5. From the data set in step 4, create a second, independent tidy data set 
   with the average of each variable *for each activity and each subject*.

## Project Files
The following files are relevant to this project.  These files can be found inside the same git repository:

Filename | Description
 --- | --- 
run_analysis.R | main script file
CodeBook.md | describes all variables and computations made inside the run_analysis.R file
README.md | this file

## Script Prerequisites
The `dplyr` and `reshape2` R packages are needed for this script to run

## Software Version
This script was made under: *R version 3.4.2 (2017-09-28)* running on Windows 7 OS.
It is recommended that a similar R version and OS platform would be used to run the script.

## Data Source
The data source can be downloaded from : `https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip`
It has its own  README file for details on the data.

## Script Methodology
Please refer to the CodeBook.md for details

## Running the script
1. Open the run_analysis.R file in R Studio or RGui
2. Run the code in R Studio (CTRL+ALT+R in Windows and Linux and Command+Option+R for Mac) or RGui (Edit > Run all)

## File Output 
- The results of the script would be physically saved in the current working directory, under the filename: **Module 3 Tidy Dataset Output - Peer Graded.txt**.  This was included in the code to easily generate the file to be uploaded upon execution of the script
- The file is in a comma-separated text file for readability
- The file headers are arranged, from left to right,  as: "ACTIVITY", "SUBJECTNO", then followed by each relevant feature
- The file headers are arranged as such to conform with the criteria: *From the data set in step 4, creates a second, independent tidy data set with the average of each variable* **for each activity and each subject**.

## Troubleshooting and other notes
- There are instances where `install.packages()` will cause R to stop responding.  If this is the case, install the required packages outside of the script
- UCI HAR Dataset/test/X_test.txt and UCI HAR Dataset/train/X_train.txt are large data sets, so depending on the current state of the computer, it may take some time to process.  Please have patience.

EOF
