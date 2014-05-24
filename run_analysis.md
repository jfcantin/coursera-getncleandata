# Getting and cleaning data course project

### TODO:
* Replace activityId with textual factor
* convert subjectId to a factor
* review column names
* create codebook


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


### cleanup feature column names

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
```


### Subset dataset
Lots of features were provided by the raw dataset. 
For this project only the non-axial processed signals are of interest.


```r
# subset to only mean and sd columns of the magnitude features
meanAndStdDevCols <- which(grepl("Magnitude(-Mean|-StdDev)", colnames(combined.df)))
meanAndStdDevCols <- c(1:2, meanAndStdDevCols)
combinedSubset <- data.table(combined.df[, meanAndStdDevCols])
```


### calculate the mean for all variables for each subject - activity


```r
tidyData <- combinedSubset[, lapply(.SD, mean), by = list(SubjectId, Activity)]
str(tidyData)
```

```
## Classes 'data.table' and 'data.frame':	180 obs. of  20 variables:
##  $ SubjectId                                     : int  1 1 1 1 1 1 3 3 3 3 ...
##  $ Activity                                      : Factor w/ 6 levels "laying","sitting",..: 3 2 1 4 5 6 3 2 1 4 ...
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
head(tidyData)
```

```
##    SubjectId           Activity TimeBodyAccelerationMagnitude-Mean
## 1:         1           standing                           -0.98428
## 2:         1            sitting                           -0.94854
## 3:         1             laying                           -0.84193
## 4:         1            walking                           -0.13697
## 5:         1 walking_downstairs                            0.02719
## 6:         1   walking_upstairs                           -0.12993
##    TimeBodyAccelerationMagnitude-StdDev
## 1:                             -0.98194
## 2:                             -0.92708
## 3:                             -0.79514
## 4:                             -0.21969
## 5:                              0.01988
## 6:                             -0.32497
##    TimeGravityAccelerationMagnitude-Mean
## 1:                              -0.98428
## 2:                              -0.94854
## 3:                              -0.84193
## 4:                              -0.13697
## 5:                               0.02719
## 6:                              -0.12993
##    TimeGravityAccelerationMagnitude-StdDev
## 1:                                -0.98194
## 2:                                -0.92708
## 3:                                -0.79514
## 4:                                -0.21969
## 5:                                 0.01988
## 6:                                -0.32497
##    TimeBodyAccelerationJerkMagnitude-Mean
## 1:                               -0.99237
## 2:                               -0.98736
## 3:                               -0.95440
## 4:                               -0.14143
## 5:                               -0.08945
## 6:                               -0.46650
##    TimeBodyAccelerationJerkMagnitude-StdDev
## 1:                                 -0.99310
## 2:                                 -0.98412
## 3:                                 -0.92825
## 4:                                 -0.07447
## 5:                                 -0.02579
## 6:                                 -0.47899
##    TimeBodyGyroscopicMagnitude-Mean TimeBodyGyroscopicMagnitude-StdDev
## 1:                         -0.97649                            -0.9787
## 2:                         -0.93089                            -0.9345
## 3:                         -0.87476                            -0.8190
## 4:                         -0.16098                            -0.1870
## 5:                         -0.07574                            -0.2257
## 6:                         -0.12674                            -0.1486
##    TimeBodyGyroscopicJerkMagnitude-Mean
## 1:                              -0.9950
## 2:                              -0.9920
## 3:                              -0.9635
## 4:                              -0.2987
## 5:                              -0.2955
## 6:                              -0.5949
##    TimeBodyGyroscopicJerkMagnitude-StdDev
## 1:                                -0.9947
## 2:                                -0.9883
## 3:                                -0.9358
## 4:                                -0.3253
## 5:                                -0.3065
## 6:                                -0.6486
##    FreqDomainBodyAccelerationMagnitude-Mean
## 1:                                 -0.98536
## 2:                                 -0.94778
## 3:                                 -0.86177
## 4:                                 -0.12862
## 5:                                  0.09658
## 6:                                 -0.35240
##    FreqDomainBodyAccelerationMagnitude-StdDev
## 1:                                    -0.9823
## 2:                                    -0.9284
## 3:                                    -0.7983
## 4:                                    -0.3980
## 5:                                    -0.1865
## 6:                                    -0.4163
##    FreqDomainBodyAccelerationJerkMagnitude-Mean
## 1:                                     -0.99254
## 2:                                     -0.98526
## 3:                                     -0.93330
## 4:                                     -0.05712
## 5:                                      0.02622
## 6:                                     -0.44265
##    FreqDomainBodyAccelerationJerkMagnitude-StdDev
## 1:                                        -0.9925
## 2:                                        -0.9816
## 3:                                        -0.9218
## 4:                                        -0.1035
## 5:                                        -0.1041
## 6:                                        -0.5331
##    FreqDomainBodyGyroscopicMagnitude-Mean
## 1:                                -0.9846
## 2:                                -0.9584
## 3:                                -0.8622
## 4:                                -0.1993
## 5:                                -0.1857
## 6:                                -0.3260
##    FreqDomainBodyGyroscopicMagnitude-StdDev
## 1:                                  -0.9785
## 2:                                  -0.9322
## 3:                                  -0.8243
## 4:                                  -0.3210
## 5:                                  -0.3984
## 6:                                  -0.1830
##    FreqDomainBodyGyroscopicJerkMagnitude-Mean
## 1:                                    -0.9948
## 2:                                    -0.9898
## 3:                                    -0.9424
## 4:                                    -0.3193
## 5:                                    -0.2820
## 6:                                    -0.6347
##    FreqDomainBodyGyroscopicJerkMagnitude-StdDev
## 1:                                      -0.9947
## 2:                                      -0.9870
## 3:                                      -0.9327
## 4:                                      -0.3816
## 5:                                      -0.3919
## 6:                                      -0.6939
```

```r
write.table(tidyData, "tidyData.txt", row.names = FALSE)
```

