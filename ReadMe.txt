ReadMe - Getting and Cleaning Data Course Project
=================================================

Author: Jordan Miller-Ziegler
Date: June 26, 2018


This README outlines the codebook, "Code Book.txt" and the analysis script, "run_analysis.R" for the course, "Getting and Cleaning Data" which is part of the Data Science specialization offered by Johns Hopkins University on coursera.org. It roughly describes the transformation of raw data from the UCI HAR dataset into a tidy summary of accelerometer and gyroscope data for thirty (30) subjects performing each of six (6) activities.



Analysis
--------

run_analysis.R is a comprehensive program for loading, cleaning, and saving the data provided with the assignment. It requires that the relevant data folders, "train" and "test", as well as the label files, "features.txt", and "activity_labels.txt" be in the working directory. The file itself, run_analysis.R, must also be in the working directory. 

TO RUN THE ANALYSIS, YOU CAN USE THE COMMAND: 


         source("run_analysis.R") 


If the relevant files are in your working directory, this will create a new file, named "Summarized Data.txt", also in your working directory, with the tidy, summarized data. 

After the analysis is complete, you may view the resulting table with the command:


        View(read.table("Summarized Data.txt", header = TRUE))
        
        
**As per the assignment instructions, the data are produced using row.name = FALSE, thus you need to include header = TRUE when reading the summarized data back in!


Here is an outline of how the raw data becomes "Summarized Data.txt":

Step 0. dplyr: The script requires the 'dplyr' package, and starts by loading it.
Step 1. Reading the data: The program finds and reads in six files, a subject ID vector, an activity ID vector, and a feature data frame, for both the training set and the test set.
Step 2. Subject ID, Activity ID, and the features are combined to leave one training set and one test set. Additionally, variables are renamed with Subject_ID, Activity_ID, and the values from the features.txt features vector.
Step 3. The training and test sets are combined into a full data set.
Step 4. The full data set is cleaned. Variables are renamed to have human-understandable English names. Additionally, as per the assignment, variables containing measures of mean or standard deviation are retained, while all other variables are discarded.
Step 5. The Activity_ID variable is relabeled from the numbers 1 through 6 to descriptive titles matching the activity labels.
Step 6. Using the 'dplyr' package, the trimmed data set is grouped, and then summarized (with the mean) for each activity within each subject.
Step 7. Finally, this tidy summary is written to the text file "Summarized Data.txt" in the working directory.



Code Book
---------

In addition to "run_analysis.R", there is a code book, "Code Book.txt" which accompanies it. The code book provides more detail on the analysis and the variables in the data set. It includes some basic information on decisions made in the analysis, and how the data are summarized. It also provides information on the different options reflected in each variable name. Finally, it (somewhat tediously) lists each variable and includes a (somewhat redundant) description of what that variable measures.