library(plyr)

READ AND COMPILE ALL DATA
features <- read.table("features.txt")

activity_labels <- read.table()

filtered_fields <- grep(".mean.*|.std.*", features[, 2])
filtered_fields_names <- as.character(features[filtered_fields, 2])

train_set <- cbind(
        read.table("train/subject_train.txt"),
        read.table("train/Y_train.txt"),
        read.table("train/X_train.txt")[filtered_fields])

test_set <- cbind(
        read.table("test/subject_test.txt"),
        read.table("test/Y_test.txt"),
        read.table("test/X_test.txt")[filtered_fields])

allData <- rbind(train_set, test_set)


colnames(allData) <- c("subject", "activity", filtered_fields_names)

allData <- merge(allData, activity_labels, by.x="activity", by.y="V1")
allData <- rename(allData, replace = c("V2" = "activity"))

head(allData)

CREATE TIDY SET
tidy_data <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy.txt", row.name=FALSE)
