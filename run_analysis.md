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



```r
# process features column names

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
```

