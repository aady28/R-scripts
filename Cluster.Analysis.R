##################################################################################
#########################                                 ########################
#########################         CLUSTER ANALYSIS        ########################
#########################                                 ########################
##################################################################################



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

