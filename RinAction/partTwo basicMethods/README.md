# R语言实战阅读笔记（第二部分）
[TOC]

阅读这本书然后进行笔记，方便起见参考文献写最前面。  
[1] Robert, I, Kabacoff. [R语言实战](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R语言实战.pdf)[M]. 北京:中国工信出版集团, 人民邮电出版社, 2016.  

## 6 基本图形
**c6 basicGraphs.R**  
本节主要讲解各种统计图的绘制方法。

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

