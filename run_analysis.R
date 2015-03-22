# @Dated: 03/17/2015
# @Author: Chandra Mohan Bhatt
# Objective of this R script is to achieve following:
# 	1.	Merges the training and the test sets to create one data set.
#     2.    Extracts only the measurements on the mean and standard deviation for each measurement. 
#     3.	  Uses descriptive activity names to name the activities in the data set
#     4.    Appropriately labels the data set with descriptive variable names. 
#     5.    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Downloaded the dataset and made it avaiable under ./dataProjects directory on my mac
dirPath <- file.path("./dataProject" , "UCI HAR Dataset")

#Reading all the files under UCI HAR Dataset
files<-list.files(dirPath, recursive=TRUE)

#checking the list of files
# head(files)

#Creating data frames for individual data sets
ActivityTestData  <- read.table(file.path(dirPath, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrainData <- read.table(file.path(dirPath, "train", "Y_train.txt"),header = FALSE)
SubjectTrainData <- read.table(file.path(dirPath, "train", "subject_train.txt"),header = FALSE)
SubjectTestData  <- read.table(file.path(dirPath, "test" , "subject_test.txt"),header = FALSE)
FeaturesTestData  <- read.table(file.path(dirPath, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrainData <- read.table(file.path(dirPath, "train", "X_train.txt"),header = FALSE)

# Here I concatenate training and testing datasets
dataSubject <- rbind(SubjectTrainData,SubjectTestData)
dataActivity<- rbind(ActivityTrainData, ActivityTestData)
dataFeatures<- rbind(FeaturesTrainData, FeaturesTestData)

# Setting the columns names as appropriate
names(dataSubject)<-c("Subject")
names(dataActivity)<- c("Activity")

# Reading the featue names from the features.txt
dataFeaturesNames <- read.table(file.path(dirPath, "features.txt"),head=FALSE)

#Setting the names of dataFeatures that are fetched above from the features file
names(dataFeatures)<- dataFeaturesNames$V2

# Joining the dataSubject and dataActivity columns
Data <- cbind(dataSubject, dataActivity,dataFeatures)

# Filter the data features and only fetch by mean and standard deviations as required
subsetdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subsetdataFeaturesNames), "Subject", "Activity" )
Data<-subset(Data,select=selectedNames)

# Just check the data
str(Data)
head(Data,10)

activityLabels <- read.table(file.path(dirPath, "activity_labels.txt"),header = FALSE)

# Substitution of activity IDs with their literal names
ID = 1
for (ActivityLabel in activityLabels$V2) {
Data$Activity <- gsub(ID, ActivityLabel, Data$Activity)
ID <- ID + 1
}


# Setting appropriate names as required 

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#Loading plyr package

library(plyr);

# Getting average of each variable for each activity and each subject.
Data2<-aggregate(. ~Subject + Activity, Data, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]

# Writing final dataset to file
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
