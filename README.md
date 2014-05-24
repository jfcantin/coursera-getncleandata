# Getting and cleaning data course project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

### Project files description
Readme.md - this file.
codebook.md : Descrition of the variables and the data. Transformations or work that you performed to clean up the data called CodeBook.md. 
run_analysis.Rmd : Main code file with all transformation and clean up operations documented.
run_analysis.md : Knitted file including the code, the documentation and results.
run_analysis.html : Knitted file including the code, the documentation and results 
Same content as run_analysis.md but in html format.
UCIDataReader.R : Helper function to download and read the UCI project data.
tidyData.txt : Tidy dataset resulting from run_analysis.Rmd

### How to rerun the analysis
The analysis can be reproduced by sourcing the run_analysis.Rmd file.
The run_analysis.Rmd file will the source all required files including UCIDataReader.R. 
The run_analysis.Rmd file can also be re-knitted using knitr.

The original data for the project is located here: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activ    and each subject. 

### From Forum:

#### Post 0.
he standard interpretation, is

Combine all the data
Reduce the columns to those involving mean and sd
Turn the activity numbers into words
Fix the variable names 
Create and save a version with an average of each variable for each activity and each subject. 

### From the project instructions:


You will be required to submit:  
1. a tidy data set as described below, 
2. a link to a Github repository with your script for performing the analysis, and 
3. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
4. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Good luck!
