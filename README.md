# Getting and cleaning data course project

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

#### Post 1.
The consensus for all previous groups is that it was the information you created a mean for by subject/activity as this is the only data the step by step characterises as tidy. To go through it:

Merges the training and the test sets to create one data set.
-Combine the data together

Extracts only the measurements on the mean and standard deviation for each measurement. 
-Find the relevant columns and use them

Uses descriptive activity names to name the activities in the data set
-Rename the numeric activity labels with names

Appropriately labels the data set with descriptive activity names. 
- Horrible wording that should get changed in the next run, but fix the column labels to describe what the column represents

Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
-Create your summary data

There is actually no tidy data set specified before this last step. I agree most people will be creating a new data set for stage 2-4, but you could do those steps operating on the original data (for instance deleting the columns where the name is not relevant).



### From the project instructions:

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project.

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
