# VECTOR
# 生成指定长度的空向量
x<- vector("character", length=10)
# 更加简单地方式创建向量
x1<-1:4
# 使用c函数
x2<-c(1,2,3,4)
# 不同类型会强制转换
x3<-c(TRUE,10,"A")

# 强制转换
x4<-c("a","b")
as.numeric(x4) # NAs为缺失值

names(x1)<-c("a","b","c","d")




# Matrix
x1<-matrix(nrow=3,ncol=2) # 先列后行
x2<-matrix(1:6,nrow=3,ncol=2)

# 查看矩阵维度
dim(x1)

# 查看有哪些属性
attributes(x1)

# 用向量的方式创建矩阵
y1<-1:6
dimy(y1)<-c(2,3)

#矩阵拼接
y2<-matrix(1:6,nrow=3,ncol=2)
rbind(y1,y2)
cbind(y1,y2)

# Array
x<-array(1:24,dim=c(4,6))
x1<-array(1:24,dim=c(2,3,4))



# List
l<-list("a",2,"10L",3+4i,TRUE)
l2<-list(a=1,b=2,c=3)
l3<-list(c(1,2,3),c(4,5,6,7))

x<-matrix(1:6,nrow = 2,ncol = 3)
dimnames(x)<-list(c("a","b"),c("c","d","e"))

# Factor
# 整数向量+标签
x<-factor(c("female","female","male","male","female"))
y<-factor(c("female","female","male","male","female"),levels = c("female","male"))

table(x)
table(y)

unclass(x)
class(unclass(x))

# Missing Value
x<-c(1,NA,2,NA,3)
is.na(x)
is.nan(x)

x<-c(1,NaN,2,NaN,3)
is.na(x)
is.nan(x)

# Data Frame
df<-data.frame(id=c(1,2,3,4),name=c("a","b","c","d"),sex=c(TRUE,TRUE,FALSE,FALSE))
nrow(df)
ncol(df)

df2<-data.frame(id=c(1,2,3,4),name=c("a","b","c","d"),sex=c(TRUE,TRUE,FALSE,FALSE))
data.matrix(df2)

# Date & Time
x<-data()
x2<-Sys.Date()
x3<-as.Date("2015-01-01")

weekdays(x3)
months(x3)
quarters(x3)
julian(x3)

x4<-as.Date("2016-01-01")

as.numeric(x4-x3)

x<-Sys.time()
class(x)

p1<-as.POSIXlt(x)
p2<-as.POSIXct(x)

names(unclass(p1))

p1$sec

x1<-"Jan 1, 2015 01:01"
strptime(x1, "%B %d, %Y %H:%M")

