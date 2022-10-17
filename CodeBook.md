# __Week4: Getting and Cleaning Data Course Project__

***

* ###  _**The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.**_

## __The data for the project:__
### https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

***

> ## __R script called "run_analysis.R" that does the following instructions.__

### _1. Merges the training and the test sets to create one data set._
### _2. Extracts only the measurements on the mean and standard deviation for each measurement._ 
### _3. Uses descriptive activity names to name the activities in the data set._
### _4. Appropriately labels the data set with descriptive variable names._ 
### _5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject._

***

> ## __Download zip file from web and unzip it to the destination folder.__

### 3 variables below are used as a global variables. (used "<<-" operator)
* ### __relative_path__: it is used to save "relative path".
* ### __features__: it is used to process "features.txt".
* ### __activity_labels__: it is used to process "activity_labels.txt".

***

> ## __User Defined Functions__

## __*1. changeFeatureName():*__
### __Description__
* ###  It is used to change“feature names” which will be used to column names of X train/test data set.
    
### __Usage__
* ###   changeFeatureName(features_names)
    
### __Argument__
* ###    features_names  
    
### __return__
* ###   features_names 
    
### __Details__
* ### _[Basic Rule]_
* ### Used original feature names described "features_info.txt" file as much as possible.
    + ### (for example: 't': time domain, 'f': frequency domain)
* ### Used the function name of "features.txt" as an argument and remove or replace the special character(",", "(",")").
* ### Replace hyphen('-') to underscore('_').

***
    
## __*2. readDataSet():*__
### __Description__
* ### This is used to read txt files of train and test data set (except files in "Inertial Signals" folder).

### __Usage__
* ### readDataSet(dataList, category='train')

### __Argument__
* ### __dataList__
    + ### This is a list variable which contains all variables to save train or test data set.
    + ### (for example, train = list(subject_train=NULL, X_train=NULL, y_train=NULL)
* ### __category__
    + ### Character. “train”value is to read train data set. “test”value is to read the test data set.

### __return__
* ### dataList

### __Details__
* ### Read "txt" files in "train" or "test" folder.
* ### dataList as an argument contains 3 variables, (subject_train, X_train, y_train) for train / (subject_test, X_test, y_test) for test and save the contents of the files.
* ### If category is "train", read "subject_train.txt", "X_train.txt", and "y_train.txt".
* ### If category is "test", read "subject_test.txt", "X_test.txt", and "y_test.txt".

***

> ## __Call readDataSet() to read train/test data set__

### __1. Read "train" data set__
* ### __train__ is a list variable which contains list(subject_train=NULL, X_train=NULL, y_train=NULL) and is used to save "train" data set.

    + ### __train = readDataSet(train, 'train')__

### __2. Read "test" data set__
* ### __test__ is a list variable which contains list(subject_test=NULL, X_test=NULL, y_test=NULL) and is used to save "test" data set.

    + ### __test = readDataSet(test, 'test')__

***

> ## __1. Merges the training and the test sets to create one data set.__

* ### __[train data set]__
    + ### __subject_train__ and __y_train__ has 7352 rows and 1 column.
    + ### __X_train__ has 7352 rows and 561 columns.
    
* ### __[test data set]__
    + ### __subject_test__ and __y_test__ has 2947 rows and 1 column.
    + ### __X_test__ has 2947 rows and 561 columns.

* ### __rbind()__ is used _to merge "train" and "test" data set._
    + ### __subject__ variable is used to merge subject_train and subject_test ( __subject__ has _10299 rows and 1 column_).
    + ### __X__ variable is used to merge X_train and X_test ( __X__ has _10299 rows and 561 columns_).
    + ### __y__ variable is used to merge y_train and y_test.
    
* ### __[merged data]__
    + ### __UCIHAR__ is a _merged data set_ of __subject, X, and y__ using cbind() ( __UCIHAR__ has _10299 rows and 563 columns_).
    
*** 

> ## __2. Extracts only the measurements on the mean and standard deviation for each measurement.__

* ### Used select() and matches() to extract subset from merged data set, UCIHAR.
* ### Create "subset_UCIHAR" data set which contains only the measurements on the mean and standard deviation.
    + ### subset_UCIHAR has 10299 rows and 86 columns.
    
* ### Add subject, and y to subset_UCIHAR for next steps. (10299 x 88)   

***

> ## __3. Uses descriptive activity names to name the activities in the data set.__

* ### Change data type for subject_id, and activity_id of subset_UCIHAR data set to factor.
    + ### Set the __levels__ value of activity_id in subset_UCIHAR data set to activity_id of activity_labels.
    + ### Set the __labels__ value of activity_id in subset_UCIHAR data set to activity_name of activity_labels.
    
* ### The levels value of ctivity_id in subset_UCIHAR data set are:
    + ### "WALKING"  "WALKING_UPSTAIRS"  "WALKING_DOWNSTAIRS"  "SITTING"  "STANDING"  "LAYING"  

***

> ## __4. Appropriately labels the data set with descriptive variable names.__

* ### __[Basic Rule: column names in subset_UCIHAR data set]__
* ### Used original feature names as much as possible. (Please read "README.txt" and "features_info.txt")
* ### It was processed when reading the txt files using __changeFeatureName()__.
    
* ### __[abbreviation of column names]__
    + ### __"t"__: _time domain_
    + ### __"f"__: _frequency domain_
    + ### __"Acc"__: _accelerometer_
    + ### __"Gyro"__: _gyroscope_
    + ### __"Mag"__: _magnitude_
    + ### __"mean"__: _mean_
    + ### __"std"__: _standard deviation_
    
* ### Some Feature names are:
    + ### [1] "subject_id"                          "tBodyAcc_mean_X"                    
    + ### [3] "tBodyAcc_mean_Y"                     "tBodyAcc_mean_Z"                    
    + ### [5] "tGravityAcc_mean_X"                  "tGravityAcc_mean_Y"                 
    + ### [7] "tGravityAcc_mean_Z"                  "tBodyAccJerk_mean_X"                
    + ### [9] "tBodyAccJerk_mean_Y"                 "tBodyAccJerk_mean_Z"                
    + ### [11] "tBodyGyro_mean_X"                    "tBodyGyro_mean_Y"                   
    + ### [13] "tBodyGyro_mean_Z"                    "tBodyGyroJerk_mean_X"               
    + ### [15] "tBodyGyroJerk_mean_Y"                "tBodyGyroJerk_mean_Z"               
    + ### [17] "tBodyAccMag_mean"                    "tGravityAccMag_mean"                
    + ### [19] "tBodyAccJerkMag_mean"                "tBodyGyroMag_mean"                  

***

> ## __5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.__

* ### Used __aggregate()__ _to group by_ __subject and activity__ and _renamed grouping columns._
    + ### *Grouping order: __subject__ is the first and __activity__ is the second.*

* ### Used __fwrite()__ to create a new data set, __subset_UCIHAR_by_subject_activity__ that has _180 rows and 88 columns._
    + ### _Total rows(180): 30 subject x 6 activity._ 
    + ### _Total columns(88): subject(1) + activity(1) + subset of features(86)._
    
* ### The __"subset_UCIHAR_by_subject_activity.txt"__ was saved using one space as seperator for column.


