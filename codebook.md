# Codebook

## Original Data
The original data was obtained from the UCI Machine Learning Repository. The link to the `Human Activity Recognition Using Smartphones Data Set` is provided here :  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Data Processing
The raw dataset was processed using `run_analysis.Rmd`. All steps are documented within the script and can be reviewed in the `run_analysis.md` or `run_analysis.html` files which includes the code, documentation and results.

The above mentioned dataset contained a training and test sets. These 2 data sets were combined. The subject and activity label were also added.  Only those features representing the mean or standard deviation of a measurement were retained.  These features were then averaged for each (`subject`, `activity`) pair.

## Tidy dataset variable description

* `SubjectId`
    * Factor w/ 30 levels 
    * Subject numbers from 1 to 30
* `Activity`   
    * Factor w/ 6 levels 
    * Name of the activity under observation
    * "walking", "walking_upstairs",  "walking_downstairs",  "sitting", "standing", "laying"

The following variables are the magnitude of the original three-dimensional signals that was calculated using the Euclidean norm.
* `TimeBodyAccelerationMagnitude-Mean`
    * numeric
    * Average of the body acceleration signal using a low pass Butterworth filter with a corner frequency of 0.3 Hz
* `TimeBodyAccelerationMagnitude-StdDev`
    * numeric
    * Standard deviation of the body acceleration signal using a low pass Butterworth filter with a corner frequency of 0.3 Hz
* TimeGravityAccelerationMagnitude-Mean 
    * numeric
    * Average of the gravity acceleration signal using a low pass Butterworth filter with a corner frequency of 0.3 Hz
* TimeGravityAccelerationMagnitude-StdDev
    * numeric
    * Standard deviation of the gravity acceleration signal using a low pass Butterworth filter with a corner frequency of 0.3 Hz
* TimeBodyAccelerationJerkMagnitude-Mean    
    * numeric
    * Average of the body linear jerk acceleration signal derived in time.
* TimeBodyAccelerationJerkMagnitude-StdDev
    * numeric
    * Standard deviation of the body linear jerk acceleration signal derived in time.
* TimeBodyGyroscopicMagnitude-Mean
    * numeric
    * Average of the angular velocity derived in time.
* TimeBodyGyroscopicMagnitude-StdDev  
    * numeric
    * Standard deviation of the angular velocity derived in time.
* TimeBodyGyroscopicJerkMagnitude-Mean
    * numeric
    * Average of the angular velocity jerk derived in time.
* TimeBodyGyroscopicJerkMagnitude-StdDev
    * numeric
    * Standard deviation of the angular velocity jerk derived in time.

