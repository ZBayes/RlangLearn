# R语言实战阅读笔记
## 2 创建数据集
### 2.2 数据结构
一般而言，数据的存储结构有下面几种形式：
![数据存储结构](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据存储结构.png)

**因子**：用于存储数值型，字符型，逻辑型数据的一位数组。
```R
a<- c(1,2,3,4)
b<- c("one","two","three","four")
c<- c(TRUE,TRUE,FALSE,FALSE)
a[3]
a[c(1,4)]
a[2:4]
```

**矩阵**: 二维数组，每个元素有用相同的数据类型。公式定义十分复杂，如下图所示：
![矩阵定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/矩阵定义.png)
```R
y<-matrix(1:20,nrow = 5,ncol = 4)
y

cells<-c(1,26,24,68)
rnames<-c("R1","R2")
cnames<-c("C1","C2")
mymatrix1<-matrix(cells,nrow=2,ncol=2,byrow=TRUE,dimnames=list(rnames,cnames))
mymatrix1
mymatrix2<-matrix(cells,nrow=2,ncol=2,byrow=FALSE,dimnames=list(rnames,cnames))
mymatrix2
```

**数组**：和矩阵类似，但是允许维度大于2，公式定义如下：
![数组定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数组定义.png)