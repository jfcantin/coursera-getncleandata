# Getting and cleaning data course project

### TODO:
* Replace activityId with textual factor
* convert subjectId to a factor
* review column names
* create codebook


```r
library(knitr)
opts_chunk$set(cache = TRUE)
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
```


### Subset dataset

```r
# subset to only mean and sd columns
meanAndStdDevCols <- which(grepl("(-Mean|-StdDev)", colnames(combined.df)))
meanAndStdDevCols <- c(1:2, meanAndStdDevCols)
combinedSubset <- data.table(combined.df[, meanAndStdDevCols])
```


### calculate the mean for all variables for each subject - activity


```r
tidyData <- combinedSubset[, lapply(.SD, mean), by = list(SubjectId, ActivityId)]
str(tidyData)
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
head(tidyData)
```

```
##    SubjectId ActivityId TimeBodyAcceleration-Mean-X
## 1:         1          5                      0.2789
## 2:         1          4                      0.2612
## 3:         1          6                      0.2216
## 4:         1          1                      0.2773
## 5:         1          3                      0.2892
## 6:         1          2                      0.2555
##    TimeBodyAcceleration-Mean-Y TimeBodyAcceleration-Mean-Z
## 1:                   -0.016138                     -0.1106
## 2:                   -0.001308                     -0.1045
## 3:                   -0.040514                     -0.1132
## 4:                   -0.017384                     -0.1111
## 5:                   -0.009919                     -0.1076
## 6:                   -0.023953                     -0.0973
##    TimeBodyAcceleration-StdDev-X TimeBodyAcceleration-StdDev-Y
## 1:                      -0.99576                      -0.97319
## 2:                      -0.97723                      -0.92262
## 3:                      -0.92806                      -0.83683
## 4:                      -0.28374                       0.11446
## 5:                       0.03004                      -0.03194
## 6:                      -0.35471                      -0.00232
##    TimeBodyAcceleration-StdDev-Z TimeGravityAcceleration-Mean-X
## 1:                      -0.97978                         0.9430
## 2:                      -0.93959                         0.8315
## 3:                      -0.82606                        -0.2489
## 4:                      -0.26003                         0.9352
## 5:                      -0.23043                         0.9319
## 6:                      -0.01948                         0.8934
##    TimeGravityAcceleration-Mean-Y TimeGravityAcceleration-Mean-Z
## 1:                        -0.2730                        0.01349
## 2:                         0.2044                        0.33204
## 3:                         0.7055                        0.44582
## 4:                        -0.2822                       -0.06810
## 5:                        -0.2666                       -0.06212
## 6:                        -0.3622                       -0.07540
##    TimeGravityAcceleration-StdDev-X TimeGravityAcceleration-StdDev-Y
## 1:                          -0.9938                          -0.9812
## 2:                          -0.9685                          -0.9355
## 3:                          -0.8968                          -0.9077
## 4:                          -0.9766                          -0.9713
## 5:                          -0.9506                          -0.9370
## 6:                          -0.9564                          -0.9528
##    TimeGravityAcceleration-StdDev-Z TimeBodyAccelerationJerk-Mean-X
## 1:                          -0.9763                         0.07538
## 2:                          -0.9490                         0.07748
## 3:                          -0.8524                         0.08109
## 4:                          -0.9477                         0.07404
## 5:                          -0.8959                         0.05416
## 6:                          -0.9124                         0.10137
##    TimeBodyAccelerationJerk-Mean-Y TimeBodyAccelerationJerk-Mean-Z
## 1:                       0.0079757                       -0.003685
## 2:                      -0.0006191                       -0.003368
## 3:                       0.0038382                        0.010834
## 4:                       0.0282721                       -0.004168
## 5:                       0.0296504                       -0.010972
## 6:                       0.0194863                       -0.045563
##    TimeBodyAccelerationJerk-StdDev-X TimeBodyAccelerationJerk-StdDev-Y
## 1:                          -0.99460                           -0.9856
## 2:                          -0.98643                           -0.9814
## 3:                          -0.95848                           -0.9241
## 4:                          -0.11362                            0.0670
## 5:                          -0.01228                           -0.1016
## 6:                          -0.44684                           -0.3783
##    TimeBodyAccelerationJerk-StdDev-Z TimeBodyGyroscopic-Mean-X
## 1:                           -0.9923                  -0.02399
## 2:                           -0.9879                  -0.04535
## 3:                           -0.9549                  -0.01655
## 4:                           -0.5027                  -0.04183
## 5:                           -0.3457                  -0.03508
## 6:                           -0.7066                   0.05055
##    TimeBodyGyroscopic-Mean-Y TimeBodyGyroscopic-Mean-Z
## 1:                  -0.05940                   0.07480
## 2:                  -0.09192                   0.06293
## 3:                  -0.06449                   0.14869
## 4:                  -0.06953                   0.08494
## 5:                  -0.09094                   0.09009
## 6:                  -0.16617                   0.05836
##    TimeBodyGyroscopic-StdDev-X TimeBodyGyroscopic-StdDev-Y
## 1:                     -0.9872                   -0.987734
## 2:                     -0.9772                   -0.966474
## 3:                     -0.8735                   -0.951090
## 4:                     -0.4735                   -0.054608
## 5:                     -0.4580                   -0.126349
## 6:                     -0.5449                    0.004105
##    TimeBodyGyroscopic-StdDev-Z TimeBodyGyroscopicJerk-Mean-X
## 1:                     -0.9806                      -0.09961
## 2:                     -0.9414                      -0.09368
## 3:                     -0.9083                      -0.10727
## 4:                     -0.3443                      -0.09000
## 5:                     -0.1247                      -0.07396
## 6:                     -0.5072                      -0.12223
##    TimeBodyGyroscopicJerk-Mean-Y TimeBodyGyroscopicJerk-Mean-Z
## 1:                      -0.04406                      -0.04895
## 2:                      -0.04021                      -0.04670
## 3:                      -0.04152                      -0.07405
## 4:                      -0.03984                      -0.04613
## 5:                      -0.04399                      -0.02705
## 6:                      -0.04215                      -0.04071
##    TimeBodyGyroscopicJerk-StdDev-X TimeBodyGyroscopicJerk-StdDev-Y
## 1:                         -0.9929                         -0.9951
## 2:                         -0.9917                         -0.9895
## 3:                         -0.9186                         -0.9679
## 4:                         -0.2074                         -0.3045
## 5:                         -0.4870                         -0.2388
## 6:                         -0.6148                         -0.6017
##    TimeBodyGyroscopicJerk-StdDev-Z TimeBodyAccelerationMagnitude-Mean
## 1:                         -0.9921                           -0.98428
## 2:                         -0.9879                           -0.94854
## 3:                         -0.9578                           -0.84193
## 4:                         -0.4043                           -0.13697
## 5:                         -0.2688                            0.02719
## 6:                         -0.6063                           -0.12993
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
##    FreqDomainBodyAcceleration-Mean-X FreqDomainBodyAcceleration-Mean-Y
## 1:                          -0.99525                          -0.97707
## 2:                          -0.97964                          -0.94408
## 3:                          -0.93910                          -0.86707
## 4:                          -0.20279                           0.08971
## 5:                           0.03823                           0.00155
## 6:                          -0.40432                          -0.19098
##    FreqDomainBodyAcceleration-Mean-Z FreqDomainBodyAcceleration-StdDev-X
## 1:                           -0.9853                            -0.99603
## 2:                           -0.9592                            -0.97641
## 3:                           -0.8827                            -0.92444
## 4:                           -0.3316                            -0.31913
## 5:                           -0.2256                             0.02433
## 6:                           -0.4333                            -0.33743
##    FreqDomainBodyAcceleration-StdDev-Y FreqDomainBodyAcceleration-StdDev-Z
## 1:                            -0.97229                            -0.97794
## 2:                            -0.91728                            -0.93447
## 3:                            -0.83363                            -0.81289
## 4:                             0.05604                            -0.27969
## 5:                            -0.11296                            -0.29793
## 6:                             0.02177                             0.08596
##    FreqDomainBodyAccelerationJerk-Mean-X
## 1:                              -0.99463
## 2:                              -0.98660
## 3:                              -0.95707
## 4:                              -0.17055
## 5:                              -0.02766
## 6:                              -0.47988
##    FreqDomainBodyAccelerationJerk-Mean-Y
## 1:                              -0.98542
## 2:                              -0.98158
## 3:                              -0.92246
## 4:                              -0.03523
## 5:                              -0.12867
## 6:                              -0.41344
##    FreqDomainBodyAccelerationJerk-Mean-Z
## 1:                               -0.9908
## 2:                               -0.9861
## 3:                               -0.9481
## 4:                               -0.4690
## 5:                               -0.2883
## 6:                               -0.6855
##    FreqDomainBodyAccelerationJerk-StdDev-X
## 1:                                -0.99507
## 2:                                -0.98749
## 3:                                -0.96416
## 4:                                -0.13359
## 5:                                -0.08633
## 6:                                -0.46191
##    FreqDomainBodyAccelerationJerk-StdDev-Y
## 1:                                 -0.9870
## 2:                                 -0.9825
## 3:                                 -0.9322
## 4:                                  0.1067
## 5:                                 -0.1346
## 6:                                 -0.3818
##    FreqDomainBodyAccelerationJerk-StdDev-Z FreqDomainBodyGyroscopic-Mean-X
## 1:                                 -0.9923                         -0.9864
## 2:                                 -0.9883                         -0.9762
## 3:                                 -0.9606                         -0.8502
## 4:                                 -0.5347                         -0.3390
## 5:                                 -0.4017                         -0.3524
## 6:                                 -0.7260                         -0.4926
##    FreqDomainBodyGyroscopic-Mean-Y FreqDomainBodyGyroscopic-Mean-Z
## 1:                         -0.9890                        -0.98077
## 2:                         -0.9758                        -0.95132
## 3:                         -0.9522                        -0.90930
## 4:                         -0.1031                        -0.25594
## 5:                         -0.0557                        -0.03187
## 6:                         -0.3195                        -0.45360
##    FreqDomainBodyGyroscopic-StdDev-X FreqDomainBodyGyroscopic-StdDev-Y
## 1:                           -0.9875                          -0.98711
## 2:                           -0.9779                          -0.96235
## 3:                           -0.8823                          -0.95123
## 4:                           -0.5167                          -0.03351
## 5:                           -0.4954                          -0.18141
## 6:                           -0.5659                           0.15154
##    FreqDomainBodyGyroscopic-StdDev-Z
## 1:                           -0.9823
## 2:                           -0.9439
## 3:                           -0.9166
## 4:                           -0.4366
## 5:                           -0.2384
## 6:                           -0.5717
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

