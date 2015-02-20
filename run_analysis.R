# 1.Prepare library and load files
# 1.1 Prepare library
require(plyr)

# 1.2 Load root files
activity_labels_location<-paste("UCI HAR Dataset", "/activity_labels.txt", sep = "")
activity_labels_data<-read.table(activity_labels_location,col.names = c("activity_id", "activity"))

features_location<-paste("UCI HAR Dataset", "/features.txt", sep = "")
features_data<-read.table(features_location, colClasses = c("character"))

# 1.3 Load test files
subject_test_location<-paste("UCI HAR Dataset", "/test/subject_test.txt", sep = "")
subject_test_data<-read.table(subject_test_location)

X_test_location<-paste("UCI HAR Dataset", "/test/X_test.txt", sep = "")
X_test_data<-read.table(X_test_location)
  
y_test_location<-paste("UCI HAR Dataset", "/test/y_test.txt", sep = "")
y_test_data<-read.table(y_test_location)
  
# 1.4 Load train files
subject_train_location<-paste("UCI HAR Dataset", "/train/subject_train.txt", sep = "")
subject_train_data<-read.table(subject_train_location)

X_train_location<-paste("UCI HAR Dataset", "/train/X_train.txt", sep = "")
X_train_data<-read.table(X_train_location)

y_train_location<-paste("UCI HAR Dataset", "/train/y_train.txt", sep = "")
y_train_data<-read.table(y_train_location)


# 2.Merge and filter train and test data
# 2.1 Combine data
test_combined<-cbind(cbind(X_test_data,subject_test_data),y_test_data)
train_combined<-cbind(cbind(X_train_data,subject_train_data),y_train_data)
combined_data<-rbind(test_combined,train_combined)

# 2.2 Label combined data
col_name<-rbind(rbind(features_data,c(562,"Subject")),c(563,"activity_id"))
col_name<-col_name[,2]
names(combined_data)<-col_name

# 2.3 Filter mean and standard deviation
filtered_data<-combined_data[,grepl("mean|std|Subject|activity_id", names(combined_data))]

# 3. Join and clarify col name
# 3.1 Join data
filtered_data<-join(filtered_data,activity_labels_data,by="activity_id",match="first")
filtered_data<-filtered_data[,-1]

# 3.2 Clarify col name
names(filtered_data)<-gsub('\\(|\\)',"",names(filtered_data), perl = TRUE)
names(filtered_data)<-gsub('\\.mean',"-mean",names(filtered_data))
names(filtered_data)<-gsub('\\.std',"-standard_deviation",names(filtered_data))
names(filtered_data)<-gsub('^t',"time.",names(filtered_data))
names(filtered_data)<-gsub('^f',"frequency.",names(filtered_data))
names(filtered_data)<-gsub('Acc',"acceleration",names(filtered_data))
names(filtered_data)<-gsub('Freq\\.',"frequency.",names(filtered_data))
names(filtered_data)<-gsub('Freq$',"frequency",names(filtered_data))
names(filtered_data)<-gsub('GyroJerk',"angular_acceleration",names(filtered_data))
names(filtered_data)<-gsub('Gyro',"angular_velocity",names(filtered_data))
names(filtered_data)<-gsub('Mag',"magnitude",names(filtered_data))

# 4. Create new tidy data set
tidy_data = ddply(filtered_data, c("Subject","activity"), numcolwise(mean))
write.table(tidy_data,row.name=FALSE,file = "tidy_data.txt")
