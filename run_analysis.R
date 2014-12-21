# Course Project - Getting and Cleaning Data 
# 
# NOTE: "Comments" as asked for in the instructions are placed in message() 
#       so that when this file is sourced the comments double as an informative 
#       walkthrough of what is going on  while the script runs :) 
# 


 
 # 
 require("reshape2") 
 

 
 #"Ensuring the data path exists..."
 # 
 dataPath <- "./data" 
 if (!file.exists(dataPath)) { dir.create(dataPath) } 
 

 #download dataset 
 fileName <- "Dataset.zip" 
 filePath <- paste(dataPath,fileName,sep="/") 
 if (!file.exists(filePath)) {  
     fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
     message("Downloading the data set archive...") 
     download.file(url=fileURL,destfile=filePath,method="curl") 
 } 
 

 
 #Timestamping the data set archive file with when it wad downloaded
  
 fileConn <- file(paste(filePath,".timestamp",sep="")) 
 writeLines(date(), fileConn) 
 close(fileConn) 
 

 
 #Extracting the data set files from the archive
 # 
 unzip(zipfile=filePath, exdir=dataPath) 
 

 # Set the data path of the extracted archive files... 
 dataSetPath <- paste(dataSetPath,"UCI HAR Dataset",sep="/") 
 

 
 #Reading training & test column files 
 # 
 xTrain <- read.table(file=paste(dataSetPath,"/train/","X_train.txt",sep=""),header=FALSE) 
 xTest  <- read.table(file=paste(dataSetPath,"/test/","X_test.txt",sep=""),header=FALSE) 
 yTrain <- read.table(file=paste(dataSetPath,"/train/","y_train.txt",sep=""),header=FALSE) 
 yTest  <- read.table(file=paste(dataSetPath,"/test/","y_test.txt",sep=""),header=FALSE) 
 sTrain <- read.table(file=paste(dataSetPath,"/train/","subject_train.txt",sep=""),header=FALSE) 
 sTest  <- read.table(file=paste(dataSetPath,"/test/","subject_test.txt",sep=""),header=FALSE) 
 
 features <- read.table(file=paste(dataSetPath,"features.txt",sep="/"),header=FALSE) 
 names(xTrain) <- features[,2] 
 names(xTest)  <- features[,2] 
 names(yTrain) <- "Class_Label" 
 names(yTest)  <- "Class_Label" 
 names(sTest)  <- "SubjectID" 
 names(sTrain) <- "SubjectID" 
 

 
 #Merging (appending) the training and test data set 
 xData <- rbind(xTrain, xTest) 
 yData <- rbind(yTrain, yTest) 
 sData <- rbind(sTrain, sTest) 
 data <- cbind(xData, yData, sData) 
 


#Extracting measurements on mean & standard deviation
 
 matchingCols <- grep("mean|std|Class|Subject", names(data)) 
 data <- data[,matchingCols] 

 activityNames <- read.table(file=paste(dataSetPath,"activity_labels.txt",sep="/"),header=FALSE) 
 names(activityNames) <- c("Class_Label", "Class_Name") 
 data <- merge(x=data, y=activityNames, by.x="Class_Label", by.y="Class_Label" ) 
 
 # set column names
 names(data) <- gsub(pattern="[()]", replacement="", names(data)) 
 

 #comment v 
 message("and by replacing hyphen's with underscores in the column names...") 
 #  
 names(data) <- gsub(pattern="[-]", replacement="_", names(data)) 
 

#Removing columns used only for tidying up the data set
 # 
 data <- data[,!(names(data) %in% c("Class_Label"))] 
 

 
 #Melting the data set
 # 
 meltdataset <- melt(data=data, id=c("SubjectID", "Class_Name")) 
 

 
 tidyData <- dcast(data=meltdataset, SubjectID + Class_Name ~ variable, mean) 
 

 # write data 
 tidyFilePath <- paste(dataPath,"TidyDataSet.txt",sep="/") 
 write.csv(tidyData, file=tidyFilePath, row.names=FALSE) 
 
) 

