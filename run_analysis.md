# Getting and cleaning data course project


```r
library(knitr)
opts_chunk$set(cache = FALSE)
rm(list = ls())
```




```r
source("UCIDataReader.R")
library(data.table)
```


### Download and read data

```r
dataReader <- UCIDataReader()

activityLabel <- dataReader$activityLabel
feature <- dataReader$feature
train <- dataReader$train
trainSubject <- dataReader$trainSubject
trainActivity <- dataReader$trainActivity
test <- dataReader$test
testSubject <- dataReader$testSubject
testActivity <- dataReader$testActivity
```


### Cleanup feature column names
Rename column names to be more descriptives

```r
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
```


### Merging training and test dataset

```r
# add features to both training and test data sets
setnames(train, feature$Name)
setnames(test, feature$Name)

# add activity to both training and test data sets (human readable)
setnames(activityLabel, c("ActivityId", "Description"))
setnames(trainActivity, "ActivityId")
setnames(testActivity, "ActivityId")

trainActivityName <- tolower(activityLabel[trainActivity$ActivityId, ]$Description)
testActivityName <- tolower(activityLabel[testActivity$ActivityId, ]$Description)
trainActivity <- as.data.frame(trainActivityName)
testActivity <- as.data.frame(testActivityName)
setnames(trainActivity, "Activity")
setnames(testActivity, "Activity")

train <- cbind(trainActivity, train)
test <- cbind(testActivity, test)

# add subject to both training and test data sets
setnames(trainSubject, "SubjectId")
setnames(testSubject, "SubjectId")
train <- cbind(trainSubject, train)
test <- cbind(testSubject, test)
# merge both training and testing data set
combined.df <- rbind(train, test)
combined.df$SubjectId <- as.factor(combined.df$SubjectId)
```


### Subset dataset
Lots of features were provided by the raw dataset. 
For this project only the non-axial processed signals are of interest.
In order to comply with the "only one type of data in a tidy dataset" only the time domain signals is retained.

```r
# subset to only mean and sd columns of the magnitude features
meanAndStdDevCols <- which(grepl("^(Time)[[:alnum:]]+Magnitude(-Mean|-StdDev)", 
    colnames(combined.df)))
meanAndStdDevCols <- c(1:2, meanAndStdDevCols)
combinedSubset <- data.table(combined.df[, meanAndStdDevCols])
```


### calculate the mean for all variables for each subject - activity

```r
tidyData <- combinedSubset[, lapply(.SD, mean), by = list(SubjectId, Activity)]
write.table(tidyData, "tidyData.txt", row.names = FALSE)
```

