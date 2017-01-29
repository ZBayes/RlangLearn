# R语言实战阅读笔记
为了方便查阅，制作出了这个汇总版，回会根据学习进度同步更新。

[TOC]

阅读这本书然后进行笔记，方便起见参考文献写最前面。  
[1] Robert, I, Kabacoff. [R语言实战](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R语言实战.pdf)[M]. 北京:中国工信出版集团, 人民邮电出版社, 2016.  
[2] 刘重杰. [R数据的导入与导出](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R数据的导入与导出.pdf)[EB/OL]. https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R数据的导入与导出.pdf. 

## 第一部分  

### 2 创建数据集
**C2_createDateSet.R**
数据的创建、导入和整理等。

```R
# 需要用到的包
# 无
# 第一章存在一个以后会用的包
install.packages("vcd")
```

#### 2.2 数据结构
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
R语言中数组的是从1开始算的，和matlab相同，和大部分高级语言不同。
```R
dim1<-c("A1","A2")
dim2<-c("B1","B2","B3")
dim3<-c("C1","C2","C3","C4")
z<-array(1:24, c(2,3,4), dimnames = list(dim1,dim2,dim3))
z
```

**数据框**：不同列可以有不同模式的数据，相比矩阵而言更加一般化。
![数据框定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据框定义.png)  
```R
patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabetes<-c("Type1","Type2","Type3","Type1")
status<-c("Poor","Improved","Excellent","Poor")
patientdata<-data.frame(patientID,age,diabetes,status)
patientdata
```
每列的数据模式必须统一，但是不同列的数据模式可以不同，这个和关系数据库十分类似。
数据的选取有下面三种形式：
```R
patientdata[1:2]
patientdata[c("diabetes","status")]
patientdata$age
```
若重新整理为列联表，可以用table函数
```R
table(patientdata$diabetes,patientdata$status)
```
$符号表示的类似一些高级语言中的句号.，前面的是类名或者对象名，后面是属性，然而这种方式其实十分麻烦，因为每次都需要输入类名，于是attach和detach应运而生。
```R
attach(patientdata)
  table(diabetes,status)
detach(patientdata)
```
建议这两个函数配对使用保证占用内存较小。然而还需要记住的是，出现重名属性时就很尴尬，在R语言中，优先使用第一个attach的类中的属性。  
另外，还有一个类似的函数是with，具有类似的效果。
```R
with(patientdata,{table(diabetes,status)})
```
由于在大括号中，所以一般的赋值符号定义的都是局部变量，要是想要扩大作用域，可以使用升级版的赋值号。
```R
with(patientdata,{table(diabetes,status)})
with(patientdata,{
  pa1<-diabetes
  pa2<<-diabetes
})
pa1
pa2
```
另外，R语言为数据框提供实例标识符的功能，这种功能类似数据库中的主码，能够标识区分不同的元组。
```R
patientdata<-data.frame(patientID,age,diabetes,status,row.names = patientID)
```

**因子**：变量可以分为名义型、有序型、连续型变量，名义型每种变量都有独立的含义，如"男","女"；有序型和名义型类似，但是存在一定的顺序，例如"高"，"中"，"低"；连续型顾名思义就是变量是连续的，如身高，体重等。其中，将名义型和有序型统称为因子。在上面，已经定义了一个diabetes变量，
```R
diabetes<-c("Type1","Type2","Type3","Type1")
```
然而如果用factor函数，
```R
diabetes<-factor(diabetes)
```
则会将diabetes转为因子，变量diabetes里面存储的变量，1=Type1，2=Type2，3=Type3。如果是有序型，则可以在设置参数order，TRUE表示有顺序，为有序型，FALSE为名义型，默认为FALSE。  
```R
status<-c("Poor","Improved","Excellent","Poor")
status<-factor(status,order=TRUE)
```
默认，标号就是变量出现的顺序，最先出现的是"Poor"，则1="Poor"，可以和实际匹配，但是如果"Poor"不是第一个出现，则"Poor"对应的数字就不是最小，说不定是"Improved"了，所以需要设置排序（未出现的都设置为缺失值）。
```R
status<-factor(status,order=TRUE,levels = c("Poor","Improved","Excellent"))
```
数值型变量也可以用levels和labels来编码，如男为1，女为2
```R
sex<-factor(sex,levels=c(1,2),labels=c("Male","Female"))
```
下面是一个对因子总结：
```R
patientID<-c(1,2,3,4)
age<-c(25,34,28,52)
diabetes<-c("Type1","Type2","Type3","Type1")
status<-c("Poor","Improved","Excellent","Poor")
diabetes<-factor(diabetes)
status<-factor(status,order=TRUE,levels = c("Poor","Improved","Excellent"))
patientdata<-data.frame(patientID,age,diabetes,status)
str(patientdata)
summary(patientdata)
```

**列表**：最复杂的一种，可以理解为一种什么都能放到里面的超级数组。
```R
g<-"Hello world"
h<-c(25,26,18,39)
j<-matrix(1:10,nrow = 5)
k<-c("one","two","three")
mylist<-list(title=g,ages=h,j,k)
mylist
```

#### 2.3 数据输入
这块内容个人打算随用随查，所以暂时不打算详细学，另外编者提供了一个文档，有PDF版本[R数据的导入与导出](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R数据的导入与导出.pdf)。

#### 2.4 数据集的标注
通俗的说就是个数据集或者属性添加备注，如age里面添加内容是ages at hospitalization(in years)。然而R对这个功能的支持十分有限。
**变量标签**：用简单粗暴的数组来表示。
```R
names(patientdata)[2]<-"Age at hospitalization(in years)"
```
变量名变得这么长，并没有什么用。
**值标签**：创建值标签
```R
patientdata&gender<-factor(patientdata$gender,levels = c(1,2),labels = c("male","female"))
```

#### 2.5 处理数据对象的实用函数
两张截屏搞定：
![数据处理对象函数1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据处理对象函数1.png)  
![数据处理对象函数2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据处理对象函数2.png)  

### 3 图形初阶
**C3_basicGraphics.R**  
图形创建与处理基础。

```R
# 需要用到的包
install.packages(c("Hmisc", "RColorBrewer"))
```


#### 3.1 使用图形
首先给出这个例子：
```R
pdf("myGraph.pdf")
  attach(atcars)
  plot(wt,mpg)
  abline(lm(mpg~wt))
  title("Regression of MPG and WT")
  detach(atcars)
dev.off()
```
缩进为画图的出程序内绘图，绘图完成后会存入"myGraph.pdf"，plot画出wt和pmg的二维散点图，然后绘出其回归线，title为图片添加标题。  
除了pdf之外，还有win.metafile, png(), jpeg(), bmp(), tiff(), xfig(), postscript()图片保存格式。

#### 3.2 简单例子
为了更好描述内容图形的使用，下面是一个例子。是一个病人对两种药物的五个剂量水平响应的统计，用图像表示。源数据的统计表如下：
![病人对两种药物的五个剂量水平响应统计表](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/病人对两种药物的五个剂量水平响应统计表.png)  
源代码如下：
```R
dose<-c(20,30,40,45,60)
drugA<-c(16,20,27,40,60)
drugB<-c(15,18,25,31,40)
plot(dose,drugA,type = "b")
```
画出来的图就是这样的  
![药物A和响应1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/药物A和响应1.png)  

#### 3.3 图形参数
下面是一系列能够修改图像的参数。
```R
opar<-par(no.readonly = TRUE)
par(lty=2,pch=17)
plot(dose,drugA,type = "b")
par(opar)
```
par中可以修改图像的性质，其中的lty表示线条形式，为2时表示虚线，pch表示点的形状，17为实心三角形，par中可以一次设置多个参数，也可以分几次来实现。
```R
par(lty=2)
par(pch=17)
```
另外临时的，可以使用下面的联合的方式来直接实现对图的修改。
```R
plot(dose,drugA,type = "b",lty=2,pch=17)
```
得到的图像结果是  
![药物A和响应2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/药物A和响应2.png)  
下面是一张关于符号与线条的参数表，通过参数表能够更好的查找需要变化的项及其取值。
![制定符号和线条类型的参数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/制定符号和线条类型的参数.png)  
![参数pch可指定的绘图符号](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/参数pch可指定的绘图符号.png)  
![参数lty可指定的线条类型](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/参数lty可指定的线条类型.png)  

关于颜色，同样由类似骚包的操作。直接上图，不多说了。
![用于指定颜色的参数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/用于指定颜色的参数.png)  

同样的，还有文本属性
![用于制定文本大小的参数1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/用于制定文本大小的参数1.png)  
![用于制定字体族字号和字样的参数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/用于制定字体族字号和字样的参数.png)  

最后，还有控制图形本身和边界尺寸的参数
![用于空值图像和边界尺寸的参数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/用于制定字体族字号和字样的参数.png)  

下面来更加完整的例子，还是上面的剂量的例子：
```R
dose<-c(20,30,40,45,60)
drugA<-c(16,20,27,40,60)
drugB<-c(15,18,25,31,40)

opar<-par(no.readonly = TRUE)
par(pin=c(2,3))
par(lwd=2,cex=1.5)
par(cex.axis=.75,font.axis=3)
plot(dose,drugA,type = "b",pch=19,lty=2,col="red")
plot(dose,drugB,type = "b",pch=23,lty=6,col="blue",bg="green")
par(opar)
```
![药物A剂量和响应1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/药物A剂量和响应1.png)  
![药物B剂量和响应1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/药物B剂量和响应1.png)  

#### 3.4 添加文本和图例
不废话，还是先上例子。
```R
plot(dose, drugA, type="b",  
  col="red", lty=2, pch=2, lwd=2,
  main="Clinical Trials for Drug A", 
  sub="This is hypothetical data", 
  xlab="Dosage", ylab="Drug Response",
  xlim=c(0, 60), ylim=c(0, 70))
```
![药物A和响应——添加标题副标题和坐标轴](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/药物A和响应——添加标题副标题和坐标轴.png)  

关于标题，有专门的函数可以定义可以设置。  
![标题定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/标题定义.png)  
同样的，坐标轴也有。  
![坐标轴定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/坐标轴定义.png)  
其选项的设置如下：  
![坐标轴选项1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/坐标轴选项1.png)  
![坐标轴选项2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/坐标轴选项2.png)  

来个例子
```R
x<-c(1:10)
y<-x
z<-10/x
opar<-par(no.readonly = TRUE)

par(mar=c(5,4,4,8)+0.1)
plot(x,y,type = "b",
     pch=21,col="red",
     yaxt="n",lty=3,ann=FALSE)
lines(x,z,type = "b",pch=22,col="blue",lty=2)

axis(2,at=x,labels = x,col.axis="red",las=2)

axis(4,at=z,labels=round(z,digits = 2),
     col.axis="blue",las=2,cex.axis=0.7,tck=-0.01)

mtext("y=1/x", side=4, line=3, cex.lab=1, las=2, col="blue")
title("An Example of Creative Axes",
      xlab="X values",
      ylab="Y=X")
par(opar)
```
![坐标轴选项示例](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/坐标轴选项示例.png)  

添加参考线使用的命令：  
![添加参考线](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/添加参考线.png)  
另外，还能为abline添加额外的图形参数如线条类型，颜色和宽度。
```R
abline(h=c(1,5,7))
abline(h=seq(1,10,2),lty=2,col="blue")
```

图例用于表示图像中线条或者是柱表示的内容，R语言也提供了这方面的支持。  
![图例选项](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/图例选项.png)  
给一个例子，用于对比两种药物的效果。
```R
dose<-c(20,30,40,45,60)
drugA<-c(16,20,27,40,60)
drugB<-c(15,18,25,31,40)

opar<-par(no.readonly = TRUE)

par(lwd=2,cex=1.5,font.lab=2)
plot(dose, drugA, type="b",
     pch=15, lty=1, col="red", ylim=c(0, 60),
     main="Drug A vs. Drug B",
     xlab="Drug Dosage", ylab="Drug Response")
lines(dose, drugB, type="b",
      pch=17, lty=2, col="blue")
abline(h=c(30), lwd=1.5, lty=2, col="gray")
library(Hmisc)
minor.tick(nx=3, ny=3, tick.ratio=0.5)
legend("topleft", inset=.05, title="Drug Type", c("A","B"),
       lty=c(1, 2), pch=c(15, 17), col=c("red", "blue"))
par(opar)
```
需要注明的是，里面需要一个包，"Hmisc"，包的安装用下面命令安装和配置，在本代码中，此包中的函数用于绘制次要刻度线。
```R
install.packages("Hmisc")
library(Hmisc)
```
最终运行后的结果是:
![坐标轴演示实验](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/坐标轴演示实验.png)

文本标注在R中同样支持，其格式为：
![文本标注定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/文本标注定义.png)
涉及的选项内容为：
![text和mtext选项](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/text和mtext选项.png)
在文本标注中，作者给出了这个例子：
```R
attach(mtcars)
plot(wt, mpg,
     main="Mileage vs. Car Weight",
     xlab="Weight", ylab="Mileage",
     pch=18, col="blue")
text(wt, mpg,
     row.names(mtcars),
     cex=0.6, pos=4, col="red")
detach(mtcars)
```
运行结果如下：

![添加标注的散点图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/text和mtext选项.png)

在一些时候，还需要在图中标注函数等数学内容，数字标注的内容比较多，可以通过下面命令详细了解
```R
demo(plotmath)
```
为了方便起见，我直接上运行结果，首先是自动执行的代码和返回内容，由于内容不较长，我放在了demo(plotmath)_return.txt文件里面，方便查阅。  

重要的是在plot中的返回内容如下：
![demoplot1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/demoplot1.png)
![demoplot2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/demoplot2.png)
![demoplot3](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/demoplot3.png)
![demoplot4](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/demoplot4.png)
![demoplot5](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/demoplot5.png)

#### 3.5 图形组合
最后是图像组合，在matlab中有subplot进行图像组合，类似的，在R中用par()和layout()进行实现。直接上例子，更加快，下面的这个是用par的例子。
```R
attach(mtcars)
opar <- par(no.readonly=TRUE)
par(mfrow=c(2,2))
plot(wt,mpg, main="Scatterplot of wt vs. mpg")
plot(wt,disp, main="Scatterplot of wt vs. disp")
hist(wt, main="Histogram of wt")
boxplot(wt, main="Boxplot of wt")
par(opar)
detach(mtcars)
```
其中起作用的就是第三行代码：
```R
par(mfrow=c(2,2))
```
表示能把后面画的四张图转化为2x2的矩阵图，效果如下：  

![图像合并1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/图像合并1.png)

另外是layout的例子：
```R
attach(mtcars)
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)
```
显然起作用的是第二行代码。  
```R
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
```
layout里面是一个矩阵，  
```R
matrix(c(1,1,2,3), 2, 2, byrow = TRUE)
```
具体矩阵长啥样就不多说了，第一行是两个1，第二行是2,3。说明，第一张图占用矩阵的第一行，下面两个矩阵分别占用第二行的两个小部分。

![图像合并2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/图像合并2.png)

layout还有一个强大之处就是按照特定比例分配大小。
```R
attach(mtcars)
layout(matrix(c(1, 1, 2, 3), 2, 2, byrow = TRUE),
       widths=c(3, 1), heights=c(1, 2))
hist(wt)
hist(mpg)
hist(disp)
detach(mtcars)
```
widths设置的是每列的宽度比，heights设置的是每行的宽度比。

![图像合并3](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/图像合并3.png)

说起来你可能不信，还有更加先进的图形布局控制，还是先看看例子。图形精准控制
```R
opar <- par(no.readonly=TRUE)

par(fig=c(0, 0.8, 0, 0.8))
plot(mtcars$mpg, mtcars$wt,
     xlab="Miles Per Gallon",
     ylab="Car Weight")

par(fig=c(0, 0.8, 0.55, 1), new=TRUE)
boxplot(mtcars$mpg, horizontal=TRUE, axes=FALSE)

par(fig=c(0.65, 1, 0, 0.8), new=TRUE)
boxplot(mtcars$wt, axes=FALSE)

mtext("Enhanced Scatterplot", side=3, outer=TRUE, line=-3)
par(opar)
```
显然，起作用的是par中的fig参数，fig参数设置的是该图（无论是条形图，折线图等，都可以认为是矩形），是一个1行4列的向量，前两个数表示横向跨越的范围（横坐标跨越范围，原点坐标在左下角），以上方箱形图为例，其横坐标跨越的范围是0.65到1，类似的，其纵坐标的跨越范围是0到0.8。实现效果如下：

![图像合并4](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/图像合并4.png)

图形的处理根据课本暂时先到这，后续还会根据需求进行拓展，只要多练习就能够有进一步的提升，有更加炫酷的（实际就是更加合适的）效果。这些图个人都非常喜欢，可视化的美观性是我想学R的一个重要理由。

### 4 基本数据管理
**C4_basicDataManagement.R**  
本章主要讲解基本的数据管理和预处理技巧。

```R
# 需要用到的包
install.packages(c('reshape2', 'sqldf'))
```

#### 4.1 案例
书中研究的是性别等因素对领导行为的影响，数据表如下：  
![性别领导行为案例数据](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/性别领导行为案例数据.png)  
对陈述的评分主要是下面的标准：  
![性别领导行为案例数据_评价标准](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/性别领导行为案例数据_评价标准.png)  
执行的数据初始化如下：
```R
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
```

#### 4.2 创建新变量
创建新变量在前面的实验已经非常熟悉了，不再赘述，直接看看总结的常用算术运算符。
![算术运算符](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/算术运算符.png)  
关于创建新变量，作者给出了三种方式，如下面所示：
```R
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
```
上述有三种方式王mydata里面添加两列，作者比较钟爱第三种，比较清晰简洁。

#### 4.3 变量重编码
重编码实质还是赋值，只是赋值的内容比较不同，首先介绍简单地逻辑运算符。
![逻辑运算符](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/逻辑运算符.png)  
其实变量重编码的主要目的是处理数据中不正确的数据，例如年龄小于0的，大于99的，小数等。可以有下面的处理。  
```R
leadership$age[leadership$age==99]<-NA
```
另外，为了更好地处理年龄，决定将年龄分段
```R
leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 55 &
                    leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 55] <- "Young"

leadership <- within(leadership,{
  agecat <- NA
  agecat[age > 75] <- "Elder"
  agecat[age >= 55 & age <= 75] <- "Middle Aged"
  agecat[age < 55] <- "Young" })
```

#### 4.4 变量重命名
在一些情况下，数据的变量名并非所需，或者不准确，此时可以对变量进行重命名。
```R
names(leadership)[2] <- "testDate"
```
当然，也能批量修改。
```R
names(leadership)[6:10] <- c("item1","item2","item3","item4","item5")
```
在plyr包中有一个rename函数，同样可以用于重命名。
```R
library(plyr)
leadership <- rename(leadership,
                     c(manager="managerID", Date="testDate"))
```

#### 4.5 缺失值
is.na()能判断是否为缺失值。  
```R
is.na(leadership[, 6:10])
```

na.omit()用于删除不完整的条目  
```R
leadership
newdata <- na.omit(leadership)
newdata
```

#### 4.6 日期值
一个比较头疼的情况，日期的记录各种各样，还有数据类型等，为此，R提供了一些帮助。下面是日期格式表：  
![日期格式](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/日期格式.png)  
默认日期格式为下面形式：  
```R
mydates <- as.Date(c("2007-06-22", "2004-02-13"))
```

如果需要修改的话：  
```R
strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")
```

系统时间可以这么表示  
```R
Sys.Date()
date()
```

如果需要再进一步改格式，  
```R
today <- Sys.Date()
format(today, format="%B %d %Y")
format(today, format="%A")
```

对程序比较了解的都知道，绝大部分系统和语言的时间记录是根据1970年1月1日来进行相对位置存储的。R语言也是。所以就能对日期进行计算。  
```R
startdate <- as.Date("2004-02-13")
enddate <- as.Date("2011-01-22")
days <- enddate - startdate
days
```

另外，还有different能进行日期计算。  
```R
today <- Sys.Date()
dob <- as.Date("1956-10-12")
difftime(today, dob, units="weeks")
```

日期编程字符型能够进行字符串计算，所以还是要弄懂的~  
```R
strDates <- as.character(dates)
```

日期计算似乎还有很多，例如工作日等，以后根据实际需求在学习吧。  

#### 4.7 数据转换
根据实际需求对数据类型进行转化。
![转换类型函数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/转换类型函数.png)
```R
a <- c(1,2,3)
a
is.numeric(a)
is.vector(a)
a <- as.character(a)
a
is.numeric(a)
is.vector(a)
is.character(a)
```

#### 4.8 数据排序
超喜欢这个，不用自己编程实现了，直接搞定。
```R
newdata <- leadership[order(leadership$age),]

attach(leadership)
newdata <- leadership[order(gender, age),]
detach(leadership)

attach(leadership)
newdata <-leadership[order(gender, -age),]
detach(leadership)
```

#### 4.10 数据合并
也叫作数据集成，R似乎是对数据合并下了不少功夫，看来是踩过不少坑。  
```R
total <- merge(dataframeA, dataframeB, by="ID")
```

表示dataframeA和dataframeB根据ID进行合并。当然根据实际情况，可能会根据两个属性甚至多个属性进行合并，如：  
```R
total <- merge(dataframeA, dataframeB, by=c("ID","Country"))
```

另外，还有一个更加简单粗暴的方法，但是要求行相同。  
```R
total <- cbind(A, B)
```

上面说的是横向合并，即添加列，类似于关系代数中的连接。而R语言还支持横向合并，类似于集合中的并。  
```R
total <- rbind(dataframeA, dataframeB)
```

为了保证数据完整性和一致性，合并还会对数据进行一些其他处理。

- 删除dataframeA中的多余变量；
- 在dataframeB中创建追加的变量并将其值设为NA（缺失）

#### 4.11 数据集取子集
顾名思义，类似SQL中的select。  
```R
newdata <- leadership[, c(5:9)]
```

可以根据属性号选择，当然，也能根据属性名。   
```R
myvars <- c("q1", "q2", "q3", "q4", "q5")
newdata <-leadership[myvars]
```

另外还有一种方法，字符串拼接得到字符串的方法。  
```R
myvars <- paste("q", 1:5, sep="")
newdata <- leadership[myvars]
```

再者，还有删除变量的方法。
```R
myvars <- names(leadership) %in% c("q3", "q4") 
leadership[!myvars]
```

其讲解比较长，有必要粘贴下来...  
![数据删除讲解](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据删除讲解.png)  
也有简单的，下面这种表示删除第8列和第9列
```R
newdata <- leadership[c(-8,-9)]
```

选入观测其实是一个很复杂的过程。
```R
newdata <- leadership[1:3,]
newdata <- leadership[leadership$gender=="M" &
                        leadership$age > 30,]

attach(leadership)
newdata <- leadership[gender=='M' & age > 30,]
detach(leadership)
```

目标是选取30岁以上男性进行观测。  

再给一个例子，研究范围限定在2009年1月1日到2009年12月31日之间，对期间的数据进行观测。  
```R
startdate <- as.Date("2009-01-01")
enddate <- as.Date("2009-10-31")
newdata <- leadership[which(leadership$date >= startdate &
                              leadership$date <= enddate),]
```

难的懂了，下面这个函数subset能帮助我们更简单的执行。
```R
newdata <- subset(leadership, age >= 35 | age < 24,
                  select=c(q1, q2, q3, q4))
newdata <- subset(leadership, gender=="M" & age > 25,
                  select=gender:q4)
```
含义表示如下：
![subset解释](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/subset解释.png)

#### 4.12 SQL操作
用SQL应该会更方便吧哈哈。需要用到包sqldf
```R
library(sqldf)
newdf <- sqldf("select * from mtcars where carb=1 order by mpg",
               row.names=TRUE)
newdf
sqldf("select avg(mpg) as avg_mpg, avg(disp) as avg_disp, gear
from mtcars where cyl in (4, 6) group by gear")
```
不展开，睡觉去，有需求再来展开学一波。

### 5 高级数据管理
**C5_advancedDataManagement.R**  
快速get各种数学、统计、字符串处理函数，学会编辑函数实现特定功能，并提供数据整合的一些特殊方法。

```R
# 需要用到的包
install.packages("reshape2")
```

#### 5.1 一个数据处理的难题
本章只提出一个问题，首先是给出学生数据表。
![学生成绩数据](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/学生成绩数据.png)

案例的数据建立代码如下：
```R
Student <- c("John Davis","Angela Williams","Bullwinkle Moose",
             "David Jones","Janice Markhammer",
             "Cheryl Cushing","Reuven Ytzrhak",
             "Greg Knox","Joel England","Mary Rayburn")
math <- c(502, 600, 412, 358, 495, 512, 410, 625, 573, 522)
science <- c(95, 99, 80, 82, 75, 85, 80, 95, 89, 86)
english <- c(25, 22, 18, 15, 20, 28, 15, 30, 27, 18)

roster <- data.frame(Student, math, science, english, 
                     stringsAsFactors=FALSE)
```

任务是将学生的各种成绩整合为一个指标，然后将前20%的学生评定为A，接下来的20%为B，以此类推，然后按照学生姓名字母顺序给学生排序。

#### 5.2 数值和字符处理函数
本节综述各种数值和字符处理函数。
##### 5.2.1 数学函数
常用的数学函数有：
![数学函数1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数学函数1.png)
![数学函数2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数学函数2.png)
##### 5.2.2 统计函数
![统计函数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/统计函数.png)  

均值与标准差的计算给出例子。
```R
x <- c(1, 2, 3, 4, 5, 6, 7, 8)
mean(x)
sd(x)
n <- length(x)
meanx <- sum(x)/n
css <- sum((x - meanx)**2)            
sdx <- sqrt(css / (n-1))
meanx
sdx
```

##### 5.2.3 概率函数
![概率函数格式](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/概率函数格式.png)  
在分布之前分别添加四个字母表示其概率分布的不同函数。  
![概率分布](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/概率分布.png)  
作者根据正态分布给出一个案例  
![正态分布](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/正态分布.png)  
有些时候，生成的一些随机数，需要保存，此时可以用种子来解决。
```R
runif(5)
runif(5)

set.seed(1234)                                                     
runif(5)
set.seed(1234)                                                      
runif(5)
```
在不设定seed时，两次随机产生的数不同，但是当设置后，即可产生相同的随机数。

在此，作者简要介绍了MASS包，方便生成多元正态数据。
```R
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
```

##### 5.2.4 字符处理函数
![字符处理函数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/字符处理函数.png)  

##### 5.2.5 其它函数
![其它函数](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/其它函数.png)

介绍了一对函数后，作者给出一些使用的例子。

下面这个主要是说明大部分函数支持批量计算，能够针对向量、矩阵等进行计算
```R
a <- 5
sqrt(a)
b <- c(1.243, 5.654, 2.99)
round(b)
c <- matrix(runif(12), nrow=3)
c
log(c)
mean(c)
```

在某些时候，我们想要计算的不是全部数据的均值，可能是某行或者某列的均值，此时R提供了apply函数。
```R
mydata <- matrix(rnorm(30), nrow=6)
mydata
apply(mydata, 1, mean)     
apply(mydata, 2, mean) 
apply(mydata, 2, mean, trim=.2) 
```
需要特殊说明的有一个，是trim=0.2这一项，叫做截尾，数据中最高20%和最低20%的数据都不会被计算。

#### 5.3 解决那个5.1的问题
```R
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
```

- 步骤1：确定小数点维数，初始化数据。
- 步骤2：对数据进行标准化。
- 步骤3：通过均值得到标准分并合并到数据中。
- 步骤4：计算学生百分比分位数。
- 步骤5：为学生分配等级。
- 步骤6：空格为界为学生分姓名。
- 步骤7：抽取姓和名信息然后插入到框架中。
- 步骤8：根据名和姓进行排序。
- 步骤9：查看最终结果。

#### 5.4 控制流
说白了，这节讲循环和条件。  
##### 5.4.1 循环
R里面循环只有for和while
```R
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
```

##### 5.4.2 条件
条件有3中，if-else，ifelse，switch
```R
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

```

#### 5.5 用户自变函数
作为编程语言，怎么能没有自编程序？
```R
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
```

然后来试试怎么调用。
```R
set.seed(1234)
x <- rnorm(500) 
y <- mystats(x)
y <- mystats(x, parametric=FALSE, print=TRUE)
```

#### 5.6 数据整合与重构
在计算过程中，所需要的计算参数并非就是原始数据，而是数据的某些统计量或者数据的其他格式，所以在进行计算之前需要对数据进行整合和重构。

##### 5.6.1 转置
用的就是函数t
```R
cars <- mtcars[1:5, 1:4]      
cars
t(cars)
```

##### 5.6.2 整合数据
有点像excel中的分类汇总，根据某个变量，对数据进行折叠。
```R
options(digits=3)
attach(mtcars)
aggdata <-aggregate(mtcars, by=list(cyl,gear), 
                    FUN=mean, na.rm=TRUE)
aggdata
```

##### 5.6.3 reshape2包
据说这是一个很牛逼的包，所以作者介绍了。案例先行，所以还是先给出案例的数据。
![reshape2包案例数据](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/reshape2包案例数据.png)

在如包（没下的话先用install.packages("reshape2")下载）
```R
library(reshape2)
```

数据代码
```R
mydata <- read.table(header=TRUE, sep=" ", text="
ID Time X1 X2
1 1 5 6
1 2 3 5
2 1 6 1
2 2 2 4
")
```

**数据融合**：
```R
# 数据融合
md <- melt(mydata, id=c("ID", "Time"))
```

**数据重铸**
```R
# reshaping with aggregation
dcast(md, ID~variable, mean)
dcast(md, Time~variable, mean)
dcast(md, ID~Time, mean)

# reshaping without aggregation
dcast(md, ID+Time~variable)
dcast(md, ID+variable~Time)
dcast(md, ID~variable+Time)
```

其实现的是对数据的中心整合，还是能感叹道其神奇。其运算结果分别如下：
![数据融合和重铸](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据融合和重铸.png)

第一部分 完

## 第二部分  

### 6 基本图形
**c6 basicGraphs.R**  
本节主要讲解各种统计图的绘制方法。

```R
# 需要用到的包
install.packages(c("vcd", "plotrix", "sm", "vioplot"))
```

#### 6.1 条形图
##### 6.1.1 简单条形图
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

##### 6.1.2 堆砌条形图和分组条形图
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

##### 6.1.3 均值条形图
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

##### 6.1.4 条形图的微调
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

##### 6.1.5 棘状图
直接看例子就知道这是什么鬼了，看名字我也不知道是啥，看了就知道其实很常见。
```R
library(vcd)
attach(Arthritis)
counts <- table(Treatment,Improved)
spine(counts, main="Spinogram Example")
detach(Arthritis)
```

![棘状图](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/棘状图.png)  

#### 6.2 饼图
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

#### 6.3 直方图
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

#### 6.4 核密度图
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

#### 6.5 箱线图
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

#### 6.6 点图
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

### 7 基本统计分析
**c7 basicStatistics.R**  
本章会在前面统计分析的基础上了解变量之间的统计关系。需要注意的是，本章的主要内容的学习必须建立在对概率统计有比较好的基础前提下，否则，没用。

```R
# 需要用到的包
install.packages(c("ggm", "gmodels", "vcd", "Hmisc","pastecs", "psych", "doBy"))
```

#### 7.1 描述性统计分析
数据载入  
```R
mt <- mtcars[c("mpg", "hp", "wt", "am")]
head(mt)
```

##### 7.1.1 方法云集
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

##### 7.1.2 更多的方法
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

##### 7.1.3 分组计算描述性统计量
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

##### 7.1.4 分组计算的扩展
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

#### 7.2 频数表和列联表
实例数据集
```R
library(vcd)
head(Arthritis)
```

##### 7.2.1 生成频数表
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

##### 7.2.2 独立性检验
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

#### 7.3 相关

##### 7.3.1 相关的类型
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

##### 7.3.2 相关性的显著性检验
![cortest定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/cortest定义.png)  

```R
cor.test(states[,3], states[,5])
```

由于cor.test每次只能进行一个检验，于是就有懒人弄了批量检验。
```R
library(psych)
corr.test(states, use="complete")
```

#### 7.4 t检验
##### 7.4.1 独立样本的t检验
![ttest定义](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/ttest定义.png)  

下面的例子使用的是假设方差不等的双侧检验。
```R
library(MASS)
t.test(Prob ~ So, data=UScrime)
```

##### 7.4.2 非独立样本的t检验
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

##### 7.5.2 多余两组的比较
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