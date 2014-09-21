setwd("~/Getting and Cleaning Data/Exercicis/CourseProject")

install.packages("data.table")
library(data.table)

# Set data directory
dir <- "./UCI HAR Dataset/"

# Load activity labels
activityLabels <- read.table(paste(dir, "activity_labels.txt", sep=""))[,2]

# Load data column names
features <- read.table(paste(dir, "features.txt", sep=""))[,2]

# Read training set, labels, activity name and subject
training <- read.table(paste(dir, "train/X_train.txt", sep=""), col.names=features)
training[,"ActivityID"] <- read.table(paste(dir, "train/Y_train.txt", sep=""))
# Add a column with the activity name
training[,"Activity"] = activityLabels[training[,"ActivityID"]]
training[,"Subject"] <- read.table(paste(dir, "train/subject_train.txt", sep=""))

# Read test set, labels activity name and subject
test <- read.table(paste(dir, "test/X_test.txt", sep=""), col.names=features)
test[,"ActivityID"] <- read.table(paste(dir, "test/y_test.txt", sep=""))
# Add a column with the activity name
test[,"Activity"] = activityLabels[test[,"ActivityID"]]
test[,"Subject"] <- read.table(paste(dir, "test/subject_test.txt", sep=""))

# Select mean and std headers
meanAndStd <- grepl("mean|std", features)

# Extract only mean and std measurements
trainingFiltered <- training[,meanAndStd]
testFiltered <- test[,meanAndStd]

# Merge the training and test sets
mergedData <- rbind(trainingFiltered, testFiltered)
dt <- data.table(mergedData)
tidy_data<-dt[,lapply(.SD,mean),by="Activity,Subject"]

write.table(tidy_data, file="./tidy_data.txt", row.name=FALSE)
