#####################################################################################
###########################                                 #########################
###########################   OUTLIER DETECTION & REMOVAL   #########################
###########################                                 #########################
#####################################################################################

library(outliers)


rm.out<-function(data){
  
  n<-length(data)
  p_val = 0.049
  
  while(p_val<0.05){
    t<-cochran.test(data, rep(1:n,1))  # Test for outliers
    p_val<-t$p.value
    
    if(p_val<0.05){  data<-rm.outlier(data, fill = T, median = T ) }
    
  }
  return(data)
  
}


#####################################################################################
###########################                                 #########################
###########################         EDA AND REGRESSION      #########################
###########################                                 #########################
#####################################################################################


# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(imputeTS)
library(DT)
library(nortest)


# Load data
#timedata <- read.csv("C:/Users/AGGAA/Desktop/Aaditya/Software Training/R/data.csv")
#vars<- names(timedata)


# Define UI
ui_eda <- fluidPage(theme = shinytheme("united"),
                    titlePanel("EDA N REGRESSION ANALYSIS"),
                      
                    fileInput("timedata2", label = h3("Input File here")) ,
                    
                    sidebarPanel(
                      
                      # Select Dependent Variable
                      selectInput(inputId = "var", label = strong("Variables:"), choices = colnames("timedata2")),
                 
                      
                    # Adding Horizontal Line
                      tags$hr(),
                      
                    # Select Predictor Variables
                      checkboxGroupInput(inputId = "rvar", label = strong("Regressor Variables"), choices = vars, selected = vars[c(2,3)])
                      
                    ),
                    
                    
                    mainPanel(
                    tabsetPanel(  
                    tabPanel("Plots", plotOutput(outputId = "n_plot", height = "400px")),
                    tabPanel("Normality Tests", verbatimTextOutput(outputId = "n_test1"),
                                                tags$hr(),
                                                verbatimTextOutput(outputId = "n_test2")),
                    tabPanel("Correlations", dataTableOutput(outputId = "corr")),
                    tabPanel("Regression Results", dataTableOutput(outputId = "summary1"),
                                                 tags$hr(),
                                                 verbatimTextOutput(outputId = "summary2"))

                              )
                            )
                    
)

plot_data<-function(data){
  
  par(mfrow= c(1,3))
  boxplot(data)
  qqnorm(data, col = 2)
  qqline(data, col = 1)
  h<-hist(data, col = "gold", breaks=12,  main="Histogram")
  h
  xfit<-seq(min(data), max(data), length=40)
  yfit<-dnorm(xfit, mean=mean(data), sd=sd(data))
  yfit <- yfit*diff(h$mids[1:2])*length(data)
  lines(xfit, yfit, col="red", lwd=2)      
  box()  #adds box to existing diagram
  
}

# Define server function
server_eda <- function(input, output) {
  
  
  # Create Normality plots object the plotOutput function is expecting
      output$n_plot <- renderPlot(
              plot_data(timedata[,input$var])
              )
      
  # Tests for Normality
      #Shapiro-Test
      output$n_test1<-renderPrint(
        shapiro.test(timedata[,input$var])
      )
      
      # Anderson Darling Test
      output$n_test2<-renderPrint(
        ad.test(timedata[,input$var])
      )    
      
      
 # Correlation Analysis
    output$corr<-renderDataTable(
        datatable(as.matrix(cor(timedata[,input$rvar], method = "pearson")))
      )
      
      
 # Builnding Regresion Model     
      lm1<-reactive({
          lm(paste(input$var, '~' , paste(input$rvar, collapse = '+') , sep = ''), data = timedata)
    })
        
  output$summary1<- renderDataTable(
    datatable(summary(lm1())$coefficients)
    
    
  )
  
 # Regression Results    
      
      output$summary2<-renderPrint(
      print(cat(paste("R.Sq =",  summary(lm1())$adj.r.squared, "  , F value = ",  summary(lm1())$fstatistic[1], "\n", sep = ' '), 
                            paste("Dependent Variable : ", input$var, "\n"),
                            paste("Independent variables : ", paste(input$rvar,collapse = " ,"))
              ))
    )
      
      
      
      
}


# Create Shiny object
shinyApp(ui = ui_eda, server = server_eda)





#####################################################################################
###########################                                 #########################
###########################         CLUSTERING OF DATA      #########################
###########################                                 #########################
#####################################################################################




##################################################################################
######################### < Non Hierarchical Clustering > ########################

##################################################################################

mydata<- data.frame("mpg" = mtcars$mpg, "wt" = mtcars$wt)

# Prepare Data
mydata <- na.omit(mydata) # listwise deletion of missing
mydata <- scale(mydata) # standardize variables

# Determine number of clusters
wss <- (nrow(mydata)-1)*sum(apply(mydata,2,var))
for (i in 2:15) wss[i] <- sum(kmeans(mydata, centers=i)$withinss)
plot(1:15, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")


# K-Means Cluster Analysis
fit <- kmeans(mydata, 5) # 5 cluster solution
# get cluster means 
aggregate(mydata,by=list(fit$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(mydata, fit$cluster)

library(dplyr)
mydata%>%rename("cluster" = "fit.cluster")





#####################################################################################
#########################  < Ward Hierarchical Clustering >  ########################

#####################################################################################

mydata<- data.frame("mpg" = mtcars$mpg, "wt" = mtcars$wt)

# Prepare Data
mydata <- na.omit(mydata) # listwise deletion of missing
mydata <- scale(mydata) # standardize variables


d <- dist(mydata, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward.D") 
plot(fit) # display dendogram
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=5, border="red")



#################################################################################
##############################  < MODEL BASED >  ################################

#################################################################################

# Model Based Clustering
library(mclust)
fit <- Mclust(mydata)
plot(fit) # plot results 
summary(fit) # display the best model


##################################################################################

#Plotting Cluster Solutions

#It is always a good idea to look at the cluster results.

# K-Means Clustering with 5 clusters
fit <- kmeans(mydata, 5)

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
library(cluster) 
clusplot(mydata, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
library(fpc)
plotcluster(mydata, fit$cluster)



#####################################################################################



#####################################################################################
###########################                                 #########################
###########################     BASIC DATA MANIPULATIONS    #########################
###########################                                 #########################
#####################################################################################



library("xlsx")
url<-"http://www.stern.nyu.edu/~adamodar/pc/datasets/histretSP.xls"
download.file(url, destfile="C:/Users/AGGAA/Downloads/histretSP.xls")
data <- read.xlsx("C:/Users/AGGAA/Downloads/histretSP.xls", 1, startRow=12, endRow=98, headers=TRUE)
View(data)

library(stats)
data<-mtcars
cor(data$mpg, data$wt, use = "pairwise.complete.obs", method = "pearson")

states<- state.x77
cov(states)
cor(states)

library(ggm)
pcor(c(1,2,3), cov(states))   # Partial corr between Var1,Var2 in presence of Var3 in matrix STATES


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
grep("name is",text)
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

#Note that my.cut2 and thus the Agriculture variable corresponds to the rows. There are no values in the last row. 
# We see that the fertility is high with high values of Catholic, while there is no apparent effect of Agriculture.



##################################################################################################################

carb<-mtcars$carb
carb[c(10:12,18:20)]<-NA
carb
carb[is.na(carb)]<-0    # Replaces missing values by "0"
carb

####################################################################################################################



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

#####################################################################################
###########################                                 #########################
###########################  PRINCIPAL COMPONENT ANALYSIS   #########################
###########################                                 #########################
#####################################################################################


head(mtcars)
data<- mtcars
data <- subset(data, select = -hp)
head(data)
prcomp(data)  # Generates Principle Components


###########################################################################################################


#####################################################################################
###########################                                 #########################
###########################  	    	DPLYR PACKAGE     	    #########################
###########################                                 #########################
#####################################################################################

library(VIM)
matrixplot(sleep)

x <- as.data.frame(abs(is.na(sleep)))
y <- x[which(sd(x) > 0)]  # extracts the variables that have some (but not all) missing values

require(dplyr)

# Data file
file <- "https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"
download.file(file, destfile = "file.csv")

# Some sensible variable names
df_names <- c("age", "wrkclass", "fnlweight", "education_lvl", "edu_score",
              "marital_status", "occupation", "relationship", "ethnic", "gender",
              "cap_gain", "cap_loss", "hrs_wk", "nationality", "income")

df <- read.csv("file.csv", header = F, sep = ",",na.strings = c(" ?", " ", ""), row.names = NULL, col.names = df_names)


# Remove duplicate rows and check number of rows
df %>% distinct() %>% nrow()

# Drop duplicate rows and assign to new dataframe object
df_clean <- df %>% distinct()

# Drop duplicates based on one or more variables
df %>% distinct(gender, .keep_all = T)
df %>% distinct(gender, education_lvl, .keep_all =  T)

# Sample random rows with or without replacement
sample_n(df, size = nrow(df) * 0.7, replace = F)
sample_n(df, size = 20, replace = T)

# Sample a proportion of rows with or without replacement
sample_frac(df, size = 0.7, replace = F)
sample_frac(df, size = 0.8, replace = T)

# Rename one or more variables in a dataframe
df <- df %>% rename("INCOME" = "income")

df <- df %>% rename("INCOME" = "income", "AGE" = "age")

# Select specific columns (note that INCOME is the new name from earlier)
df %>% select(education_lvl, INCOME) 

# With dplyr 0.7.0 the pull() function extracts a variable as a vector
df %>%  pull(age)

# Drop a column using the - operator (variable can be referenced by name or column position)
df %>% select(-edu_score)

df %>% select(-1, -4)

df %>% select(-c(2:6))

# Select columns with their names starting with "e"
df %>% select(starts_with("e"))

# The negative sign works for dropping here too
df %>% select(-starts_with("e"))

# Select columns with some pattern in the column name
df %>% select(contains("edu"))

# Reorder data to place a particular column at the start followed by all others using everything()
df %>% select(INCOME, wrkclass, everything())

# Select columns ending with a pattern
df %>% select(ends_with("e"))

df %>% select(ends_with("_loss"))




#################  FILTERING DATA  #################


# Filter rows to retain observations where age is less than 30 and age is greater than 20
df %>% filter(AGE < 30 & AGE > 20)
df %>% filter(AGE < 30 & relationship == " Wife")

# Filter by multiple conditions using the %in% operator (make sure strings match)
df %>% filter(relationship %in% c(" Unmarried", " Wife"))

# You can also use the OR operator (|)
df %>% filter(relationship == " Husband" | relationship == " Wife")

# Filter using the AND operator
df %>% filter(age > 30 & INCOME == " >50K")

# Combine them too
df %>% filter(education_lvl %in% c(" Doctorate", " Masters") & age > 30)

# The NOT condition (filter out doctorate holders)
df %>% filter(education_lvl != " Doctorate")

# The grepl() function can be conveniently used with filter()
df %>% filter(grepl(" Wi", relationship))



##############  SUMMARISING DATA  ############

df <- df %>% rename("age" = "AGE")
df %>% filter(INCOME == " >50K") %>% summarise(mean_age = mean(age), median_age = median(age), sd_age = sd(age))
df %>% filter(INCOME == " >50K") %>% summarise_at(vars(age, hrs_wk), funs(n(), mean, median))

# We can also summarise with custom functions
# The . in parentheses represents all called variables
df %>% summarise_at(vars(age, hrs_wk), funs(n(), missing = sum(is.na(.)), mean = mean(., na.rm = T)))

# Create a new summary statistic with an anonymous function
df %>% summarise_at(vars(age), function(x) { sum((x - mean(x)) / sd(x)) })

# Summarise conditionally using summarise_if()
df %>% filter(INCOME == " >50K") %>% summarise_if(is.numeric, funs(n(), mean, median))

# Subset numeric variables and use summarise_all() to get summary statistics
ints <- df[sapply(df, is.numeric)] 
summarise_all(ints, funs(mean, median, sd, var))




####################  SORTING  ##################

# Sort by ascending age and print top 10
df %>% arrange(age) %>% head(10)

# Sort by descending age and print top 10
df %>% arrange(desc(age)) %>% head(10)

# The group_by verb is extremely useful for data analysis
df %>%  group_by(gender) %>% summarise(Mean = mean(age))
df %>% group_by(relationship) %>% summarise(total = n())
df %>% group_by(relationship) %>% summarise(total = n(), mean_age = mean(age))




##################  Creating New Variables  #################

# Create new variables from existing or global variables
df %>% mutate(norm_age = (age - mean(age)) / sd(age))

# Multiply each numeric element by 1000 (the name "new" is added to the original variable name)
df %>% mutate_if(is.numeric, funs(new = (. * 1000))) %>%  head()



#############  MERGING DATA  #############

# Create ID variable which will be used as the primary key
df <- df %>%  mutate(ID = seq(1:nrow(df))) %>% select(ID, everything())

# Create two tables (purposely overlap to facilitate joins)
table_1 <- df[1:50 , ] %>% select(ID, age, education_lvl)

table_2 <- df[26:75 , ] %>% select(ID, gender, INCOME)

# Left join joins rows from table 2 to table 1 (the direction is implicit in the argument order)
left_join(table_1, table_2, by = "ID")

# Right join joins rows from table 1 to table 2
right_join(table_1, table_2, by = "ID")

# Inner join joins and retains only complete cases
inner_join(table_1, table_2, by = "ID")

# Full join joins and retains all values
full_join(table_1, table_2, by = "ID")



######################################################################
############### Pipe Operator #############

filteredData <- filter(airquality, Month != 5)
groupedData <- group_by(filteredData, Month)
summarise(groupedData, mean(Temp, na.rm = TRUE))

#With piping, the above code can be rewritten as:
airquality %>% filter(Month != 5) %>% group_by(Month) %>% summarise(mean(Temp, na.rm = TRUE))



###########################################################################
  
library("corrplot")
housing<-read.table(file.choose())
colnames(housing) <- c("CRIM","ZN","INDUS","CHAS","NOX","RM","AGE","DIS","RAD","TAX","PRATIO","B","LSTAT","MDEV")
View(housing)

corrplot(cor(housing), method = "number", tl.cex = 1)

library("caret")
View(housing)

housing <- housing[order(housing$MDEV),]

set.seed(3277)
trainingIndices <- createDataPartition(housing$MDEV, p=0.75, list=FALSE)  # Extracting 75% of data for training purpose
housingTraining <- housing[trainingIndices,]
housingTesting <- housing[-trainingIndices,]
 nrow(housingTraining)
 nrow(housingTesting)
 nrow(trainingIndices)
 
# Method 1 : Linear model
linearModel <- lm(MDEV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PRATIO + B + LSTAT, data=housingTraining)
summary(linearModel)
predicted <- predict(linearModel,newdata=housingTesting)

sumsq1<-sum((predicted - housingTesting$MDEV)^2)   # sUMsQ value very large hence model is inappropriate

#Method 2 : Logistic Regression
logModel <- glm(MDEV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PRATIO + B + LSTAT, data=housingTraining)
summary(logModel)
pred <- predict(logModel,newdata=housingTesting)

sumsq2<-sum((pred - housingTesting$MDEV)^2)   # sUMsQ value very large hence model is inappropriate


# Method 3 : Least Squares

plot(housingTesting$MDEV, predicted)
line<-lm(predicted~housingTesting$MDEV)   # Regression of type (a + b*x)
abline(c(line$coefficients[1],line$coefficients[2]), col = 2)   # Plot doesn't justify the linear relationship


# Method 4 : Relative Importance
library("relaimpo")
calc.relimp(linearModel,type=c("lmg","last","first","pratt"), rela=TRUE)

#Tthe lmg column is the coefficient of the variable from the model.
#The last column (also called usefulness) looks at what the effect of adding this variable into the model would be, effectively removing it, on the other
   #variables. We are looking for the last values greater than lmg, as those variables are generating more effect. This would include NOX, DIS, RAD,
   #PRATIO, and LSTAT.
#The first column (squared covariance between y and the variable) looks at the variable as if none of the other variables were present in the model. We are
   #interested in cases where the first column value is greater than lmg, as those variables are truly generating more effect. These include CRIM, ZN, INDUS,
   #NOX, AGE, RAD, and B.
#The pratt column (product of the standard coefficient and the correlation) is based on Pratt's contribution in 1987. The downfall is that negative values
  #need to be ignored as not applicable. We are again looking for pratt values over lmg such as CRIM, ZN, RM, and PRATIO.
#The most interesting part of the results is the detail that the variables provided only explain 76 percent of the value. This is a pretty good number, but we did not end up being accurate.


#METHOD 4 : Stepwise

step <- stepAIC(linearModel, direction="both")

#It is interesting to see that INDUS (percentage of industrial zoning) has the largest effect in this
# model and LSTAT (lower-income status population) is really negligible.







#####################################################################################
###########################                                 #########################
###########################   LINEAR REGRESSION ANALYSIS    #########################
###########################                                 #########################
#####################################################################################

states <- as.data.frame(state.x77[,c("Murder", "Population", "Illiteracy", "Income", "Frost")])
fit1<-lm(Population~Murder+Income, data = states)
fit2<-lm(Population~Murder+Income-1, data = states) #Excludes Intercept
fit3<-lm(Population~Murder+Income+I(Income^2), data = states) # 'I' fn. retains function in parenthesis as R object
fit4<-lm(Population~Murder+Income+Murder:Income, data = states)# ':' shows interaction effect
fit5<-lm(Population~(Murder+Income+Illiteracy)^2, data = states) # limits interactions two 2nd level
fit6<-lm(Population~(Murder*Income*Illiteracy), data = states)  # All levels of possible interaction included
summary(fit1)
summary(fit2)
summary(fit3)
summary(fit4)
summary(fit5)
summary(fit6)



This is a test document  
**New Line** begins *here*  
#RStudio 
  To know more on this, [click here](www.rstudio.com) 
##**Image** 
image: ![](C:\Users\AGGAA\Downloads\Aaditya.jpg)  

Goto next slide

*** 
>Tables
*Main table
+sub-table  

Name  |  Id
----- | ----
Aa    |  1
Pr    |  2





########################################################################################
#############################                          #################################  
#############################  MISSING DATA IMPUTATION #################################
#############################                          #################################
########################################################################################

library(missForest)
iris.miss<-prodNA(iris, noNA = 0.1)  # Artificially deletes 10% of observations
summary(iris.miss)
summary(iris)

#removing categorical variables
iris.miss<-subset(iris.miss, select = -c(Species))


library(mice)
md.pattern(iris.miss)


install.packages("VIM")
library(VIM)
mice_plot <- aggr(iris.miss,numbers=TRUE, sortVars=TRUE,
                    labels=names(iris.miss), cex.axis=.7,gap=3, ylab=c("Missing data","Pattern"))



library(stats)
library(MASS)
library(cars)

mpg<-mtcars$mpg
var1<-mtcars$wt
var2<-mtcars$wt+mtcars$drat

cor(var1,var2)

fit<- lm(mpg~var1+var2)
summary(fit)

vif(fit)

fit1<-lm(var1~var2)
summary(fit1)

lm.ridge(fit) #Ridge regression in case of Multicollinearity






####################################################################################3
###########################                                 #########################
###########################   OUTLIER DETECTION & REMOVAL   #########################
###########################                                 #########################
#####################################################################################

library(outliers)


rm.out<-function(data){
  
  n<-length(data)
  p_val = 0.049
  
  while(p_val<0.05){
  t<-cochran.test(data, rep(1:n,1))  # Test for outliers
  p_val<-t$p.value
  
  if(p_val<0.05){  data<-rm.outlier(data, fill = T, median = T ) }
  
  }
  return(data)
  
}




####################################################################################3
###########################                                 #########################
###########################       TREND AND SEASONALITY     #########################
###########################                                 #########################
#####################################################################################


# Testing for Trend

ro.test <- function (y = timeseries){
  n<-length(y)
  q<-0
  for(i in 1:(n-1))
  {
    for(j in (i+1):n)
    {
      if(y[i]>y[j])
      {
        q<-q+1
      }
    }
  }
  eq<-n*(n-1)/4
  tau<-1-(4*q/(n*(n-1)))
  var_tau<-(2*(2*n+5))/(9*n*(n-1))
  z<-tau/sqrt(var_tau)
  if(z>0)
  {
    p_value<-1-pnorm(z)
  }
  if(z<0)
  {
    p_value<-pnorm(z)
  }
  cat("            Relative Ordering Test for Presence of Trend \n\n")
  cat("Null Hypothesis: Absence of Trend, and \n")
  cat("Alternative Hypothesis: Presence of Trend. \n\n")
  cat("Test Statistic:",paste(round(z,4)),"\n")
  cat("p_value:", paste(round(p_value,4)),"\n")
  cat("No. of Discordants:",paste(q),"\n")
  cat("Expected No. of Discordants:",paste(eq),"\n")
}


# Testing for Seasonality

friedmann.test <- function (y = timeseries, r = seasons){
  n<-length(y)
  c<-n/r
  data<-matrix(y,r,c)
  rank<-matrix(y,r,c)
  for (i in 1:c)
  {
    rank[,i]<-rank(data[,i])
  }
  obsranksums<-rowSums(rank)
  expranksums<-rep(c*(r+1)/2,r)
  sumofsquares<-sum((obsranksums-expranksums)^2)
  chi_square<-sumofsquares/(c*(r+1)/2)
  p_value<-1-pchisq(chi_square,r-1)
  
  cat("            Freidman (JASA) Test for Presence of Seasonality \n\n")
  cat("Null Hypothesis: Absence of Seasonality, and \n")
  cat("Alternative Hypothesis: Presence of Seasonality. \n\n")
  cat("Test Statistic:",paste(round(chi_square,4)),"(Chi Sqaure with",paste(r-1),"df)","\n")
  cat("p_value:", paste(round(p_value,4)),"\n")
}


#####################################
#####  TIME SERIES ANALYSIS   #######
#####################################

data<- ts(AirPassengers)
library(forecast)
tsclean(data)  #Used to deal missing values and outliers removal
plot(data)
ro.test(data)  #Code from file ro.test
library(Kendall)
MannKendall(data)
friedmann.test(data)  #Code from file ro.test
SeasonalMannKendall(data)

time<-c(1:144)
time1<-time^2
fit<-lm(data~time)
fit1<-lm(data~time+time1)

#Determining Trend
plot(data)
lines(fit$fitted.values, col = 2)
lines(fit1$fitted.values, col = 4)
summary(fit)
summary(fit1)

trend<-fit1$fitted.values
detrend<-data-trend
plot(detrend)
library(tseries)
adf.test(detrend)

#Determining seasonality
se=0.0
sf=0.0
for(i in 1:12){
  se[i]=0.0
  for(j in 0:11){
    se[i]=se[i]+detrend[i+12*j]
    }
  sf[i]=se[i]/12
}

for(i in 1:12){print(paste("Seasonal Factor ", i, ": ",sf[i]))}

#Checking Stationarity of residuals
seasons<-rep(sf,12)
residual<-detrend-seasons
plot(residual)
adf.test(residual)


#Predicting Data

int<-fit1$coefficients[1]
t1<-fit1$coefficients[2]
t2<-fit1$coefficients[3]

print("Predicted data for next 5 years is:")

for (i in 1:24) {
p[i]<-int+t1*(144+i)+t2*(144+i)^2+sf[i-12*i%%12]
print(p[i])
}
plot(p, type = "l")

