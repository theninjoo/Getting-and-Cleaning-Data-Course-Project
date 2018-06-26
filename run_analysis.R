### Getting and Cleaning Data Course Project
### Author: Jordan Miller-Ziegler
### Date: June 26, 2018

### This script, run_analysis.R, creates a tidy data set, according to the 
### requirements laid out in the assignment. The tidied data set contains
### 180 rows (30 subjects crossed with 6 activities), and 62 measures of
### mean or standard deviation of accelerometer/gyroscope readings.
### Each step is annotated here, and described in the ReadMe.txt file

# Step 0.
# This script should only require the 'dplyr' package.
library(dplyr)

# Step 1.
# The first step is to load the data. Requires 'train' and 'test' folders
# to be present in the working directory.
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")

subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

# Step 2.
# Next, tidy variable names are assigned to the ID variables.
# This will allow easier binding with rbind in a few steps.
names(subject_train)[1] <- "Subject_ID"
names(y_train) <- "Activity_ID"
names(subject_test)[1] <- "Subject_ID"
names(y_test) <- "Activity_ID"

# The supplied feature vector can be used to give the feature variables
# names which are not particularly tidy
features <- read.table("features.txt")

# And these are then applied to both the train and test sets for easy rbinding
names(X_train) <- as.character(features[,2])
names(X_test) <- as.character(features[,2])

# The subject ID, Activity labels, and accelerometer/gyroscope data are
# bound together to create full training and test sets.
train <- cbind(subject_train,y_train,X_train)
test <- cbind(subject_test,y_test,X_test)

# Step 3. 
# And, at long last, these are combined to create a full data set.
full_data_set <- rbind(train,test)

# Step 4. 
# This step removes dashes, parentheses, periods, and commas from the variable names
# While not necessary, this step allowed me to practice using gsub to create
# tidier variable names, as you will see in a few steps.
names(full_data_set) <- gsub("-|\\(|\\)|\\.|\\,","",names(full_data_set))

# Here I isolate only those variable names containing "mean" or "std"
# and trim the data set to only include those variables
mean_sd <- grep("mean|std",names(full_data_set))
trimmed_data_set <- full_data_set[,c(1,2,mean_sd)]

# Though, again, not necessary, here I trim the data some more to eliminate
# variables which measured "meanFreq" rather than the mean, and I also removed the
# variables containing the word "Body" twice, as I could not for the life of me figure out what
# these measured. They didn't seem necessary for the sake of this assignment.

meanFreq_indices <- grep("meanFreq",names(trimmed_data_set))
trimmed_data_set <- trimmed_data_set[,-meanFreq_indices]
BodyBody_indices <- grep("BodyBody",names(trimmed_data_set))
trimmed_data_set <- trimmed_data_set[,-BodyBody_indices]

# Fun with gsub! In this step, I have painstakingly changed all the variable names
# To be meaningful English phrases. See details in the Code Book.
better_names <- gsub("^t","",names(trimmed_data_set))
better_names <- gsub("^f","Fourier_transformed_",better_names)
better_names <- gsub("[Bb]odyAccmean","Mean_bodily_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyAccstd","Standard_deviation_of_bodily_accelerometer_reading",better_names)
better_names <- gsub("[Gg]ravityAccmean","Mean_gravitational_accelerometer_reading",better_names)
better_names <- gsub("[Gg]ravityAccstd","Standard_deviation_of_gravitational_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyAccJerkmean","Mean_bodily_jerk_from_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyAccJerkstd","Standard_deviation_of_bodily_jerk_from_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyGyromean","Mean_bodily_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyGyrostd","Standard_deviation_of_bodily_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyGyroJerkmean","Mean_bodily_jerk_from_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyGyroJerkstd","Standard_deviation_of_bodily_jerk_from_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyAccMagmean","Mean_magnitude_of_bodily_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyAccMagstd","Standard_deviation_of_magnitude_of_bodily_accelerometer_reading",better_names)
better_names <- gsub("[Gg]ravityAccMagmean","Mean_magnitude_of_gravitational_accelerometer_reading",better_names)
better_names <- gsub("[Gg]ravityAccMagstd","Standard_deviation_of_magnitude_of_gravitational_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyAccJerkMagmean","Mean_magnitude_of_jerk_from_bodily_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyAccJerkMagstd","Standard_deviation_of_magnitude_of_jerk_from_bodily_accelerometer_reading",better_names)
better_names <- gsub("[Bb]odyGyroMagmean","Mean_magnitude_of_bodily_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyGyroMagstd","Standard_deviation_of_magnitude_of_bodily_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyGyroJerkMagmean","Mean_magnitude_of_jerk_from_bodily_gyroscope_reading",better_names)
better_names <- gsub("[Bb]odyGyroJerkMagstd","Standard_deviation_of_magnitude_of_jerk_from_bodily_gyroscope_reading",better_names)
better_names <- gsub("X", "_in_the_X_direction", better_names)
better_names <- gsub("Y", "_in_the_Y_direction", better_names)
better_names <- gsub("Z", "_in_the_Z_direction", better_names)
better_names <- gsub("_M","_m",better_names)
better_names <- gsub("_S","_s",better_names)
names(trimmed_data_set) <- better_names

# Step 5.
# Here, the Activity ID variable is changed to a factor, and then the values
# are changed from numbers to descriptive labels.
trimmed_data_set$Activity_ID <- as.factor(trimmed_data_set$Activity_ID)
activity_labels <- (c("Walking", "Walking up stairs", "Walking down stairs", "Sitting", "Standing", "Laying"))
levels(trimmed_data_set$Activity_ID) <- activity_labels

# Step 6.
# I use the grouped_by and summarise_all functions from the 'dplyr' package to 
# create the second tiny data set called for in the assignment
# First the data set is converted to a tibble.
trimmed_df <- tbl_df(trimmed_data_set)

# Then the data are grouped by both Subject ID and Activity ID
grouped_df <- group_by(trimmed_df,Subject_ID,Activity_ID)

# A summary is produced showing the mean of each variable for each group
summary_df <- summarise_all(grouped_df, mean)

# Step 7.
# To facilitate writing the final table, the summary table is converted back to a data frame
summary_data_frame <- as.data.frame(summary_df)

# And, voila! The final summarized, tidy data are produced in a table called "Summarized Data.txt"
write.table(summary_data_frame, file = "Summarized Data.txt", row.name = FALSE)
