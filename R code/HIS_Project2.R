data <- read.csv("Desktop/dataset_First_comp_3.csv")
#data <- read.csv("Desktop/dataset_r2_comp10.csv")
data <- data.frame(data)
#data[is.na(data)] <- 0
View(data)
str(data)


colnames(data) <- c("angle", "mean1","mean2","mean3", "max1", "max2", "max3", "min1", "min2","min3", "peak1", 
                   "peak2", "peak3", "std1", "std2", "std3", "var1", "var2", "var3", "skew1","skew2", "skew3",
                   "kurt1", "kurt2", "kurt3", "scm1","scm2","scm3", "tcm1","tcm2","tcm3")
View(data)
par(mfrow=c(1,1))
plot(data$mean1, data$angle, main = "Angle vs Mean", xlab = "Mean", ylab = "Angle")
plot(data$std1, data$angle, main = "Angle vs Standard Deviation", xlab = "STD", ylab = "Angle")
plot(data$max1, data$angle, main = "Angle vs Maximum Values", xlab = "Max", ylab = "Angle")
plot(data$var1, data$angle, main = "Angle vs Variance", xlab = "Variance", ylab = "Angle")





plot(x, sin(x),
     main="The Sine Function",
     ylab="sin(x)")

#data = subset(data, select = -c(,peak1,peak2,peak3) )
#data <- subset(data, select = -c(X0,X0.3,X0.4))
#data <- subset(data, select = -c(mean1, max1, min1, peak1, std1, var1, skew1, kurt1, scm1, tcm1))

plot()



#str(data)
#set.seed(42)
#rows <- sample(nrow(data))
#data <- data[rows, ]
#View(data)
#train_set <- data[1:239,]



library(caTools)
set.seed(123)
split = sample.split(data$X30, SplitRatio = 0.75)
train_set = subset(data, split == TRUE)
test_set = subset(data, split == FALSE)

#train_set[-1] = scale(train_set[-1])
#test_set[-1] = scale(test_set[-1])


library(e1071)
angle_classifier = svm(X30 ~ . , data = train_set, kernel= "radial", scale = TRUE, type = 'C-classification')
#svm_tune <- tune(svm, angle ~ .,data = data, kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
#print(svm_tune)
#library(kernlab)
#angle_classifier <- ksvm (X30 ~ . , data = train_set, kernel = "rbfdot", cost=0.1, scale= TRUE, type="C-svc") 

summary(angle_classifier)
angle_prediction <- predict(angle_classifier, newdata= test_set)
angle_prediction
plot(angle_prediction)
#table(angle_prediction, test_set$angle)
table(test_set$X30, angle_prediction)
agreement <- angle_prediction == test_set$X30
table(agreement)
prop.table(table(agreement))


