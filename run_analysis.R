
library(plyr)


# headings
xTrain = read.table("./train/X_train.txt")
yTrain = read.table("./train/y_train.txt")
subjectTrain = read.table("./train/subject_train.txt")

# test set
xTest = read.table("./test/X_test.txt")
yTest = read.table("./test/y_test.txt")
subjectTest = read.table("./test/subject_test.txt")

# format variable names
featuresdata = read.table("./features.txt")
headings = featuresdata$V2

# transfer headings to data set
colnames(xTrain) = headings
colnames(xTest) = headings

# change V1 variable to activity
yTest <- rename(yTest, c(V1="activity"))
yTrain <- rename(yTrain, c(V1="activity"))

activitydata  = read.table("./activity_labels.txt")
activityLabels = tolower(levels(activitydata$V2))

yTrain$activity = factor(
  yTrain$activity, 
  labels = activityLabels
)

yTest$activity = factor(
  yTest$activity, 
  labels = activityLabels
)

subjectTrain <- rename(subjectTrain, c(V1="subjectid"))
subjectTest <- rename(subjectTest, c(V1="subjectid"))

# combine x, y, subject
train = cbind(xTrain, subjectTrain, yTrain)
test = cbind(xTest, subjectTest, yTest)

completeData = rbind(train, test)

pattern = "mean|std|subjectid|activity"
tidyData = completeData[,grep(pattern , names(completeData), value=TRUE)]

# remove parentheses, dash, commas, ect.
cleanNames = gsub("\\(|\\)|-|,", "", names(tidyData))
names(tidyData) <- tolower(cleanNames)

# summarize data
result = ddply(tidyData, .(activity, subjectid), numcolwise(mean))

# write file to output
write.table(result, file="tidydata.txt", sep = "\t", append=F)
