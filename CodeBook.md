# run_analysis.R Code Book
This markdown file provides details on the script: which variables were used and how they were calculated.

## Convention
Text represented like `this` denotes a part of the code in the script. (variable name or R command)  
Test represented like *this* denotes a column name  
Test represented like **this** denotes a file name
	

## I. Constant Variables
These are the variables that describe fixed values used in the script

  Variable Name | Value | Description
  --- | --- | --- 
  sourceUrl | https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip | URL where to download the data sources
  downloadFilename | Week4CourseProjectSources.zip | destination filename of the downloaded file source file
  outputFilename | Module 3 Tidy Dataset Output - Peer Graded.txt | destination filename of the output to be uploaded
  baseDir | UCI HAR Dataset | name of the base directory created when the zip file is extracted
  strSubjCol | SubjectNo | assigned as the column name of the single column in the source subject data set
  strLabelCol | Activity | assigned as the column name of the *name* column in the source activity data set
  strActCol | Value | assigned as the column name of the *value*  column in the source activity data set
  grepPattern | "(Activity) \| (SubjectNo) \| mean \\\\() \| std\\\\()" | pattern used to extract the mean and SD fields from the merged data set


## II. User-defined Variables
These are the variables generated and used within the script and saved in the R workspace. 

  Variable Name | Data Type | Data Stored
  --- | --- | --- 	
  measurements | factor | names of the measured features from the test and training sets
  test_Y | vector | activities performed on the test set	
  test_subj | vector | subject who did the activity in the test set
  test_X | data.frame | test set data from **UCI HAR Dataset/test/X_test.txt**	
  train_Y | vector | activities performed on the training set	
  train_subj | vector | subject who did the activity in the training set
  train_X | data.frame | training set data from **UCI HAR Dataset/train/X_train.txt**
  mergedTest | data.frame | column-bound `test_Y` , `test_subj` , and `test_X` ordered test set data
  mergedTrain | data.frame | column-bound `train_Y` , `train_subj` , and `train_X` ordered training set data
  mergedTestTrain | data.frame | row-bound `mergedTest` and `mergedTrain` data	
  mergedMeanSD | data.frame | mean and standard deviation columns of the merged test and training set features.  Created using the `grepPattern` pattern in the `grep()` command
  activityLabels | data.frame | activity reference table (see section III)
  longDataFormat | data.frame | merged test and training data set in long format
  tidyDataSet | data.frame | final output; stores the average of each variable for each activity and for each subject
	
	
## III. Reference table (for Activity)
Files:
- **UCI HAR Dataset/activity_labels.txt**
- **UCI HAR Dataset/test/y_test.txt**
- **UCI HAR Dataset/train/y_train.txt**
	
File | Assigned Column Name | Data Type | Description
--- | --- | --- | --- 
activity_labels.txt | Value | numeric | numeric equivalent of the activity name/label
activity_labels.txt | Activity | character | character equivalent of the activity number value
y_test.txt | Activity | numeric | activity performed in the test set; encoded in a numeric value
y_train.txt | Activity | numeric | activity performed in the training set; encoded in a numeric value



The following table serves as the activity reference table (`activityLabels` variable)  

Value | Activity
--- | ---
1 | WALKING
2 | WALKING_UPSTAIRS
3 | WALKING_DOWNSTAIRS
4 | SITTING
5 | STANDING
6 | LAYING
	

## IV. Data set columns
### 1. Source Subject Data
Files:
- **UCI HAR Dataset/test/subject_test.txt**
- **UCI HAR Dataset/train/subject_train.txt**

File | Assigned Column Name | Data Type | Description
--- | --- | --- | --- 
subject_test.txt | SubjectNo | numeric | identifies the subject who performed the test activity
subject_train.txt | SubjectNo | numeric | identifies the subject who performed the training activity

	
### 2. Source Feature Data
Files:
- **UCI HAR Dataset/features.txt** 
A vector that contains all the features present in the test and training sets.  This will be under the *Activity* column.
	
- **UCI HAR Dataset/test/X_test.txt**
Refer to the README and features_info files packaged with the data source for details
	
- **UCI HAR Dataset/train/X_train.txt**
Refer to the README and features_info files packaged with the data source for details
	
The features contain data from accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ.  The 't' means time, while 'f' means frequency.  The features are column-bound to the *SubjectNo* and *Activity* columns.   For this project, only the mean and standard deviation of the following fields are extracted:

Mean Features Column Name | Standard Deviation Features Column Name
--- | ---
tBodyAcc-mean()-XYZ | tBodyAcc-std()-XYZ
tGravityAcc-mean()-XYZ | tGravityAcc-std()-XYZ
tBodyAccJerk-mean()-XYZ | tBodyAccJerk-std()-XYZ
tBodyGyro-mean()-XYZ | tBodyGyro-std()-XYZ
tBodyGyroJerk-mean()-XYZ | tBodyGyroJerk-std()-XYZ
tBodyAccMag-mean() | tBodyAccMag-std()
tGravityAccMag-mean() | tGravityAccMag-std()
tBodyAccJerkMag-mean() | tBodyAccJerkMag-std()
tBodyGyroMag-mean() | tBodyGyroMag-std()
tBodyGyroJerkMag-mean() | tBodyGyroJerkMag-std()
fBodyAcc-mean()-XYZ | fBodyAcc-std()-XYZ
fBodyAccJerk-mean()-XYZ | fBodyAccJerk-std()-XYZ
fBodyGyro-mean()-XYZ | fBodyGyro-std()-XYZ
fBodyAccMag-mean() | fBodyAccMag-std()
fBodyAccJerkMag-mean() | fBodyAccJerkMag-std()
fBodyGyroMag-mean() | fBodyGyroMag-std()
fBodyGyroJerkMag-mean() | fBodyGyroJerkMag-std()

### 3. Output data set
This data set contains the columns from: 
- Source Subject Data; and
- Source Feature Data  

The only difference is that the column names of the features have "AVERAGES" as their suffix.  It is saved under the filename: **Module 3 Tidy Dataset Output - Peer Graded.txt**
			

## V. Data Transformations/Calculations 
This section provides the details on how the data was converted from one form to another.
		
### 1. Load the Packages
`dplyr` and `reshape2` are first loaded.  If missing, the script will download the missing packages and install them.  


### 2. Download the file
Using `download.file()`, the file will be downloaded in binary format to ensure proper file transfers, via the parameter `mode = wb` .  The filename is the one indicated in `downloadFilename` .  The file is downloaded only if it does not exist in the working directory.

### 3. Extract the data from the zip file
Extract the contents of the downloaded file using `unzip()` to the relative directory path from the working directory.  Extraction occurs only when the extract folder ( `baseDir`) dpes not contain the zip file. 

### 4. Building the header
Build the header names stored in **UCI HAR Dataset/features.txt** for the test and training sets. This will be stored in `measurements` 

### 5. Extract data from the source files
Use `read.table()` to get data from the test set files:
- **UCI HAR Dataset/test/subject_test.txt**
- **UCI HAR Dataset/test/y_test.txt**
- **UCI HAR Dataset/test/X_test.txt**
and assign to `test_subj` , `test_Y` , `test_X` , respectively.

Then extract source training set files:
- **UCI HAR Dataset/train/subject_train.txt**
- **UCI HAR Dataset/train/y_train.txt**
- **UCI HAR Dataset/train/X_train.txt**
and assign to `train_subj` , `train_Y` , `train_X` , respectively	
	
Because there are no headers in **UCI HAR Dataset/test/X_test.txt** and **UCI HAR Dataset/train/X_train.txt** , use the headers created in step 4 as the headers of `test_X` and `train_X` , instead.

#### 5.1 Build the test data set
Combine the 3 test set data by column, using `cbind()` in this format: `test_subj` , `test_Y` , `test_X` to produce `mergedTest`.

#### 5.2 Build the training data set
Combine the 3 training set data by column, using `cbind()` in this format: `train_subj` , `train_Y` , `train_X` to produce `mergedTrain`.

#### 5.3 Merge the test and training data sets
Combine `mergedTest` and `mergedTrain` data sets by row using `rbind()` and assign the merged test and training sets to `mergedTestTrain` .

### 6. Extract mean and standard deviation fields from the merged data set
Using `grep()` , search this pattern in the column value of `mergedTestTrain` data frame: `"(Activity)|(SubjectNo)|mean\\()|std\\()"`

The pattern will get the columns in `mergedTestTrain` that contain the substrings "mean()"  or "std()" , as well as the *Activity* and *SubjectNo* columns, which represent the activity name and subject number, respectively.  Assign this result to `mergedMeanSD`
 
### 7. Create a reference table for Activity data
Using `activityLabels` as a factor, replace the numeric values of the *Activity* column in the `mergedMeanSD` variable.
This is achieved using `factor()` and the following parameters:
- `levels` has the sorted unique values of the *Activity* column in the `mergedMeanSD`.  Possible values are 1 through 6.
- `labels` are the sorted `activityLabels` values (also 1 through 6) to match with `levels`.  This will replace the numeric values of the *Activity* column of `mergedMeanSD` with the character-equivalent label (e.g. 1 will be replaced by WALKING; 4 by SITTING)

### 8. Create a tidy data set with the average of each variable for each activity and each subject

#### 8.1 Build the merged data set in long data format
Convert `mergedMeanSD` to a long data format.  Assign *Activity* and *SubjectNo* as the ID variables that identify each row in `melt()`.  Store the result in `longDataFormat`.

####  8.2 Build the final data set
Compute for the average *value* of each *variable* using `dcast()` to `longDataFormat`.  Specify *Activity* and  *SubjectNo* as the ID variables, with *variable* as the measured variable, then use mean as the function to be applied.  This will result to the formula: `Activity + SubjectNo ~ variable,mean`  
Assign the tidy data set to `tidyDataSet`.
			
#### 8.3 Rename columns of the final data set
Append the string "averages" to the column name of each feature in `tidyDataSet`. This will denote that the values listed per row are averages of that feature of that activity and subject.

Lastly, change the header names to upper case to highlight the header against the observations.

### 9. Export the final data set as a physical file
Export the contents of `tidyDataSet` to text format using `write.table()`.  Include `row.names = FALSE, sep = ","` as arguments as required in the upload specifications of the course.  
The produced file will have a filename: **Module 3 Tidy Dataset Output - Peer Graded.txt** and is located in the current working directory of the user.
 
### 10. Clean workspace environment
To free up space, all created variables used in the script, save for `tidyDataSet`, will be deleted from the workspace.  This variable will remain in case additional transformations on it are needed.
		
If all variables need to be retained after execution, comment out `rm(list=ls()[-c(which(ls()=="tidyDataSet"))])` and re-run the script.

EOF
