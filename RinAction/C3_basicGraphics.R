# 3 图形初阶
pdf("myGraph.pdf")
  attach(atcars)
  plot(wt,mpg)
  abline(lm(mpg~wt))
  title("Regression of MPG and WT")
  detach(atcars)
dev.off()

# 简单例子
dose<-c(20,30,40,45,60)
drugA<-c(16,20,27,40,60)
drugB<-c(15,18,25,31,40)
plot(dose,drugA,type = "b")

# 图形参数
opar<-par(no.readonly = TRUE)
par(lty=2,pch=17)
plot(dose,drugA,type = "b")
par(opar)

