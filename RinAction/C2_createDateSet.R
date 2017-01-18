# 2 创建数据集
# 2.2 数据结构
# 向量
a<- c(1,2,3,4)
b<- c("one","two","three","four")
c<- c(TRUE,TRUE,FALSE,FALSE)
a[3]
a[c(1,4)]
a[2:4]


# 矩阵
y<-matrix(1:20,nrow = 5,ncol = 4)
y
cells<-c(1,26,24,68)
rnames<-c("R1","R2")
cnames<-c("C1","C2")
mymatrix1<-matrix(cells,nrow=2,ncol=2,byrow=TRUE,dimnames=list(rnames,cnames))
mymatrix1
mymatrix2<-matrix(cells,nrow=2,ncol=2,byrow=FALSE,dimnames=list(rnames,cnames))
mymatrix2

# 数组
dim1<-c("A1","A2")
dim2<-c("B1","B2","B3")
dim3<-c("C1","C2","C3","C4")
z<-array(1:24, c(2,3,4), dimnames = list(dim1,dim2,dim3))
z

# 数据框
patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabetes<-c("Type1","Type2","Type3","Type1")
status<-c("Poor","Improved","Excellent","Poor")
patientdata<-data.frame(patientID,age,diabetes,status)
patientdata

patientdata[1:2]
patientdata[c("diabetes","status")]
patientdata$age

table(patientdata$diabetes,patientdata$status)

# detach和attach
attach(patientdata)
  table(diabetes,status)
detach(patientdata)

# with
with(patientdata,{table(diabetes,status)})
with(patientdata,{
  pa1<-diabetes
  pa2<<-diabetes
})
pa1
pa2

# 因子
patientdata<-data.frame(patientID,age,diabetes,status,row.names = patientID)

status<-factor(status,order=TRUE)

status<-factor(status,order=TRUE,levels = c("Poor","Improved","Excellent"))

patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabetes<-c("Type1","Type2","Type3","Type1")
status<-c("Poor","Improved","Excellent","Poor")
diabetes<-factor(diabetes)
status<-factor(status,order=TRUE,levels = c("Poor","Improved","Excellent"))
patientdata<-data.frame(patientID,age,diabetes,status)
str(patientdata)
summary(patientdata)

# 列表
g<-"Hello world"
h<-c(25,26,18,39)
j<-matrix(1:10,nrow = 5)
k<-c("one","two","three")
mylist<-list(title=g,ages=h,j,k)
mylist

# 数据集标注
names(patientdata)[2]<-"Age at hospitalization(in years)"
patientdata&gender<-factor(patientdata$gender,levels = c(1,2),labels = c("male","female"))
