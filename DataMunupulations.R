sq<-function(x){
  x*x
}
sq(1:5)
set.seed(1234)
rnorm(200)
median(rnorm(200))


iter<-stats::rpois(10, lambda = 10)
iter

cat("",iter<- iter+1,"\n",sep = "\n")

###############################################################################################################

d1<-data.frame(a=c(1,3),b=c("a1","a2"))
d1
d2<-data.frame(a=1:3,b=4:6)
d2

for(x in d1){
  cat("colMean :",mean(x),"\n")
}

dat1<-data.frame(x=c("a1","a2","a3"),y=c(1,2,3))
dat1
dat2<-data.frame(x1=c("a2","a1","a3"),y1=c(4,5,6))

merge(dat1,dat2) #vertical merging
merge(dat1, dat2, by.x = "x",by.y = "x1")     # horizontal merging through column1 i.e x and x1


str(dat1)            #gives structure of any data

library(backports)
library(Hmisc)
describe(dat1)


#################################################################################################################

text<- c("Hello my","name is","Aaditya")

grep("name",text)     #Finds the position of a string 
grep("nameis",text)
grepl("name",text)

sub("Aaditya","Aady",text)    #Replaces string

#################################################################################################################

f1<-c("Apple: 3   Orange: 9   Banana:2")
f2<-c("Apple: 3  Banana: 9   Orange:2")
f3<-c("Orange: 3   Apple: 9   Banana:2")

#       [ :]* a sequence of whitespace OR colon followed by
#       ([0-9]*) a sequence of digits followed by ..
               # Paranthesis around digit func stores this match,this is accessed by back refrence \\1

#       .*  sequence of arbitrary factors (possibly empty)


df<-data.frame(Id=1:3, fruit = rbind(f1,f2,f3))

df
pattern<- ".*orange[ :]*([0-9]*).*"
sub(pattern, "\\1",df$fruit, ignore.case=TRUE)


searchpaths()[1:3]    #to search priority of search paths/locations

###############################################################################################################

set.seed(1001)
a<-runif(12)
b<-c(a[1:6],0.0012172,a[7:10],0.999999)

m<-match(a,b) # Matches the values of a in b and gives corresponding indices
m1<-is.na(m)  # Converts matched results to logical
which(m1) # Gives indices for NA values i.e. unmatches values
which(!m1) # Deletes NA values' indices i.e. unmatches values


###############################################################################################################
x<-matrix(1:45, nrow = 5)
sapply(x, mean)
vapply(1:45,sum)


head(trees)
apply(trees,2,mean) # has the effect of calculating the mean of each column (dimension 2) of trees. 
                    # We'd have used a 1 instead of a 2 if we wanted the mean of every row.


####################################################################################################################


df<-data.frame(Admit = c("True","False","True","False"),Gender = c("M","F","F","M"), Dept = c("A","B","A","B"), Freq = c(24,117,432,450))
mytable<-xtabs(Freq~Admit+Gender+Dept, data = df)
ftable(mytable)

prop.table(margin.table(mytable, c(1,3)),1)


####################################################################################################################


my.cut2<-cut(swiss$Agriculture,breaks=10*(0:10))  #classifies every value of the variable into 10 class 
                                                  #intervals of length 10 each
my.cut3<-cut(swiss$Catholic,breaks=10*(0:10))
tapply(swiss$Fertility,list(my.cut2,my.cut3),mean)

#Note that my.cut2 and thus the Agriculture variable corresponds to the rows. There are no values in the last row. We see that the fertility is high with high values of Catholic, while there is no apparent effect of Agriculture.



##################################################################################################################

carb<-mtcars$carb
carb[c(10:12,18:20)]<-NA
carb
carb[is.na(carb)]<-0    # Replaces missing values by "0"
carb

####################################################################################################################


head(mtcars)
data<- mtcars
data <- subset(data, select = -hp)
head(data)
prcomp(data)  # Generates Principle Components


##################################################################################################################

# Mapping Variables to matching Codes

df<-data.frame(names=c("a1","a2","a3"), codes = c(3,1,2))
dat<- data.frame(var=c("country1","country2","country3"), codes = c(1,2,3))

r4<-data.frame(names="a4",codes=1)

df<-rbind(df,r4)
df
dat
merge(df,dat)

#######################################################################################################################

# Binning and plotting the tables

y <- c(10, 21, 56,79,114,122,110,85,85,61,47,49,47,44,31,20,11,4,4)
x <- 14.5 + c(0:length(y))
q<-quantile(y)
cut(y,q)               # Binning of y with bins at q
t<-table(cut(y,q))
plot(t)
d<-data.frame(q[1:4],levels(cut(y,q)))

library(gridExtra)
library(grid)

grid.table(d)
grid.table(t)

d <- head(iris[,1:3])
grid.table(d)


x <- 2:18
v <- c(5, 10, 15) # create two bins [5,10) and [10,15)
cbind(x, findInterval(x, v))


library(ash)
x <- matrix( rnorm(200), 100 , 2)       # bivariate normal n=100
ab <- matrix( c(-5,-5,5,5), 2, 2)       # interval [-5,5) x [-5,5)
nbin <- c( 20, 20)                      # 400 bins
bins <- bin2(x, ab, nbin)               # bin counts,ab,nskip

#####################################################################################################################

############## BASIC GRAPHS ###########

library(vcd)
counts<-table(Arthritis$Improved, Arthritis$Treatment)
barplot(counts)
barplot(counts, col=c("blue","green","yellow"))
barplot(counts, col=c("orange","green","yellow"),beside = T)
barplot(counts, col=c("orange","green","yellow"),beside = T, legend = row.names(counts))

barplot(counts, col=c("orange","green","yellow"),beside = T, legend = row.names(counts), horiz = T)
par(las=2)
barplot(counts, col=c("orange","green","yellow"),beside = T, legend = row.names(counts), horiz = T,cex.names = 0.8)

# Producing spinograms
attach(Arthritis)
spine(Improved~Treatment)
detach(Arthritis)

# Plotting Pie charts
v<-c(2,10,20)
pie(v, labels = v, col = c("grey","blue","yellow"))

      # 3-D chart
      library(plotrix)
      pie3D(v, labels = v, col = c("grey","yellow","black"), explode = 0.22)

# Histogram
      x <- mtcars$mpg 
      h<-hist(x,
              col = "gold",
              breaks=12,
              xlab="Miles Per Gallon",
              main="Histogram with normal curve and box")
      xfit<-seq(min(x), max(x), length=40)
      yfit<-dnorm(xfit, mean=mean(x), sd=sd(x))
      yfit <- yfit*diff(h$mids[1:2])*length(x)
      lines(xfit, yfit, col="red", lwd=2)      
   box()  #adds box to existing diagram

# Boxplots
   boxplot(mpg~cyl, data = mtcars) 

# Dotchart
 dotchart(mtcars$mpg, lcolor = "grey",color = "red", labels = rownames(mtcars), cex = .6, pch = 2)
 
# Scatterplots
 library(car)
 scatterplot(weight ~ height,
             data=women,
             spread=FALSE, lty.smooth=2,
             pch=19,
             main="Women Age 30-39",
             xlab="Height (inches)",
             ylab="Weight (lbs.)")
# The lty.smooth=2 option specifies that the loess fit be rendered as a dashed line
# pch=19 options display points as filled circles (the default is open circles)
 
####################  DESCRIPTIVES  ####################
 
 library(backports)
 library(Hmisc)
 describe(dat1)

 library(pastecs) 
 stat.desc(mtcars)

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
library(doBy)
summaryBy(mpg+hp+wt~am, data = mtcars, FUN = mystats) 



############  Contingency tables  ###############

mytable<-xtabs(~Treatment+Sex+Improved, data = Arthritis)
margin.table(mytable,2)  # Marginal Table
mytable1<-xtabs(~Sex+Improved, data = Arthritis)
chisq.test(mytable1)  # Test for indep. of Attributes


############# Missing Data Analysis #################

library(VIM)
matrixplot(sleep)

x <- as.data.frame(abs(is.na(sleep)))
y <- x[which(sd(x) > 0)]  # extracts the variables that have some (but not all) missing values

