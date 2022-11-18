# Create directory:
if(!file.exists("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/")){
  dir.create("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/")
}

# Download zip File:
url_file <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/project_file_dataset.zip")){
  download.file(url_file,"C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/project_file_dataset.zip")
}

# Unzip file:
if(!file.exists("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/project_file_dataset.zip/UCI HAR Dataset")){
  unzip(zipfile = "C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/project_file_dataset.zip")
}

# List the files:
path <- file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/", "C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/")
files<- list.files(path,recursive = TRUE)
# Labels:
labelTrain <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "train", "y_train.txt"), header = FALSE)
labelTest  <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "test" , "y_test.txt" ), header = FALSE)
#Subjects::
subTrain <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "train", "subject_train.txt"), header = FALSE)
subTest  <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "test" , "subject_test.txt"), header = FALSE)

#Sets
setTrain <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "train", "X_train.txt"), header = FALSE)
setTest  <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "test" , "X_test.txt" ), header = FALSE)
# Merging Data:
#Making rows
rSub <- rbind(subTrain, subTest)
rLabel<- rbind(labelTrain, labelTest)
rSet<- rbind(setTrain, setTest)
#Variable Names
names(rSub)<-c("subject")
names(rLabel)<- c("activity")
rSetNames <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "features.txt"), head=FALSE)
names(rSet)<- rSetNames$V2
#Merge Columns
dataCombine <- cbind(rSub, rLabel)
merge <- cbind(rSet, dataCombine)
#Mean and StandardDev
subrSetNames<-rSetNames$V2[grep("mean\\(\\)|std\\(\\)", rSetNames$V2)]
selectedNames<-c(as.character(subrSetNames), "subject", "activity" )
merge<-subset(merge,select=selectedNames)
#Read in the Activity Labels document
activityLabels <- read.table(file.path("C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/UCI HAR Dataset/", "activity_labels.txt"),header = FALSE)
merge$activity<-factor(merge$activity,labels=activityLabels[,2])
#Labeling the Merged Dataset
names(merge)<-gsub("^t", "time", names(merge))
names(merge)<-gsub("^f", "frequency", names(merge))
names(merge)<-gsub("Gyro", "Gyroscope", names(merge))
names(merge)<-gsub("Acc", "Accelerometer", names(merge))
names(merge)<-gsub("BodyBody", "Body", names(merge))
names(merge)<-gsub("Mag", "Magnitude", names(merge))
#Making the Tidy Dataset (newData) and writing it to a text file
newData<-aggregate(. ~subject + activity, merge, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "C:/Users/KHAWLA/Downloads/COURSERA_PROJECTS/week_4/tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')
