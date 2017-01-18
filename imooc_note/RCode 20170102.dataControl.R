# 3.1 基本方法
x<- 1:10
x[1]
# 数组下标从0开始
x[1:5]

x[x>5]
x>5

x[x>5 & x<7]
x[x<3 | x>7]

y<- 1:4
names(y)<-c("a","b","c","d")

y[2]
y["b"]

# 3.2 构建子集
x<-matrix(1:6,nrow=2,ncol = 3)
x[1,2]
x[2,3]
x[1,]
x[,2]

x[2,c(1,3)]

class(x[1,2])

x[1,2,drop=FALSE]

# 3.3 数据框的子集
x<-data.frame(v1=1:5,v2=6:10,v3=11:15)
x$v3[c(2,4)]<-NA

x[,2]
x[,"v2"]

x[(x$v1<4 & x$v2>=8),]
x[(x$v1<4 | x$v2>=8),]
x[x$v1>2,]
x[which(x$v1>2),]

subset(x,x$v1>2)

# 3.4 列表的子集
x<-list(id=1:4,height=170,gender="male")

x[1]
x["id"]

x[[1]]
x[["id"]]
x$id

x[c(1,3)]

y<-"id"
x[[y]]
# x$y不可实现

x<-list(a=list(1,2,3,4),b=c("Monday","Tuesday"))
x[[1]]
x[[1]][[2]]
x[[1]][2]

x[[c(1,3)]]
x[[c(2,2)]]
# 不完全匹配 partial matching
l<-list(asd=1:10)
l$a
l$asd

l[["a"]]
l[["a",exact=FALSE]]

l<-list(asd=1:10,aaa=2:5)
l[["a"]]
l[["a",exact=FALSE]]
l[["as",exact=FALSE]]

# 3.5 处理缺失值
x<-c(1,NA,2,NA,3)
is.na(x)
x[!is.na(x)]

x<-c(1,NA,2,NA,3)
y<-c("a","b",NA,"c",NA)
z<-complete.cases(x,y)
x[z]
y[z]

library(datasets)
head(airquality)
g<-complete.cases(airquality)
airquality[g,][1:10,]


# 3.6 向量操作化
x<-1:5
y<-6:10
x+y
x-y
x*y
x/y

x<-matrix(1:4,nrow = 2,ncol = 2)
y<-matrix(rep(2,4),nrow = 2,ncol = 2)
x+y
x-y
x*y
x/y
x %*% y


