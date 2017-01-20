# 5 高级数据分析
# 5.1 案例数据建立
Student <- c("John Davis","Angela Williams","Bullwinkle Moose",
             "David Jones","Janice Markhammer",
             "Cheryl Cushing","Reuven Ytzrhak",
             "Greg Knox","Joel England","Mary Rayburn")
math <- c(502, 600, 412, 358, 495, 512, 410, 625, 573, 522)
science <- c(95, 99, 80, 82, 75, 85, 80, 95, 89, 86)
english <- c(25, 22, 18, 15, 20, 28, 15, 30, 27, 18)

roster <- data.frame(Student, math, science, english, 
                     stringsAsFactors=FALSE)

# 均值与标准差的计算
x <- c(1, 2, 3, 4, 5, 6, 7, 8)
mean(x)
sd(x)

n <- length(x)
meanx <- sum(x)/n
css <- sum((x - meanx)**2)            
sdx <- sqrt(css / (n-1))
meanx
sdx

# 随机数种子
runif(5)
runif(5)

set.seed(1234)                                                     
runif(5)
set.seed(1234)                                                      
runif(5)

# MASS生成多元正态数据
library(MASS)
options(digits = 3)
set.seed(1234)

mean <- c(230.7, 146.7, 3.6)                                           
sigma <- matrix( c(15360.8, 6721.2, -47.1,                              
                   6721.2, 4700.9, -16.5,
                   -47.1,  -16.5,   0.3), nrow=3, ncol=3)

mydata <- mvrnorm(500, mean, sigma)                                     
mydata <- as.data.frame(mydata)                                         
names(mydata) <- c("y", "x1", "x2") 

dim(mydata)                                                             
head(mydata, n=10)

# 函数运用于数据对象
a <- 5
sqrt(a)
b <- c(1.243, 5.654, 2.99)
round(b)
c <- matrix(runif(12), nrow=3)
c
log(c)
mean(c)

# apply函数
mydata <- matrix(rnorm(30), nrow=6)
mydata
apply(mydata, 1, mean)     
apply(mydata, 2, mean) 
apply(mydata, 2, mean, trim=.2) 

# 解决5.1的问题
# 步骤1
options(digits=2)
Student <- c("John Davis", "Angela Williams", "Bullwinkle Moose",
             "David Jones", "Janice Markhammer", "Cheryl Cushing",
             "Reuven Ytzrhak", "Greg Knox", "Joel England",
             "Mary Rayburn")
Math <- c(502, 600, 412, 358, 495, 512, 410, 625, 573, 522)
Science <- c(95, 99, 80, 82, 75, 85, 80, 95, 89, 86)
English <- c(25, 22, 18, 15, 20, 28, 15, 30, 27, 18)
roster <- data.frame(Student, Math, Science, English,
                     stringsAsFactors=FALSE)
# 步骤2
z <- scale(roster[,2:4])

# 步骤3
score <- apply(z, 1, mean)
roster <- cbind(roster, score)

# 步骤4
y <- quantile(score, c(.8,.6,.4,.2))

# 步骤5
roster$grade[score >= y[1]] <- "A"
roster$grade[score < y[1] & score >= y[2]] <- "B"
roster$grade[score < y[2] & score >= y[3]] <- "C"
roster$grade[score < y[3] & score >= y[4]] <- "D"
roster$grade[score < y[4]] <- "F"

# 步骤6
name <- strsplit((roster$Student), " ")

# 步骤7
Lastname <- sapply(name, "[", 2)
Firstname <- sapply(name, "[", 1)
roster <- cbind(Firstname,Lastname, roster[,-1])

# 步骤8
roster <- roster[order(Lastname,Firstname),]

# 步骤9
roster

# for循环
for (i in 1:10){
  print("Hello")
  print("world")
}

# while循环
i<-0
while(i<10){
  print("Hello")
  print("world")
  print(i)
  i<-i+1
}

# if-else
i<-10
if(i==10) print("i is 10") else print("i is not 10")
if(i!=10) print("i is not 10") else print("i is 10")

# ifelse
i<-10
ifelse(i==10,print("i is 10"),print("i is not 10"))
a<-ifelse(i==10,TRUE,FALSE)
a

# switch
feelings <- c("sad", "afraid")
for (i in feelings)
  print(
    switch(i,
           happy  = "I am glad you are happy",
           afraid = "There is nothing to fear",
           sad    = "Cheer up",
           angry  = "Calm down now"
    )
  )

# 用户自编程序
mystats <- function(x, parametric=TRUE, print=FALSE) {
  if (parametric) {
    center <- mean(x); spread <- sd(x)
  } else {
    center <- median(x); spread <- mad(x)
  }
  if (print & parametric) {
    cat("Mean=", center, "\n", "SD=", spread, "\n")
  } else if (print & !parametric) {
    cat("Median=", center, "\n", "MAD=", spread, "\n")
  }
  result <- list(center=center, spread=spread)
  return(result)
}

# 测试用户自编程序
set.seed(1234)
x <- rnorm(500) 
y <- mystats(x)
y <- mystats(x, parametric=FALSE, print=TRUE)

# 数据转置
cars <- mtcars[1:5, 1:4]      
cars
t(cars)

# 数据整合
options(digits=3)
attach(mtcars)
aggdata <-aggregate(mtcars, by=list(cyl,gear), 
                    FUN=mean, na.rm=TRUE)
aggdata

# reshape2包
# 数据
mydata <- read.table(header=TRUE, sep=" ", text="
ID Time X1 X2
1 1 5 6
1 2 3 5
2 1 6 1
2 2 2 4
")

# 数据融合
md <- melt(mydata, id=c("ID", "Time"))

# 数据重铸
dcast(md, ID~variable, mean)
dcast(md, Time~variable, mean)
dcast(md, ID~Time, mean)

dcast(md, ID+Time~variable)
dcast(md, ID+variable~Time)
dcast(md, ID~variable+Time)