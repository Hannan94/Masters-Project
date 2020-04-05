library(readxl)
final_dataset_level_2 <- read_excel("Desktop/final_dataset_level_2 .xlsx")
View(final_dataset_level_2)
data = final_dataset_level_2


#View(data)
#data = as.numeric(data)
#data <- na.omit(data)
#View(data)
#data <- na.omit(data)
data <- lapply(data, as.numeric)
data = as.data.frame(data)
str(data)
train_set <- data[80:299,]
head(train_set)
test_set <-data[1:80,]
#test_set <- test_set[complete.cases(test_set),]
summary(test_set)

head(test_set)
#library(e1071)
#angle_classifier = svm(Angle ~ . , data = train_set, kernel= "linear", cost = 100, scale = TRUE, type = 'C')
#print(angle_classifier)
#plot(angle_classifier, train_set)
library(kernlab)
angle_classifier <- ksvm (Angle ~ . , data = train_set, kernel = "vanilladot", C=100, cross=20, type="C-svc") 
#angle_classifier <- ksvm (angle ~ . , data = train_set, kernel = "rbfdot", scale = FALSE, type = 'C')
angle_classifier
angle_prediction <- predict(angle_classifier, newdata= test_set)
angle_prediction
plot(angle_prediction)
test_set <- test_set[complete.cases(test_set),]

table(angle_prediction, test_set$Angle)
agreement <- angle_prediction == test_set$Angle
plot(agreement)

table(agreement)
prop.table(table(agreement))

