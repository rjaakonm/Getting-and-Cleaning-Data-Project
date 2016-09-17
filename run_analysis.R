setwd("C:/Users/roope_000/Desktop/RSTUDIO/Coursera/UCI HAR Dataset")

#task 1

#loading datasets
library(plyr)
library(data.table)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

#merging datasets
xDataSet <- rbind(xTrain, xTest)
yDataSet <- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)

#task 2

#Extracting only the measurements on the mean and standard deviation for each measurement
xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(xDataSet_mean_std)
dim(xDataSet_mean_std)

#task 3

#naming the activities in the data set
yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"

#task 4

#labeling the data set with descriptive activity names
names(subjectDataSet) <- "Subject"

#combining all data in one set
Data <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)

#re-naming variables
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#task 5

#creating a second, independent tidy data set with the average of each variable for each activity and each subject
Data2<-aggregate(. ~Subject + Activity, Data, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)