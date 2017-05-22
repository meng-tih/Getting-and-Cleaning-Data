setwd("C:/Users/PoissonQuiCoule/Documents/Cleaning_assignment/Project")

#library(knitr)
#knit(input = "run_analysis_README.Rmd", output = "README.md")
#knit(input = "run_analysis_CodeBook.Rmd", output = "CodeBook.md")


library(data.table)
path <- getwd()
pathIn <- file.path(path, "UCI HAR Dataset")

#################
## Measurement ##
#################

# 1.Load
dtXTrain <- read.table(file.path(pathIn, "train", "X_train.txt"))
dtXTest  <- read.table(file.path(pathIn, "test" , "X_test.txt" ))

# 2.Merge training and test
dtX      <- rbind(dtXTrain, dtXTest)
rm("dtXTrain", "dtXTest")

# 3.Appropriately labels
columns_name     <- read.table(file.path(pathIn, "features.txt"))[,2]
colnames(dtX)    <- columns_name

# 4.Only the measurements on the mean and standard deviation
selected_columns <- grepl('-(mean|std)\\(',columns_name)
dtX              <- dtX[selected_columns]

colnames(dtX)    <- gsub("mean"    , "Mean"     , colnames(dtX))
colnames(dtX)    <- gsub("std"     , "Std"      , colnames(dtX))
colnames(dtX)    <- gsub("^t"      , "Time"     , colnames(dtX))
colnames(dtX)    <- gsub("^f"      , "Frequency", colnames(dtX))
colnames(dtX)    <- gsub("\\(\\)"  , ""         , colnames(dtX))
colnames(dtX)    <- gsub("-"       , ""         , colnames(dtX))
colnames(dtX)    <- gsub("BodyBody", "Body"     , colnames(dtX))
colnames(dtX)    <- gsub("^"       , "MeanOf"   , colnames(dtX))
colnames(dtX)


################
## Activities ##
################

# 1.Load
dtYTrain <- read.table(file.path(pathIn, "train", "Y_train.txt"))
dtYTest  <- read.table(file.path(pathIn, "test" , "Y_test.txt" ))

# 2.Merge training and test
dtY      <- rbind(dtYTrain, dtYTest)[,1]
rm("dtYTrain", "dtYTest")

#3. Uses descriptive activity names in the data set
labels   <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
dtY      <- labels[dtY]


##############
## Subjects ##
##############
# 1.Load
dtSTrain <- read.table(file.path(pathIn, "train", "subject_train.txt"))
dtSTest  <- read.table(file.path(pathIn, "test" , "subject_test.txt" ))
# 2.Merge
dtS      <- rbind(dtSTrain, dtSTest)[,1]


######################
# Merges everythings #
######################
dtSet <- cbind(Subject = dtS, Activities = dtY, dtX)


library('dplyr')
average_dtSet <- dtSet %>%
        group_by( Subject, Activities) %>%
        summarise_each(funs(mean))

write.table(average_dtSet, row.name = FALSE, file="tidy_data_set.txt")
