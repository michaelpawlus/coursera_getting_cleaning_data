##read all the data sets

testLabels <- read.table("test/y_test.txt", col.names="label")
testSubjects <- read.table("test/subject_test.txt", col.names="subjectID")
testDataSet <- read.table("test/X_test.txt")
trainLabels <- read.table("train/y_train.txt", col.names="label")
trainSubjects <- read.table("train/subject_train.txt", col.names="subjectID")
trainDataSet <- read.table("train/X_train.txt")

##name columns to pull mean and std dev subset

featureColNames <- read.table("features.txt")
names(trainDataSet) <- featureColNames$V2
names(testDataSet) <- featureColNames$V2

##merge the test and training sets

mergedTestData <- cbind(testSubjects, testLabels, testDataSet)
mergedTrainingData <- cbind(trainSubjects, trainLabels, trainDataSet)
mergedData <- rbind(mergedTestData, mergedTrainingData)

##select the columns with mean() or std()

meanStdDevCols <- grepl("mean\\(\\)", names(mergedData)) |
  grepl("std\\(\\)", names(mergedData))

##ensure that the first two columns are included

meanStdDevCols[1:2] <- TRUE

##create subset of just the mean and std data

msdMergedData <- mergedData[, meanStdDevCols]

##change the activity codes to corresponding names

activityLabels <- read.table("activity_labels.txt")
msdMergedData$label <- activityLabels[msdMergedData$label, 2]

##create the tidy data set with the average of each variable for each activity and each subject

meltedData <- melt(msdMergedData, id=c("subjectID","label"))
tidyData <- dcast(meltedData, subjectID+label ~ variable, mean)

##write the txt file

write.table(tidyData, "tidy_data.txt", row.names=FALSE)
