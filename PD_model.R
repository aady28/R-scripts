
setwd('C:/Users/AGGAA/Desktop/Aaditya/Data')
macro_data<- read.csv(file = "US_economy_data.csv", header = T)  # Macro-variable annual data for 19 yrs
  
obl_data<- read.csv(file = "Obligor_data.csv", header = T) # FSO and CCA EDFS for obligors


# plot(obl_data$Obligor, obl_data$CCA, type = "l")

rho <- 0.3  # Correlation between Zt and FSO EDF

Zt <- dnorm((qnorm(obl_data$FSO) - sqrt(1-rho)*obl_data$CCA)/sqrt(rho))  #Calculation of Zt
mean(Zt)
var(Zt)

vars<- colnames(macro_data)[-1]
master_data<- cbind(macro_data,Zt)

options("scipen"=100, "digits"=4)  # to change formatting of numbers from exponential to decimal

j<-1
for (i in vars) {
   fit<- lm(paste("Zt","~",i,sep = ''), data = master_data)
   f<- c(j,": ",summary(fit)$coefficients, "Adj.Rsq"=summary(fit)$adj.r.squared)
   print(f)
   j<-j+1
}

library(tseries)
adf.test(macro_data$GDP)
g<-diff(diff(diff(diff(macro_data$GDP))))
adf.test(g)
g1<-NULL
g1[5:19]<-g

fit1<-lm(paste("Zt","~",paste(vars[-3],collapse =  "+"),sep = ''), data = master_data)
summary(fit1)

library(car)

vif(fit1)

fit1<-lm(paste("Zt","~",paste(vars[-c(3,5)],collapse =  "+"),sep = ''), data = master_data)
summary(fit1)

vif(fit1)  #VIF test

cor(master_data[c(2,3,5)])  #Correlation analysis of factor variables

#Test for normality of residuals
shapiro.test(fit1$residuals)
qqnorm(fit1$residuals)
qqline(fit1$residuals)

durbinWatsonTest(fit1) #Test for Auto-correlation

plot(fit1)  # Plot of residuals vs fitted values to check for hetroscedasiticity
cor.test(fit1$fitted.values, fit1$residuals, method = "spearman")  #Spearman Rank Cor Test for hetroscedasticity
ncvTest(fit1)

#################################
# Out of sample model validation

validation_data<-master_data[1:14,]

fit2<-lm(paste("Zt","~",paste(vars[-c(3,5)],collapse =  "+"),sep = ''), data = validation_data)
summary(fit2)

vif(fit2)  #VIF test

cor(validation_data[c(2,3,5)])  #Correlation analysis of factor variables

#Test for normality of residuals
shapiro.test(fit2$residuals)
qqnorm(fit2$residuals)
qqline(fit2$residuals)

durbinWatsonTest(fit2) #Test for Auto-correlation

plot(fit2)  # Plot of residuals vs fitted values to check for hetroscedasiticity

cor.test(fit2$fitted.values, fit2$residuals, method = "spearman")  #Spearman Rank Cor Test for hetroscedasticity
ncvTest(fit2)

plot(range(master_data$Year),range(fit1$fitted.values), type = "n")
lines(master_data$Year, fit1$fitted.values, col=2, type = "b")







