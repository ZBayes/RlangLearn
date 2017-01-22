# R语言实战阅读笔记（第二部分）
[TOC]

阅读这本书然后进行笔记，方便起见参考文献写最前面。  
[1] Robert, I, Kabacoff. [R语言实战](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R语言实战.pdf)[M]. 北京:中国工信出版集团, 人民邮电出版社, 2016.  

## 6 基本图形
**c6 basicGraphs.R**  
本节主要讲解各种统计图的绘制方法。

```R
# 需要用到的包
install.packages(c("vcd", "plotrix", "sm", "vioplot"))
```

### 6.1 条形图
#### 6.1.1 简单条形图
首先载入数据。
```R
library(vcd)
counts <- table(Arthritis$Improved)
counts
```

产生条形图主要是用barplot实现。
```R
barplot(counts, 
        main="Simple Bar Plot",
        xlab="Improvement", ylab="Frequency")

barplot(counts, 
        main="Horizontal Bar Plot", 
        xlab="Frequency", ylab="Improvement", 
        horiz=TRUE)
```

第一部分绘制的是一般情况下的柱状图。  
![柱状图1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/柱状图1.png)  
第二部分绘制的是横向的柱状图。  
![柱状图2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/柱状图2.png)  

#### 6.1.2 堆砌条形图和分组条形图
具体是啥我开始也不知道，看完下面的例子之后就觉得很厉害，以后我也用。首先来一发数据。
```R
library(vcd)
counts <- table(Arthritis$Improved, Arthritis$Treatment)
counts
```

堆砌条形图
```R
barplot(counts, 
        main="Stacked Bar Plot",
        xlab="Treatment", ylab="Frequency", 
        col=c("red", "yellow","green"),            
        legend=rownames(counts))
```

![堆砌条形图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/堆砌条形图.png)  

分组条形图
```R
barplot(counts, 
        main="Grouped Bar Plot", 
        xlab="Treatment", ylab="Frequency",
        col=c("red", "yellow", "green"),
        legend=rownames(counts), beside=TRUE)
```

![分组条形图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/分组条形图.png)  

在代码上，和一般条形图的区别是数据输入的时候输入的是一个矩阵，R会根据矩阵会出将一列的会在一个柱形上，就形成堆砌柱状图，当besides=TRUE时，列内每一行就会分开绘制柱状，形成分组柱状图。

#### 6.1.3 均值条形图
根据某个指标数据的均值来展示其分布情况，当然，中位数、标准差等同样可以绘制。下面是排序后的均值条形图。
```R
states <- data.frame(state.region, state.x77)
means <- aggregate(states$Illiteracy, by=list(state.region), FUN=mean)
means

means <- means[order(means$x),]  
means

barplot(means$x, names.arg=means$Group.1) 
title("Mean Illiteracy Rate")  
```

结果如下：
![排序后均值条形图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/排序后均值条形图.png)  

#### 6.1.4 条形图的微调
通过一些小属性能够调整图中的标签等内容的字号等。
```R
par(mar=c(5,8,4,2))       # increase the y-axis margin
par(las=2)                # set label text perpendicular to the axis
counts <- table(Arthritis$Improved) # get the data for the bars

# produce the graph
barplot(counts, 
        main="Treatment Outcome", horiz=TRUE, cex.names=0.8,
        names.arg=c("No Improvement", "Some Improvement", "Marked Improvement")
)
par(opar)
```

![条形图微调](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/条形图微调.png)  

#### 6.1.5 棘状图
直接看例子就知道这是什么鬼了，看名字我也不知道是啥，看了就知道其实很常见。
```R
library(vcd)
attach(Arthritis)
counts <- table(Treatment,Improved)
spine(counts, main="Spinogram Example")
detach(Arthritis)
```

![棘状图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/棘状图.png)  

### 6.2 饼图
饼图又被称为派图，R里面的函数就是pie。
```R
par(mfrow=c(2,2))                             
slices <- c(10, 12,4, 16, 8) 
lbls <- c("US", "UK", "Australia", "Germany", "France")

pie(slices, labels = lbls, 
    main="Simple Pie Chart")

pct <- round(slices/sum(slices)*100)                      
lbls <- paste(lbls, pct) 
lbls <- paste(lbls,"%",sep="")
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Pie Chart with Percentages")

library(plotrix)                                               
pie3D(slices, labels=lbls,explode=0.1,
      main="3D Pie Chart ")

mytable <- table(state.region)                                   
lbls <- paste(names(mytable), "\n", mytable, sep="")
pie(mytable, labels = lbls, 
    main="Pie Chart from a dataframe\n (with sample sizes)")

par(opar)
```

![饼图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/饼图.png)  

上面画了四个饼图，分别给出了饼图常见的属性以及设置方法。

在R中，还提供了更加高逼格的另一种图——扇形图。
```R
library(plotrix)
slices <- c(10, 12,4, 16, 8) 
lbls <- c("US", "UK", "Australia", "Germany", "France")   
fan.plot(slices, labels = lbls, main="Fan Plot")
```

![扇形图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/扇形图.png)  

### 6.3 直方图
看了例子好好区分条形图和直方图，额，在这本书看来是完全不同的。
```R
par(mfrow=c(2,2)) 
# simple histogram                                                        1
hist(mtcars$mpg)

# colored histogram with specified number of bins        
hist(mtcars$mpg, 
     breaks=12, 
     col="red", 
     xlab="Miles Per Gallon", 
     main="Colored histogram with 12 bins")

# colored histogram with rug plot, frame, and specified number of bins 
hist(mtcars$mpg, 
     freq=FALSE, 
     breaks=12, 
     col="red", 
     xlab="Miles Per Gallon", 
     main="Histogram, rug plot, density curve")  
rug(jitter(mtcars$mpg)) 
lines(density(mtcars$mpg), col="blue", lwd=2)

# histogram with superimposed normal curve (Thanks to Peter Dalgaard)  
x <- mtcars$mpg 
h<-hist(x, 
        breaks=12, 
        col="red", 
        xlab="Miles Per Gallon", 
        main="Histogram with normal curve and box") 
xfit<-seq(min(x),max(x),length=40) 
yfit<-dnorm(xfit,mean=mean(x),sd=sd(x)) 
yfit <- yfit*diff(h$mids[1:2])*length(x) 
lines(xfit, yfit, col="blue", lwd=2)
box()
```

![直方图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/直方图.png)  

直方图是分组展示不同频数的区间的出现次数的条形图，特殊地。图1是最简单的默认的直方图，图2指定了组数和颜色，图3绘制了密度曲线并给出轴须图。图4添加了一条正态分布曲线，并且加了外框。

### 6.4 核密度图
一种估计密度函数的方法，并绘制出其密度函数，通过核密度图能够了解其密度分布。
```R
d <- density(mtcars$mpg) # returns the density data  
plot(d) # plots the results 

d <- density(mtcars$mpg)                                  
plot(d, main="Kernel Density of Miles Per Gallon")       
polygon(d, col="red", border="blue")                     
rug(mtcars$mpg, col="brown") 
```

![核密度图1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/核密度图1.png)  
![核密度图2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/核密度图2.png)  

核密度图能够对比组间差异，但是在R本身没有很好的支持，于是大神设计了sm包（额，我不知道起这个名字的人怎么想的）。
```R
par(lwd=2)                                                       
library(sm)
attach(mtcars)

# create value labels 
cyl.f <- factor(cyl, levels= c(4, 6, 8),                               
                labels = c("4 cylinder", "6 cylinder", "8 cylinder")) 

# plot densities 
sm.density.compare(mpg, cyl, xlab="Miles Per Gallon")                
title(main="MPG Distribution by Car Cylinders")

# add legend via mouse click
colfill<-c(2:(2+length(levels(cyl.f)))) 
cat("Use mouse to place legend...","\n\n")
legend(locator(1), levels(cyl.f), fill=colfill) 
detach(mtcars)
par(lwd=1)
```

![sm包核密度图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/sm包核密度图.png)

### 6.5 箱线图
首先，下面这个图能很清晰的描述箱线图是什么，怎么看。
![箱线图定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/箱线图定义.png)  

关于箱线图，其实现的代码就是boxplot。  
```R
boxplot(mpg~cyl,data=mtcars,
        main="Car Milage Data", 
        xlab="Number of Cylinders", 
        ylab="Miles Per Gallon")
```

![箱线图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/箱线图.png)  

带凹槽的箱线图能更加清晰的对比尤其是中位数。

```R
boxplot(mpg~cyl,data=mtcars, 
        notch=TRUE, 
        varwidth=TRUE,
        col="red",
        main="Car Mileage Data", 
        xlab="Number of Cylinders", 
        ylab="Miles Per Gallon")
```

![带凹槽箱线图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/带凹槽箱线图.png)  

为了进行分组对比，可以通过分组箱线图实现。
```R
# create a factor for number of cylinders
mtcars$cyl.f <- factor(mtcars$cyl,
                       levels=c(4,6,8),
                       labels=c("4","6","8"))

# create a factor for transmission type
mtcars$am.f <- factor(mtcars$am, 
                      levels=c(0,1), 
                      labels=c("auto","standard"))

# generate boxplot
boxplot(mpg ~ am.f *cyl.f, 
        data=mtcars, 
        varwidth=TRUE,
        col=c("gold", "darkgreen"),
        main="MPG Distribution by Auto Type", 
        xlab="Auto Type")
```

![分组箱线图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/分组箱线图.png)  

小提琴图是箱线图的升级，将箱线图和核密度图结合，体现更多信息。
```R
library(vioplot)

x1 <- mtcars$mpg[mtcars$cyl==4] 
x2 <- mtcars$mpg[mtcars$cyl==6]
x3 <- mtcars$mpg[mtcars$cyl==8]

vioplot(x1, x2, x3, 
        names=c("4 cyl", "6 cyl", "8 cyl"), 
        col="gold")
title("Violin Plots of Miles Per Gallon")
```

![小提琴图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/小提琴图.png)  

### 6.6 点图
说白了就是散点图，能够看出其趋势和简单地分布。
```R
dotchart(mtcars$mpg,labels=row.names(mtcars),cex=.7,
         main="Gas Mileage for Car Models", 
         xlab="Miles Per Gallon")
```

![点图1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/点图1.png)  

由于这种初始点比较复杂，所以可以进行处理后再绘制点图。
```R
x <- mtcars[order(mtcars$mpg),]                      
x$cyl <- factor(x$cyl)                                 
x$color[x$cyl==4] <- "red"                              
x$color[x$cyl==6] <- "blue"
x$color[x$cyl==8] <- "darkgreen" 
dotchart(x$mpg,
         labels = row.names(x),                               
         cex=.7, 
         pch=19,                                              
         groups = x$cyl,                                       
         gcolor = "black",
         color = x$color,
         main = "Gas Mileage for Car Models\ngrouped by cylinder",
         xlab = "Miles Per Gallon")
```

![点图2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/点图2.png)  

## 7 基本统计分析
**c7 basicStatistics.R**  
本章会在前面统计分析的基础上了解变量之间的统计关系。需要注意的是，本章的主要内容的学习必须建立在对概率统计有比较好的基础前提下，否则，没用。

```R
# 需要用到的包
install.packages(c("ggm", "gmodels", "vcd", "Hmisc","pastecs", "psych", "doBy"))
```

### 7.1 描述性统计分析
数据载入  
```R
mt <- mtcars[c("mpg", "hp", "wt", "am")]
head(mt)
```

#### 7.1.1 方法云集
本小小节街找一些能批量展示数据统计量的函数。  
**summary()** 提供最大值，最小值，四分位数，数值型变量均值，因子向量和逻辑向量的频数统计。  
```R
mt <- mtcars[c("mpg", "hp", "wt", "am")]
summary(mt)
```

**sapply()** 其中有一个参数是输入函数名，所以sapply主要是实现输入的该函数的，当然，该函数可以使自编的函数。其实现公式是：  
![sapply定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/sapply定义.png)  
其中的x是你的数据框（或矩阵）， FUN为一个任意的函数。如果指定了options，它们将被传递给FUN。你可以在这里插入的典型函数有mean()、 sd()、 var()、 min()、 max()、 median()、length()、 range()和quantile()。函数fivenum()可返回图基五数总括（Tukey’s five-number summary，即最小值、下四分位数、中位数、上四分位数和最大值）。

```R
mystats <- function(x, na.omit=FALSE){
  if (na.omit)
    x <- x[!is.na(x)]
  m <- mean(x)
  n <- length(x)
  s <- sd(x)
  skew <- sum((x-m)^3/s^3)/n
  kurt <- sum((x-m)^4/s^4)/n - 3
  return(c(n=n, mean=m, stdev=s, skew=skew, kurtosis=kurt))
}

myvars <- c("mpg", "hp", "wt")
sapply(mtcars[myvars], mystats)
```

对上面最后一行，如果要忽略缺失值，可以换成下面这句：
```R
sapply(mtcars[myvars], mystats,na.omit=TRUE)
```

#### 7.1.2 更多的方法
很多热心的大神给人类做出了重大贡献，大量用于这方面的包都很好用。

**describe()** Hmisc包中的describe()函数可返回变量和观测的数量、缺失值和唯一值的数目、平均值、分位数，以及五个最大的值和五个最小的值。

```R
library(Hmisc)
myvars <- c("mpg", "hp", "wt")
describe(mtcars[myvars])
```

**stat.desc()** pastecs包中有一个名为stat.desc()的函数，它可以计算种类繁多的描述性统计量。

![statdesc定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/statdesc定义.png)

其中的x是一个数据框或时间序列。若basic=TRUE（默认值），则计算其中所有值、空值、缺失值的数量，以及最小值、最大值、值域，还有总和。若desc=TRUE（同样也是默认值），则计算中位数、平均数、平均数的标准误、平均数置信度为95%的置信区间、方差、标准差以及变异系数。最后，若norm=TRUE（不是默认的），则返回正态分布统计量，包括偏度和峰度（以及它们的统计显著程度）和Shapiro-Wilk正态检验结果。

**psych包中的describe()** 它可以计算非缺失值的数量、平均数、标准差、中位数、截尾均值、绝对中位差、最小值、最大值、值域、偏度、峰度和平均值的标准误。

#### 7.1.3 分组计算描述性统计量
**aggregare()**

```R
myvars <- c("mpg", "hp", "wt")
aggregate(mtcars[myvars], by=list(am=mtcars$am), mean)
aggregate(mtcars[myvars], by=list(am=mtcars$am), sd)
```

**by()**
相比之下，by函数能够批量的进行各种统计量的计算，aggregate只能实现一种，相对弱爆了。

```R
dstats <- function(x)sapply(x, mystats)
myvars <- c("mpg", "hp", "wt")
by(mtcars[myvars], mtcars$am, dstats)
```

#### 7.1.4 分组计算的扩展
**doBy包中summaryBy()**
这个包叫做逗比包，有点意思哈哈。  
![summaryby定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/summaryby定义.png)

其中formula接受下面的格式  
![formula定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/formula定义.png)

在~左侧的变量是需要分析的数值型变量，而右侧的变量是类别型的分组变量。 function可为任何内建或用户自编的R函数。

```R
library(doBy)
summaryBy(mpg+hp+wt~am, data=mtcars, FUN=mystats)
```

**describeBy()**
psych包中的describeBy()函数可计算和describe()相同的描述性统计量，只是按照一个或多个分组变量分层。
```R
library(psych)
myvars <- c("mpg", "hp", "wt")
describeBy(mtcars[myvars], list(am=mtcars$am))
```

### 7.2 频数表和列联表
实例数据集
```R
library(vcd)
head(Arthritis)
```

#### 7.2.1 生成频数表
常用的频数表生成函数如下：
![频数表生成1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/频数表生成1.png)  
![频数表生成2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/频数表生成2.png)

**一维列联表**
```R
mytable <- with(Arthritis, table(Improved))
mytable  # frequencies
prop.table(mytable) # proportions
prop.table(mytable)*100 # percentages
```

table函数能够生成简单的频数表。prop.table能够将频数变为百分比，乘100之后能够变为整数。

**二维列联表**
![xtab定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/xtab定义.png)  
这里面需要用到xtab函数。其中的mydata是一个矩阵或数据框。总的来说，要进行交叉分类的变量应出现在公式的右侧（即~符号的右方），以+作为分隔符。若某个变量写在公式的左侧，则其为一个频数向量。

```R
mytable <- xtabs(~ Treatment+Improved, data=Arthritis)
mytable # frequencies

margin.table(mytable,1) #row sums
margin.table(mytable, 2) # column sums
prop.table(mytable) # cell proportions
prop.table(mytable, 1) # row proportions
prop.table(mytable, 2) # column proportions
addmargins(mytable) # add row and column sums to table
```
使用margin.table()和prop.table()函数分别生成边际频数和比例。下标1指代table()语句中的第一个变量，即行，下表为2表示列。prop.table(mytable)可以表示每个单元格所占比例。

addmargins()函数为这些表格添加边际和。
```R
addmargins(prop.table(mytable))
addmargins(prop.table(mytable, 1), 2)
addmargins(prop.table(mytable, 2), 1)
```

使用gmodels包中的CrossTable()函数是创建二维列联表的第三种方法。这种方式得到的结果非常规整有规律，很适合提取。

```R
library(gmodels)
CrossTable(Arthritis$Treatment, Arthritis$Improved)
```

**多维列联表**
多维列联表能够实现的函数很多，而且和前面的类似，只是添加了一个维度而已。
```R
mytable <- xtabs(~ Treatment+Sex+Improved, data=Arthritis)
mytable

ftable(mytable)

margin.table(mytable, 1)
margin.table(mytable, 2)
margin.table(mytable, 2)

margin.table(mytable, c(1,3))

ftable(prop.table(mytable, c(1,2)))
ftable(addmargins(prop.table(mytable, c(1, 2)), 3))
```

#### 7.2.2 独立性检验
R中提供了多种独立性检验方法，书本上提供了三种。

**卡方独立性检验**  
chisq.test对二维表的行向量和列向量进行卡方独立性检验。  
```R
library(vcd)
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
chisq.test(mytable)
mytable <- xtabs(~Improved+Sex, data=Arthritis)
chisq.test(mytable)
```

**Fisher精确检验**  
使用fisher.test()函数进行Fisher精确检验。Fisher精确检验的原假设是：边界固定
的列联表中行和列是相互独立的。其调用格式为fisher.test(mytable)，其中的mytable是一个二维列联表。与许多统计软件不同的是，这里的fisher.test()函数可以在任意行列数大于等于2的二维列联表上使用，但不能用于2×2的列联表。  
```R
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
fisher.test(mytable)
```

**Cochran-Mantel-Haenszel检验**  
mantelhaen.test()函数可用来进行Cochran-Mantel-Haenszel卡方检验，其原假设是，两个名义变量在第三个变量的每一层中都是条件独立的。下列代码可以检验治疗情况和改善情况在性别的每一水平下是否独立。此检验假设不存在三阶交互作用（治疗情况×改善情况×性别）。  
```R
mytable <- xtabs(~Treatment+Improved+Sex, data=Arthritis)
mantelhaen.test(mytable)
```

**相关性的度量**
```R
states<- state.x77[,1:6]
cov(states)
cor(states)
cor(states, method="spearman")
```

### 7.3 相关

#### 7.3.1 相关的类型
**Pearson、 Spearman和Kendall相关**  
![cor和cov定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/cor和cov定义.png)  

```R
states<- state.x77[,1:6]
cov(states)
cor(states)
cor(states, method="spearman")
```

**偏相关**  
![偏相关定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/偏相关定义.png)  

```R
library(ggm)

pcor(c(1,5,2,3,6), cov(states))
```

#### 7.3.2 相关性的显著性检验
![cortest定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/cortest定义.png)  

```R
cor.test(states[,3], states[,5])
```

由于cor.test每次只能进行一个检验，于是就有懒人弄了批量检验。
```R
library(psych)
corr.test(states, use="complete")
```

### 7.4 t检验
#### 7.4.1 独立样本的t检验
![ttest定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/ttest定义.png)  

下面的例子使用的是假设方差不等的双侧检验。
```R
library(MASS)
t.test(Prob ~ So, data=UScrime)
```

#### 7.4.2 非独立样本的t检验
```R
sapply(UScrime[c("U1","U2")], function(x)(c(mean=mean(x),sd=sd(x))))
with(UScrime, t.test(U1, U2, paired=TRUE))
```

### 7.5 组间差异的非参数检验
#### 7.5.1 两组比较
![wilcoxtest定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/wilcoxtest定义.png)  

```R
with(UScrime, by(Prob, So, median))
wilcox.test(Prob ~ So, data=UScrime)

sapply(UScrime[c("U1", "U2")], median)
with(UScrime, wilcox.test(U1, U2, paired=TRUE))
```

下面这段话我觉得作者写的非常好，马克一下。
![t检验和wilcox检验的对比](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/t检验和wilcox检验的对比.png)  

#### 7.5.2 多余两组的比较
这里介绍了一种Kruskal-Wallis检验。

![Kruskal-Wallis检验](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/Kruskal-Wallis检验.png)  

```R
states <- data.frame(state.region, state.x77)
kruskal.test(Illiteracy ~ state.region, data=states)
```

```R
source("http://www.statmethods.net/RiA/wmc.txt")              
states <- data.frame(state.region, state.x77)
wmc(Illiteracy ~ state.region, data=states, method="holm")
```

第二部分 完