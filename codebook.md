# Codebook

## Original Data

## Data Processing
The raw dataset was processed using `run_analysis.Rmd`. All steps are documented within the script and can be reviewed in the `run_analysis.md` or `run_analysis.html` files which includes the code, documentation and results.

The above mentioned dataset contained a training and test sets. These 2 data sets were combined. The subject and activity label were also added.  Only those features representing the mean or standard deviation of a measurement were retained.  These features were then averaged for each (`subject`, `activity`) pair.

## Tidy dataset variable description