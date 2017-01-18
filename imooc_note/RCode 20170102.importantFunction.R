# lapply
str(lapply)
x<-list(a=1:10,b=c(11,21,31,41,51))
lapply(x,mean)

x<-1:4
lapply(x,runif)
lapply(x,runif,min=0,max=100)

x<-list(a=matrix(1:6,2,3),b=matrix(4:7,2,2))
lapply(x,function(m) m[1,])

#sapply
x<-list(a=1:10,b=c(11,21,31,41,51))
lapply(x,mean)
sapply(x,mean)


# apply
x<-matrix(1:16,4,4)
apply(x, 2, mean)
apply(x,2,sum)
apply(x, 1, mean)
apply(x,1,sum)

rowSums(x)
rowMeans(x)
colSums(x)
colMeans(x)

x<-matrix(rnorm(100),10,10)
apply(x,1,quantile,probs=c(0.25,0.75))

x<-array(rnorm(2*3*4),c(2,3,4))
apply(x,c(1,2),mean)
apply(x,c(1,3),mean)
apply(x,c(2,3),mean)


# mapply
list(rep(1,4),rep(2,3),rep(3,2),rep(4,1))
mapply(rep,1:4,4:1)

s<-function(n,mean,std){
  rnorm(n,mean,std)
}
s(4,0,1)

mapply(s,1:5,5:1,2)
list(s(1,5,2),s(2,4,2),s(3,3,2),s(4,2,2),s(5,1,2))

# tapply
x<-c(rnorm(5),runif(5),rnorm(5,1))
f<-gl(3,5)
tapply(x,f,mean)
tapply(x,f,mean,simplify = FALSE)

# split
x<-c(rnorm(5),runif(5),rnorm(5,1))
f<-gl(3,5)
split(x,f)
lapply(split(x,f),mean)

head(airquality)

s<-split(airquality,airquality$Month)
table(airquality$Month)

lapply(s,function(x){colMeans(x[,c("Ozone","Wind","Temp")])})
sapply(s,function(x){colMeans(x[,c("Ozone","Wind","Temp")])})
sapply(s,function(x){colMeans(x[,c("Ozone","Wind","Temp")],na.rm=TRUE)})

# Sort and Order
x<-data.frame(v=1:5,v2=c(10,7,9,6,8),v3=11:15,v4=c(1,1,2,2,1))
sort(x$v2)
sort(x$v2,decreasing = TRUE)

order(x$v2)

x[order(x$v2),]

x[order(x$v4,x$v2),]
x[order(x$v4,x$v2,decreasing = TRUE),]

# summarize data
head(airquality,10)
tail(airquality)

summary(airquality)
str(airquality)

table(airquality$Month)
table(airquality$Ozone,useNA="ifany")
table(airquality$Month,airquality$Day)

any(is.na(airquality$Ozone))
sum(is.na(airquality$Ozone))

all(airquality$Month<12)

titanic<-as.data.frame(Titanic)
head(titanic)
dim(titanic)

x<-xtabs(Freq~Class+Age,data=titanic)
ftable(x)

object.size(airquality)
print(object.size(airquality),units = "Kb")
