library(dplyr)

#Load train data
X_train <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/train/subject_train.txt")

#Load test data
X_test <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/test/subject_test.txt")

#Merge train and test data respectively
train <- cbind(y_train, X_train)
train <- cbind(subject_train, train)
test <- cbind(y_test, X_test)
test <- cbind(subject_test, test)

#Merge train and test data together to form one data set
data <- rbind(train, test)

#Load and isolate the description of the data
features <- read.table("C:/Users/SYSA/Desktop/Coursera Project/UCI HAR Dataset/features.txt")
features <- subset(features, select=V2)

#Transpose the features data and add in the header for the first 2 columns
features <- t(features)
features <- cbind(cbind("Subject", "Activity"), features)

#Add the header of each column, features, to the data
names(data) <- features

#Extract the mean and standard deviation measurements
data <- select(data, contains(c("Subject", "Activity", "mean()", "std()")))

#Substitute numbers in Activity with the actual activity
data$Activity <- sub("1", "WALKING", data$Activity)
data$Activity <- sub("2", "WALKING UPSTAIRS", data$Activity)
data$Activity <- sub("3", "WALKING DOWNSTAIRS", data$Activity)
data$Activity <- sub("4", "SITTING", data$Activity)
data$Activity <- sub("5", "STANDING", data$Activity)
data$Activity <- sub("6", "LAYING", data$Activity)

#Obtain the average of each variable for each activity and subject
new_data <- data %>%
  group_by(Subject, Activity) %>%
  summarize(across(, mean))