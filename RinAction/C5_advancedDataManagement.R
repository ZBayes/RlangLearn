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