# 7 统计基本分析
install.packages(c("ggm", "gmodels", "vcd", "Hmisc","pastecs", "psych", "doBy")) 

# 数据载入
mt <- mtcars[c("mpg", "hp", "wt", "am")]
head(mt)

# 查看描述性统计量
# summary
mt <- mtcars[c("mpg", "hp", "wt", "am")]
summary(mt)

# sapply
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

# describe
library(Hmisc)
myvars <- c("mpg", "hp", "wt")
describe(mtcars[myvars])

# stat.desc()
library(pastecs)
myvars <- c("mpg", "hp", "wt")
stat.desc(mtcars[myvars])

# psych包中的describe()
library(psych)
myvars <- c("mpg", "hp", "wt")
describe(mtcars[myvars])

# aggregate()
myvars <- c("mpg", "hp", "wt")
aggregate(mtcars[myvars], by=list(am=mtcars$am), mean)
aggregate(mtcars[myvars], by=list(am=mtcars$am), sd)

# by()
dstats <- function(x)sapply(x, mystats)
myvars <- c("mpg", "hp", "wt")
by(mtcars[myvars], mtcars$am, dstats)

# summaryby
library(doBy)
summaryBy(mpg+hp+wt~am, data=mtcars, FUN=mystats)

# describeBy
library(psych)
myvars <- c("mpg", "hp", "wt")
describeBy(mtcars[myvars], list(am=mtcars$am))

# 实例数据集
library(vcd)
head(Arthritis)

# 一维列联表
mytable <- with(Arthritis, table(Improved))
mytable  # frequencies
prop.table(mytable) # proportions
prop.table(mytable)*100 # percentages

# 二维列联表
mytable <- xtabs(~ Treatment+Improved, data=Arthritis)
mytable # frequencies
margin.table(mytable,1) #row sums
margin.table(mytable, 2) # column sums
prop.table(mytable) # cell proportions
prop.table(mytable, 1) # row proportions
prop.table(mytable, 2) # column proportions
addmargins(mytable) # add row and column sums to table

# more complex tables
addmargins(prop.table(mytable))
addmargins(prop.table(mytable, 1), 2)
addmargins(prop.table(mytable, 2), 1)

# crosstable
library(gmodels)
CrossTable(Arthritis$Treatment, Arthritis$Improved)

# 多维列联表
mytable <- xtabs(~ Treatment+Sex+Improved, data=Arthritis)
mytable

ftable(mytable) 

margin.table(mytable, 1)
margin.table(mytable, 2)
margin.table(mytable, 2)
margin.table(mytable, c(1,3))

ftable(prop.table(mytable, c(1,2)))
ftable(addmargins(prop.table(mytable, c(1, 2)), 3))

# 卡方独立性检验
library(vcd)
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
chisq.test(mytable)
mytable <- xtabs(~Improved+Sex, data=Arthritis)
chisq.test(mytable)

# Fisher精确检验
mytable <- xtabs(~Treatment+Improved, data=Arthritis)
fisher.test(mytable)

# Cochran-Mantel-Haenszel检验
mytable <- xtabs(~Treatment+Improved+Sex, data=Arthritis)
mantelhaen.test(mytable)

# 相关性度量
states<- state.x77[,1:6]
cov(states)
cor(states)
cor(states, method="spearman")

# Pearson、 Spearman和Kendall相关
states<- state.x77[,1:6]
cov(states)
cor(states)
cor(states, method="spearman")

x <- states[,c("Population", "Income", "Illiteracy", "HS Grad")]
y <- states[,c("Life Exp", "Murder")]
cor(x,y)

# 偏相关
library(ggm)

pcor(c(1,5,2,3,6), cov(states))

# 相关性检验 cor.test
cor.test(states[,3], states[,5])

# 相关性检验 corr.test
library(psych)
corr.test(states, use="complete")

# t.test
library(MASS)
t.test(Prob ~ So, data=UScrime)

sapply(UScrime[c("U1","U2")], function(x)(c(mean=mean(x),sd=sd(x))))
with(UScrime, t.test(U1, U2, paired=TRUE))

# wilcoxtest
with(UScrime, by(Prob, So, median))
wilcox.test(Prob ~ So, data=UScrime)

sapply(UScrime[c("U1", "U2")], median)
with(UScrime, wilcox.test(U1, U2, paired=TRUE))

# Kruskal-Wallis检验
states <- data.frame(state.region, state.x77)
kruskal.test(Illiteracy ~ state.region, data=states)

# 案例
source("http://www.statmethods.net/RiA/wmc.txt")              
states <- data.frame(state.region, state.x77)
wmc(Illiteracy ~ state.region, data=states, method="holm")