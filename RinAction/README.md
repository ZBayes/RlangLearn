# R语言实战阅读笔记
阅读这本书然后进行笔记，方便起见参考文献写最前面。  
[1] Robert, I, Kabacoff. [R语言实战](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R语言实战.pdf)[M]. 北京:中国工信出版集团, 人民邮电出版社, 2016.  
[2] 刘重杰. [R数据的导入与导出](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R数据的导入与导出.pdf)[EB/OL]. https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R数据的导入与导出.pdf.  

## 2 创建数据集
**C2_createDateSet.R**
数据的创建、导入和整理等。
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

### 2.3 数据输入
这块内容个人打算随用随查，所以暂时不打算详细学，另外编者提供了一个文档，有PDF版本[R数据的导入与导出](https://github.com/ZBayes/RlangLearn/blob/master/RinAction/R数据的导入与导出.pdf)。

### 2.4 数据集的标注
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

### 2.5 处理数据对象的实用函数
两张截屏搞定：
![数据处理对象函数1](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据处理对象函数1.png)  
![数据处理对象函数2](https://raw.githubusercontent.com/ZBayes/RlangLearn/master/RinAction/pic_temp/数据处理对象函数2.png)  

## 3 图形初阶
本章主要讲解了图形的创建、自定义符号、线条和坐标轴、标注文本和标题，控制图形难度，组合多个图形。

### 3.1 使用图形
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
于是将图像进行一定的修改。
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

然后是添加文本，自定义坐标轴和图例。
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
