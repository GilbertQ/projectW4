library(dplyr)

filename <- "dataset.zip"

if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL,filename)
}

if (!dir.exists("UCI HAR Dataset")){
    unzip(filename)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged_Data <- cbind(subject, y, x)

neat_Data <- merged_Data %>% select(subject, code, contains("mean"), contains("std"))

neat_Data$code <- activities[neat_Data$code,2]

names(neat_Data)[2] = "Activity"
names(neat_Data)<-gsub("Acc", "Accelerometer", names(neat_Data))
names(neat_Data)<-gsub("Gyro", "Gyroscope", names(neat_Data))
names(neat_Data)<-gsub("BodyBody", "Body", names(neat_Data))
names(neat_Data)<-gsub("Mag", "Magnitude", names(neat_Data))
names(neat_Data)<-gsub("^t", "Time", names(neat_Data))
names(neat_Data)<-gsub("^f", "Frequency", names(neat_Data))
names(neat_Data)<-gsub("tBody", "TimeBody", names(neat_Data))
names(neat_Data)<-gsub("-mean()", "Mean", names(neat_Data), ignore.case = TRUE)
names(neat_Data)<-gsub("-std()", "STD", names(neat_Data), ignore.case = TRUE)
names(neat_Data)<-gsub("-freq()", "Frequency", names(neat_Data), ignore.case = TRUE)
names(neat_Data)<-gsub("angle", "Angle", names(neat_Data))
names(neat_Data)<-gsub("gravity", "Gravity", names(neat_Data))

secondData <- neat_Data %>%
group_by(subject, Activity) %>%
summarise_all(funs(mean))
write.table(secondData, "secondData.txt", row.name=FALSE)