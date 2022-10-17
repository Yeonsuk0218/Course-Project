######################
## Getting and Cleaning Data Course Project
##-----------------------------------------
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
######################
library(readr)
library(dplyr)
library(data.table)
library(stringr)
search()

## download zip file afrom internet nd unzip files
temp <- tempfile(tmpdir='./Week4/Course-Project/', fileext='.zip')
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url=fileURL, destfile=temp)
unzip(zipfile=temp, exdir='./Week4/Course-Project/')
unlink(temp)

## use "relative_path" as a global variable
relative_path <<- './Week4/Course-Project/UCI HAR Dataset'

## # list all files in a directory
list.files(relative_path, recursive = TRUE)

## read "features.txt"
filename <- paste0(relative_path, '/features.txt')
features <<- fread(filename, col.names=c('no', 'fun'))

## read "activity_labels.txt"
filename <- paste0(relative_path, '/activity_labels.txt')
activity_labels <<- fread(filename, col.names=c('activity_id', 'activity_name'))

## function: to change feature names
changeFeatureName <- function(features_names) {
    features_names <- features$fun
    features_names <- gsub('-', '_', features_names)
    features_names <- gsub(',', '_', features_names)
    features_names <- gsub('\\()$', '', features_names)
    features_names <- gsub('\\()_', '_', features_names)
    features_names <- gsub('\\()', '_', features_names)
    features_names <- gsub('\\)', '', features_names)
    features_names <- gsub('\\(', '_', features_names)
    
    return(features_names)
}

## change feature names 
features_names <<- changeFeatureName(features$fun)


######################
## Read train/test data set
######################
readDataSet <- function(dataList, category='train') {
    for (i in seq_along(dataList)) {
        filename <- NULL
        
        ## if (i <= 3) then
        if (i <= 3) {
            filename <- paste0(relative_path, '/', category, '/', names(dataList[i]), '.txt')
            message(paste0('i=[', i, '] filename=[', filename, ']'))
            
            ## train: data set
            if (category=='train') {
                if (i==1) {         dataList$subject_train <- fread(filename, col.names=c('subject_id'))
                } else if (i==2) {  dataList$X_train <- fread(filename, col.names=c(features_names))
                } else if (i==3) {  dataList$y_train <- fread(filename, col.names=c('activity_id'))
                }
                
                ## test: data set                
            } else if (category=='test') {
                if (i==1) {         dataList$subject_test <- fread(filename, col.names=c('subject_id'))
                } else if (i==2) {  dataList$X_test <- fread(filename, col.names=c(features_names))
                } else if (i==3) {  dataList$y_test <- fread(filename, col.names=c('activity_id'))
                }
            } # end if()
        } # end if(i<=3)
    } # end for(i in seq_along())
    
    return(dataList)
} # end function()


## list for train data set
train <- list(subject_train=NULL, X_train=NULL, y_train=NULL
              # , body_acc_x_train=NULL, body_acc_y_train=NULL, body_acc_z_train=NULL
              # , body_gyro_x_train=NULL, body_gyro_y_train=NULL, body_gyro_z_train=NULL
              # , total_acc_x_train=NULL, total_acc_y_train=NULL, total_acc_z_train=NULL
)

## (1) read "train" data set
train <- readDataSet(train, 'train')


## list for test data set
test <- list(subject_test=NULL, X_test=NULL, y_test=NULL
             # , body_acc_x_test=NULL, body_acc_y_test=NULL, body_acc_z_test=NULL
             # , body_gyro_x_test=NULL, body_gyro_y_test=NULL, body_gyro_z_test=NULL
             # , total_acc_x_test=NULL, total_acc_y_test=NULL, total_acc_z_test=NULL
)

## (2) read "train" data set
test <- readDataSet(test, 'test')

## check dimension of train/test data set
dim(train$subject_train)  # (7352, 1)
dim(train$X_train)        # (7352, 561)
dim(train$y_train)        # (7352, 1)

dim(test$subject_test)    # (2947, 1)
dim(test$X_test)          # (2947, 561)
dim(test$y_test)          # (2947, 1)


##################################################################
## 1. Merges the training and the test sets to create one data set.
##################################################################
## Features are normalized and bounded within [-1,1].

## An identifier of the subject who carried out the experiment
subject <- data.frame(rbind(train$subject_train, test$subject_test))  # ID, (10299, 1)
dim(subject)

## A 561-feature vector with time and frequency domain variables
X <- data.frame((rbind(train$X_train, test$X_test)))                   # X:561 feature vector, (10299, 561) 

## R rbind Function Error: Names don’t Match Previous Names
## --> Fixing the Error “names do not match previous names” by Renaming Columns.
names(X) <- features_names   # rename columns because of rbind() error

dim(X)

## Its activity label
y <- data.frame(rbind(train$y_train, test$y_test))                    # y:activity_id, (10299, 1)
dim(y)

## merge data set(UCIHAR): subject + X + y
## R cbind Function Error: “names do not match previous names” by Renaming Columns.
UCIHAR <- data.frame(cbind(subject, X, y))
names(UCIHAR)[-c(1, ncol(UCIHAR))] <- features_names   # rename columns because of cbind() error
names(UCIHAR)

dim(UCIHAR)  # (10299, 563)

##################################################################
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##################################################################
## Select Columns that Contain One of Several Strings
sel_columns <- colnames(select(UCIHAR, matches(c('mean', 'std'))))
length(sel_columns) # 86

## subset of UCIHAR data set containing mean and std for each measurements 
subset_UCIHAR <- UCIHAR[, c(sel_columns)]

dim(subset_UCIHAR)   # (10299, 86)

head(subset_UCIHAR[, 1:4], 3)

tail(subset_UCIHAR[, (length(sel_columns)-3):length(sel_columns)], 3)

names(subset_UCIHAR)  # 86 columns

## Add subject, and y to subset_UCIHAR for next steps.
## cbind (subset_UCIHAR = subject + subset_UCIHAR + y)
subset_UCIHAR <- data.frame(cbind(subject, subset_UCIHAR, y))
names(subset_UCIHAR) # 88 columns (including subject, and y)

dim(subset_UCIHAR)   # (10299, 88)


##################################################################
## 3. Uses descriptive activity names to name the activities in the data set
##################################################################
######################
## (1) Use "subset_UCIHAR" data set
######################
## transfer data type of subject_id(subject) from integer to factor
subset_UCIHAR$subject_id <- factor(subset_UCIHAR$subject_id)

## transfer data type of activity_id(y) from integer to factor
subset_UCIHAR$activity_id <- factor(subset_UCIHAR$activity_id
                             , levels=c(activity_labels$activity_id)
                             , labels=c(activity_labels$activity_name))

## structure of subset_UCIHAR data set 
str(subset_UCIHAR[, c(1:4, ncol(subset_UCIHAR))])
# 'data.frame':	10299 obs. of  5 variables:
# $ subject_id     : Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ tBodyAcc_mean_X: num  0.289 0.278 0.28 0.279 0.277 ...
# $ tBodyAcc_mean_Y: num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
# $ tBodyAcc_mean_Z: num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
# $ activity_id    : Factor w/ 6 levels "WALKING","WALKING_UPSTAIRS",..: 5 5 5 5 5 5 5 5 5 5 ..

dim(subset_UCIHAR)  # (10299, 88)

levels(subset_UCIHAR$activity_id)
# [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS" "SITTING"            "STANDING"           "LAYING" 

names(subset_UCIHAR)

table(subset_UCIHAR$activity_id)
# WALKING   WALKING_UPSTAIRS WALKING_DOWNSTAIRS            SITTING           STANDING             LAYING 
# 1722               1544               1406               1777               1906               1944 

##################################################################
## 4. Appropriately labels the data set with descriptive variable names. 
##################################################################
## [FEATURE NAME: BASIC RULE]
## 1. use original feature names as much as possible.
## 2. remove/replace special characters(',', '(', ')').
## 3. replace hyphen('-') to underscore('_').
## 4. follow original rule mentioned features_info.txt file.
##   (for example: 't': time domain, 'f': frequency domain)

######################
## (1) Use "subset_UCIHAR" data set
######################
## Applied to descriptive variable names when reading the 'txt' files using changeFeatureName().
names(subset_UCIHAR)


##################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##################################################################
######################
## (1) Use "subset_UCIHAR" data set
######################
## (1) create a new data set group by subject and activity
## (2) rename group name
subset_UCIHAR_by_subject_activity <- aggregate(x=subset_UCIHAR[, -c(1, ncol(subset_UCIHAR))]
                                        , by=list(subset_UCIHAR$subject_id, subset_UCIHAR$activity_id)
                                        , FUN=mean) %>%
    rename(c('subject_id'='Group.1', 'activity_id'='Group.2'))

dim(subset_UCIHAR_by_subject_activity)         # (180, 88)

names(subset_UCIHAR_by_subject_activity)

subset_UCIHAR_by_subject_activity[1:10
                           , c(1:4, (ncol(subset_UCIHAR_by_subject_activity)-2):ncol(subset_UCIHAR_by_subject_activity))]

table(subset_UCIHAR_by_subject_activity$subject_id
      , subset_UCIHAR_by_subject_activity$activity_id)

## save "subset_UCIHAR_by_subject_activity.txt" file 
filename <- paste0(relative_path, '/subset_UCIHAR_by_subject_activity.txt')
# fwrite(x=subset_UCIHAR_by_subject_activity, file=filename, sep=' ',append=FALSE)

## Course Instructions
write.table(x=subset_UCIHAR_by_subject_activity, file=filename, row.name=FALSE)


##--------------- The end of Week4: Course Project ----------------
