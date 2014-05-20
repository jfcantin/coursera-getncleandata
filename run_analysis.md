# Getting and cleaning data course project

### TODO:
* Replace activityId with textual factor
* convert subjectId to a factor
* review column names
* create codebook


```r
opts_chunk$set(cache = TRUE)
rm(list = ls())
```




```r
library(data.table)
```


### Download data

```r
zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFileName <- "data//uci-har-dataset.zip"

if (!file.exists(zipFileName)) {
    download.file(zipFileUrl, zipFileName, method = "curl")
}
```


```r
# list files in zipFile
unzip(zipFileName, list = TRUE)$Name
```

```
##  [1] "UCI HAR Dataset/activity_labels.txt"                         
##  [2] "UCI HAR Dataset/features.txt"                                
##  [3] "UCI HAR Dataset/features_info.txt"                           
##  [4] "UCI HAR Dataset/README.txt"                                  
##  [5] "UCI HAR Dataset/test/"                                       
##  [6] "UCI HAR Dataset/test/Inertial Signals/"                      
##  [7] "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
##  [8] "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
##  [9] "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
## [10] "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
## [11] "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
## [12] "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
## [13] "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
## [14] "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
## [15] "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
## [16] "UCI HAR Dataset/test/subject_test.txt"                       
## [17] "UCI HAR Dataset/test/X_test.txt"                             
## [18] "UCI HAR Dataset/test/y_test.txt"                             
## [19] "UCI HAR Dataset/train/"                                      
## [20] "UCI HAR Dataset/train/Inertial Signals/"                     
## [21] "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
## [22] "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
## [23] "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
## [24] "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
## [25] "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
## [26] "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
## [27] "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
## [28] "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
## [29] "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
## [30] "UCI HAR Dataset/train/subject_train.txt"                     
## [31] "UCI HAR Dataset/train/X_train.txt"                           
## [32] "UCI HAR Dataset/train/y_train.txt"
```

```r

activityLabelFileName <- "UCI HAR Dataset/activity_labels.txt"
featureFileName <- "UCI HAR Dataset/features.txt"
trainFileName <- "UCI HAR Dataset/train/X_train.txt"
trainSubjectFileName <- "UCI HAR Dataset/train/subject_train.txt"
trainActivityFileName <- "UCI HAR Dataset/train/y_train.txt"
testFileName <- "UCI HAR Dataset/test/X_test.txt"
testSubjectFileName <- "UCI HAR Dataset/test/subject_test.txt"
testActivityFileName <- "UCI HAR Dataset/test/y_test.txt"

activityLabel <- read.table(unz(zipFileName, activityLabelFileName))
feature <- read.table(unz(zipFileName, featureFileName))
train <- read.table(unz(zipFileName, trainFileName))
trainSubject <- read.table(unz(zipFileName, trainSubjectFileName))
trainActivity <- read.table(unz(zipFileName, trainActivityFileName))
test <- read.table(unz(zipFileName, testFileName))
testSubject <- read.table(unz(zipFileName, testSubjectFileName))
testActivity <- read.table(unz(zipFileName, testActivityFileName))
```


### process features column names

```r
# clean up feature names
setnames(feature, c("Id", "Name"))
feature$Name <- gsub("^(t)", "Time", feature$Name)
feature$Name <- gsub("^(f)", "FreqDomain", feature$Name)
feature$Name <- gsub("BodyBody", "Body", feature$Name)
feature$Name <- gsub("BodyAcc", "BodyAcceleration", feature$Name)
feature$Name <- gsub("GravityAcc", "GravityAcceleration", feature$Name)
feature$Name <- gsub("Mag", "Magnitude", feature$Name)
feature$Name <- gsub("Gyro", "Gyroscopic", feature$Name)
feature$Name <- gsub("-mean\\(\\)", "-Mean", feature$Name)
feature$Name <- gsub("-std\\(\\)", "-StdDev", feature$Name)
# angle() fields are not included


# add features to both training and test data sets
setnames(train, feature$Name)
setnames(test, feature$Name)

# add activity to both training and test data sets (human readable)
setnames(trainActivity, "ActivityId")
setnames(testActivity, "ActivityId")
train <- cbind(trainActivity, train)
test <- cbind(testActivity, test)

# add subject to both training and test data sets (human readable)
setnames(trainSubject, "SubjectId")
setnames(testSubject, "SubjectId")
train <- cbind(trainSubject, train)
test <- cbind(testSubject, test)

# merge both training and testing data set
combined.df <- rbind(train, test)

# subset to only mean and sd columns
meanAndStdDevCols <- which(grepl("(-Mean|-StdDev)", colnames(combined.df)))
meanAndStdDevCols <- c(1:2, meanAndStdDevCols)
combinedSubset <- combined.df[, meanAndStdDevCols]

# calculate the mean for all variables for each subject - activity
combinedSubset <- data.table(combinedSubset)

tidyData <- combinedSubset[, lapply(.SD, mean), by = list(SubjectId, ActivityId)]

write.table(tidyData, "tidyData.txt", row.names = FALSE)

a <- str(tidyData)
```

```
## Classes 'data.table' and 'data.frame':	180 obs. of  68 variables:
##  $ SubjectId                                     : int  1 1 1 1 1 1 3 3 3 3 ...
##  $ ActivityId                                    : int  5 4 6 1 3 2 5 4 6 1 ...
##  $ TimeBodyAcceleration-Mean-X                   : num  0.279 0.261 0.222 0.277 0.289 ...
##  $ TimeBodyAcceleration-Mean-Y                   : num  -0.01614 -0.00131 -0.04051 -0.01738 -0.00992 ...
##  $ TimeBodyAcceleration-Mean-Z                   : num  -0.111 -0.105 -0.113 -0.111 -0.108 ...
##  $ TimeBodyAcceleration-StdDev-X                 : num  -0.996 -0.977 -0.928 -0.284 0.03 ...
##  $ TimeBodyAcceleration-StdDev-Y                 : num  -0.9732 -0.9226 -0.8368 0.1145 -0.0319 ...
##  $ TimeBodyAcceleration-StdDev-Z                 : num  -0.98 -0.94 -0.826 -0.26 -0.23 ...
##  $ TimeGravityAcceleration-Mean-X                : num  0.943 0.832 -0.249 0.935 0.932 ...
##  $ TimeGravityAcceleration-Mean-Y                : num  -0.273 0.204 0.706 -0.282 -0.267 ...
##  $ TimeGravityAcceleration-Mean-Z                : num  0.0135 0.332 0.4458 -0.0681 -0.0621 ...
##  $ TimeGravityAcceleration-StdDev-X              : num  -0.994 -0.968 -0.897 -0.977 -0.951 ...
##  $ TimeGravityAcceleration-StdDev-Y              : num  -0.981 -0.936 -0.908 -0.971 -0.937 ...
##  $ TimeGravityAcceleration-StdDev-Z              : num  -0.976 -0.949 -0.852 -0.948 -0.896 ...
##  $ TimeBodyAccelerationJerk-Mean-X               : num  0.0754 0.0775 0.0811 0.074 0.0542 ...
##  $ TimeBodyAccelerationJerk-Mean-Y               : num  0.007976 -0.000619 0.003838 0.028272 0.02965 ...
##  $ TimeBodyAccelerationJerk-Mean-Z               : num  -0.00369 -0.00337 0.01083 -0.00417 -0.01097 ...
##  $ TimeBodyAccelerationJerk-StdDev-X             : num  -0.9946 -0.9864 -0.9585 -0.1136 -0.0123 ...
##  $ TimeBodyAccelerationJerk-StdDev-Y             : num  -0.986 -0.981 -0.924 0.067 -0.102 ...
##  $ TimeBodyAccelerationJerk-StdDev-Z             : num  -0.992 -0.988 -0.955 -0.503 -0.346 ...
##  $ TimeBodyGyroscopic-Mean-X                     : num  -0.024 -0.0454 -0.0166 -0.0418 -0.0351 ...
##  $ TimeBodyGyroscopic-Mean-Y                     : num  -0.0594 -0.0919 -0.0645 -0.0695 -0.0909 ...
##  $ TimeBodyGyroscopic-Mean-Z                     : num  0.0748 0.0629 0.1487 0.0849 0.0901 ...
##  $ TimeBodyGyroscopic-StdDev-X                   : num  -0.987 -0.977 -0.874 -0.474 -0.458 ...
##  $ TimeBodyGyroscopic-StdDev-Y                   : num  -0.9877 -0.9665 -0.9511 -0.0546 -0.1263 ...
##  $ TimeBodyGyroscopic-StdDev-Z                   : num  -0.981 -0.941 -0.908 -0.344 -0.125 ...
##  $ TimeBodyGyroscopicJerk-Mean-X                 : num  -0.0996 -0.0937 -0.1073 -0.09 -0.074 ...
##  $ TimeBodyGyroscopicJerk-Mean-Y                 : num  -0.0441 -0.0402 -0.0415 -0.0398 -0.044 ...
##  $ TimeBodyGyroscopicJerk-Mean-Z                 : num  -0.049 -0.0467 -0.0741 -0.0461 -0.027 ...
##  $ TimeBodyGyroscopicJerk-StdDev-X               : num  -0.993 -0.992 -0.919 -0.207 -0.487 ...
##  $ TimeBodyGyroscopicJerk-StdDev-Y               : num  -0.995 -0.99 -0.968 -0.304 -0.239 ...
##  $ TimeBodyGyroscopicJerk-StdDev-Z               : num  -0.992 -0.988 -0.958 -0.404 -0.269 ...
##  $ TimeBodyAccelerationMagnitude-Mean            : num  -0.9843 -0.9485 -0.8419 -0.137 0.0272 ...
##  $ TimeBodyAccelerationMagnitude-StdDev          : num  -0.9819 -0.9271 -0.7951 -0.2197 0.0199 ...
##  $ TimeGravityAccelerationMagnitude-Mean         : num  -0.9843 -0.9485 -0.8419 -0.137 0.0272 ...
##  $ TimeGravityAccelerationMagnitude-StdDev       : num  -0.9819 -0.9271 -0.7951 -0.2197 0.0199 ...
##  $ TimeBodyAccelerationJerkMagnitude-Mean        : num  -0.9924 -0.9874 -0.9544 -0.1414 -0.0894 ...
##  $ TimeBodyAccelerationJerkMagnitude-StdDev      : num  -0.9931 -0.9841 -0.9282 -0.0745 -0.0258 ...
##  $ TimeBodyGyroscopicMagnitude-Mean              : num  -0.9765 -0.9309 -0.8748 -0.161 -0.0757 ...
##  $ TimeBodyGyroscopicMagnitude-StdDev            : num  -0.979 -0.935 -0.819 -0.187 -0.226 ...
##  $ TimeBodyGyroscopicJerkMagnitude-Mean          : num  -0.995 -0.992 -0.963 -0.299 -0.295 ...
##  $ TimeBodyGyroscopicJerkMagnitude-StdDev        : num  -0.995 -0.988 -0.936 -0.325 -0.307 ...
##  $ FreqDomainBodyAcceleration-Mean-X             : num  -0.9952 -0.9796 -0.9391 -0.2028 0.0382 ...
##  $ FreqDomainBodyAcceleration-Mean-Y             : num  -0.97707 -0.94408 -0.86707 0.08971 0.00155 ...
##  $ FreqDomainBodyAcceleration-Mean-Z             : num  -0.985 -0.959 -0.883 -0.332 -0.226 ...
##  $ FreqDomainBodyAcceleration-StdDev-X           : num  -0.996 -0.9764 -0.9244 -0.3191 0.0243 ...
##  $ FreqDomainBodyAcceleration-StdDev-Y           : num  -0.972 -0.917 -0.834 0.056 -0.113 ...
##  $ FreqDomainBodyAcceleration-StdDev-Z           : num  -0.978 -0.934 -0.813 -0.28 -0.298 ...
##  $ FreqDomainBodyAccelerationJerk-Mean-X         : num  -0.9946 -0.9866 -0.9571 -0.1705 -0.0277 ...
##  $ FreqDomainBodyAccelerationJerk-Mean-Y         : num  -0.9854 -0.9816 -0.9225 -0.0352 -0.1287 ...
##  $ FreqDomainBodyAccelerationJerk-Mean-Z         : num  -0.991 -0.986 -0.948 -0.469 -0.288 ...
##  $ FreqDomainBodyAccelerationJerk-StdDev-X       : num  -0.9951 -0.9875 -0.9642 -0.1336 -0.0863 ...
##  $ FreqDomainBodyAccelerationJerk-StdDev-Y       : num  -0.987 -0.983 -0.932 0.107 -0.135 ...
##  $ FreqDomainBodyAccelerationJerk-StdDev-Z       : num  -0.992 -0.988 -0.961 -0.535 -0.402 ...
##  $ FreqDomainBodyGyroscopic-Mean-X               : num  -0.986 -0.976 -0.85 -0.339 -0.352 ...
##  $ FreqDomainBodyGyroscopic-Mean-Y               : num  -0.989 -0.9758 -0.9522 -0.1031 -0.0557 ...
##  $ FreqDomainBodyGyroscopic-Mean-Z               : num  -0.9808 -0.9513 -0.9093 -0.2559 -0.0319 ...
##  $ FreqDomainBodyGyroscopic-StdDev-X             : num  -0.987 -0.978 -0.882 -0.517 -0.495 ...
##  $ FreqDomainBodyGyroscopic-StdDev-Y             : num  -0.9871 -0.9623 -0.9512 -0.0335 -0.1814 ...
##  $ FreqDomainBodyGyroscopic-StdDev-Z             : num  -0.982 -0.944 -0.917 -0.437 -0.238 ...
##  $ FreqDomainBodyAccelerationMagnitude-Mean      : num  -0.9854 -0.9478 -0.8618 -0.1286 0.0966 ...
##  $ FreqDomainBodyAccelerationMagnitude-StdDev    : num  -0.982 -0.928 -0.798 -0.398 -0.187 ...
##  $ FreqDomainBodyAccelerationJerkMagnitude-Mean  : num  -0.9925 -0.9853 -0.9333 -0.0571 0.0262 ...
##  $ FreqDomainBodyAccelerationJerkMagnitude-StdDev: num  -0.993 -0.982 -0.922 -0.103 -0.104 ...
##  $ FreqDomainBodyGyroscopicMagnitude-Mean        : num  -0.985 -0.958 -0.862 -0.199 -0.186 ...
##  $ FreqDomainBodyGyroscopicMagnitude-StdDev      : num  -0.978 -0.932 -0.824 -0.321 -0.398 ...
##  $ FreqDomainBodyGyroscopicJerkMagnitude-Mean    : num  -0.995 -0.99 -0.942 -0.319 -0.282 ...
##  $ FreqDomainBodyGyroscopicJerkMagnitude-StdDev  : num  -0.995 -0.987 -0.933 -0.382 -0.392 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```

```r
a
```

```
## NULL
```

```r

write.table(a, "strTidyData.txt", row.names = FALSE)
```

