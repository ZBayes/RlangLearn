# 4 基本数据管理

# 创建案例数据框
manager <- c(1,2,3,4,5)
date <- c("10/24/08","10/28/08","10/1/08","10/12/08","5/1/09")
gender <- c("M","F","F","M","F")
age <- c(32,45,25,39,99)
q1 <- c(5,3,3,3,2)
q2 <- c(4,5,5,3,2)
q3 <- c(5,2,5,4,1)
q4 <- c(5,5,5,NA,2)
q5 <- c(5,5,2,NA,1)
leadership <- data.frame(manager,date,gender,age,q1,q2,q3,q4,q5, 
                         stringsAsFactors=FALSE)

# 创建新变量示例
mydata<-data.frame(x1 = c(2, 2, 6, 4),
                   x2 = c(3, 4, 2, 8))
mydata$sumx <- mydata$x1 + mydata$x2
mydata$meanx <- (mydata$x1 + mydata$x2)/2
attach(mydata)
mydata$sumx <- x1 + x2
mydata$meanx <- (x1 + x2)/2
detach(mydata)
mydata <- transform(mydata,
                    sumx = x1 + x2,
                    meanx = (x1 + x2)/2)

# 案例中的变量重编码
leadership$age[leadership$age==99]<-NA

leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 55 &
                    leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 55] <- "Young"

leadership <- within(leadership,{
  agecat <- NA
  agecat[age > 75] <- "Elder"
  agecat[age >= 55 & age <= 75] <- "Middle Aged"
  agecat[age < 55] <- "Young" })

# 变量重命名
names(leadership)[2] <- "testDate"
names(leadership)[6:10] <- c("item1","item2","item3","item4","item5")

library(plyr)
leadership <- rename(leadership,
                     c(manager="managerID", Date="testDate"))

# 缺失值处理
is.na(leadership[, 6:10])

leadership
newdata <- na.omit(leadership)
newdata

# 默认的日期值
mydates <- as.Date(c("2007-06-22", "2004-02-13"))

strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")

myformat<-"%m/%d/%Y"
leadership$date<-as.Date(leadership$date,myformat)

Sys.Date()
date()

today <- Sys.Date()
format(today, format="%B %d %Y")
format(today, format="%A")

startdate <- as.Date("2004-02-13")
enddate <- as.Date("2011-01-22")
days <- enddate - startdate
days

today <- Sys.Date()
dob <- as.Date("1956-10-12")
difftime(today, dob, units="weeks")

strDates <- as.character(dates)

# 数据转换
a <- c(1,2,3)
a
is.numeric(a)
is.vector(a)
a <- as.character(a)
a
is.numeric(a)
is.vector(a)
is.character(a)

# 数据排序
newdata <- leadership[order(leadership$age),]

attach(leadership)
newdata <- leadership[order(gender, age),]
detach(leadership)

attach(leadership)
newdata <-leadership[order(gender, -age),]
detach(leadership)

# 数据合并
total <- merge(dataframeA, dataframeB, by="ID")

# 数据选取
newdata <- leadership[, c(5:9)]

myvars <- c("q1", "q2", "q3", "q4", "q5")
newdata <-leadership[myvars]

myvars <- paste("q", 1:5, sep="")
newdata <- leadership[myvars]

# 数据删除
myvars <- names(leadership) %in% c("q3", "q4") 
leadership[!myvars]

# 选入观测
newdata <- leadership[1:3,]
newdata <- leadership[leadership$gender=="M" &
                        leadership$age > 30,]

attach(leadership)
newdata <- leadership[gender=='M' & age > 30,]
detach(leadership)

startdate <- as.Date("2009-01-01")
enddate <- as.Date("2009-10-31")
newdata <- leadership[which(leadership$date >= startdate &
                              leadership$date <= enddate),]

newdata <- subset(leadership, age >= 35 | age < 24,
                  select=c(q1, q2, q3, q4))
newdata <- subset(leadership, gender=="M" & age > 25,
                  select=gender:q4)

# SQL操作
library(sqldf)
newdf <- sqldf("select * from mtcars where carb=1 order by mpg",
               row.names=TRUE)
newdf
sqldf("select avg(mpg) as avg_mpg, avg(disp) as avg_disp, gear
      from mtcars where cyl in (4, 6) group by gear")