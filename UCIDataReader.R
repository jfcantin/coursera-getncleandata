UCIDataReader <- function(){
    
    zipFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipFileName <- "data//uci-har-dataset.zip"
    activityLabelFileName <- 'UCI HAR Dataset/activity_labels.txt'
    featureFileName <- 'UCI HAR Dataset/features.txt'
    trainFileName <- "UCI HAR Dataset/train/X_train.txt"
    trainSubjectFileName <- "UCI HAR Dataset/train/subject_train.txt"
    trainActivityFileName <- "UCI HAR Dataset/train/y_train.txt"
    testFileName <- "UCI HAR Dataset/test/X_test.txt"
    testSubjectFileName <- "UCI HAR Dataset/test/subject_test.txt"
    testActivityFileName <- "UCI HAR Dataset/test/y_test.txt"
    
    
    if(!file.exists(zipFileName)){
        download.file(zipFileUrl, zipFileName, method="curl")
    }
    
        activityLabel <- read.table(unz(zipFileName, activityLabelFileName))
        feature <- read.table(unz(zipFileName, featureFileName))
        train <- read.table(unz(zipFileName, trainFileName))
        trainSubject <- read.table(unz(zipFileName, trainSubjectFileName))
        trainActivity <- read.table(unz(zipFileName, trainActivityFileName))
        test <- read.table(unz(zipFileName, testFileName))
        testSubject <- read.table(unz(zipFileName, testSubjectFileName))
        testActivity <- read.table(unz(zipFileName, testActivityFileName))
    
    return (list(
        activityLabel = activityLabel,
        feature = feature,
        train = train,
        trainSubject = trainSubject,
        trainActivity = trainActivity,
        test = test,
        testSubject = testSubject,
        testActivity = testActivity
    ))
}