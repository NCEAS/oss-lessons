#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 9
# "Meta-Analysis of Diagnostic Test Accuracy Studies"
#
#


library(meta)
library(mada)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





# 1. Load MR dataset (Scheidler 1997, Table 3)
data16 <- read.csv("dataset16.csv", as.is=TRUE)
# 2. Print dataset
data16
# 3. Calculate sensitivity
round(data16$tp / data16$n1, 4)
# 4. Calculate specificity
round(data16$tn / data16$n2, 4)





metaprop(tp, n1, data=data16,
         comb.fixed=FALSE, comb.random=FALSE,
         studlab=paste(author, year))





metaprop(tn, n2, data=data16,
         comb.fixed=FALSE, comb.random=FALSE,
         studlab=paste(author, year))





metabin(tp, n1, n2-tn, n2, data=data16, sm="OR",
        comb.fixed=FALSE, comb.random=FALSE,
        studlab=paste(author, year),
        addincr=TRUE, allstudies=TRUE)





args(madad)





# The following command generates an error message
# md1 <- madad(data16)





data16$TP <- data16$tp
data16$FN <- data16$n1 - data16$tp
data16$FP <- data16$n2 - data16$tn
data16$TN <- data16$tn
md1 <- madad(data16)





print(md1, digits=2)





# madad(data16, correction.control="none")





# pdf(file="Schwarzer-Fig9.2.pdf", width=10) # uncomment line to generate PDF file
# Changes to plot layout:
# - two plots (columns) in one row (argument mfrow)
# - use maximal plotting region (argument pty)
oldpar <- par(mfrow=c(1,2), pty="m")
# Forest plot for sensitivities
forest(md1, type="sens", main="Sensitivity")
# Forest plot for specificities
forest(md1, type="spec", main="Specificity")
# Use previous graphical settings
par(oldpar)
# invisible(dev.off()) # uncomment line to save PDF file





# pdf(file="Schwarzer-Fig9.3.pdf", width=6) # uncomment line to generate PDF file
forest(md1, type="DOR", log=TRUE, 
       main="Log diagnostic odds ratio")
# invisible(dev.off()) # uncomment line to save PDF file





#
# Web-appendix only (R code to generate Figure 9.4)
#
# pdf(file="Schwarzer-Fig9.4.pdf", width=10, height=8) # uncomment line to generate PDF file
# Define mean and standard deviation for
# - Non-diseased (mean1, sd1)
# - Diseased (mean2, sd2)
mean1 <- 0
sd1 <- 1
mean2 <- 2
sd2 <- 1.5
# Limits of x-axis
xmin <- -4
xmax <- 8
# Scale and normal distributions
xvals <- seq(xmin, xmax, by=0.1)
dens1 <- dnorm(xvals, mean1, sd1)
dens2 <- dnorm(xvals, mean2, sd2)
zeros <- rep(0, length(dens1))
# Define cutpoint
cutpoint <- 1.5
low <- xvals <= cutpoint
upp <- xvals >= cutpoint
# Plot
curve(dnorm(x, mean1, sd1),
      xmin, xmax,
      xlab="Biomarker", ylab=" ",
      col="lightgray", cex.lab=2)
curve(dnorm(x,mean2,sd2), col="gray", add=TRUE)
# Add TN
polygon(c(xvals[low], rev(xvals[low])),
        c(dens1[low], zeros[low]),
        col = "lightgray", border = "lightgray")
# Add FN
polygon(c(xvals[low], rev(xvals[low])),
        c(dens2[low], zeros[low]),
        col = "darkgray", border = "darkgray")
# Add TP
polygon(c(xvals[upp], rev(xvals[upp])),
        c(dens2[upp], zeros[upp]),
        col = "gray", border = "gray")
# Add FP
polygon(c(xvals[upp], rev(xvals[upp])),
        c(dens1[upp], zeros[upp]),
        col = "black", border = "black")
# Add line for cutpoint
abline(v=cutpoint)
# Add text
text(cutpoint+0.1, 0.40, "Cut-off", adj=0, cex=1.5)
text(xmin, 0.35, "Non-diseased", adj=0, cex=2)
text(3.3, 0.22, "Diseased", adj=0, cex=2)
text(mean1, 0.25, "TN", cex=2)
text(mean1, 0.02, "FN", cex=2, col="white")
text(mean2, 0.15, "TP", cex=2)
text(mean2, 0.02, "FP", cex=2, col="white")
# invisible(dev.off()) # uncomment line to save PDF file





#
# Web-appendix only (R code to generate Figure 9.5)
#
# pdf(file="Schwarzer-Fig9.5.pdf", width=10, height=8) # uncomment line to generate PDF file
oldpar <- par(pty="s") # use a square plotting region
# ROC-Curve: R(t)=1-F(G^{-1}(1-t))
curve(1-pnorm(qnorm(1-x, mean1, sd1), mean2, sd2),
      0.001, 0.999, xlim=c(0,1), ylim=c(0,1),
      xlab="1 - Specificity", ylab="Sensitivity")
points(1-pnorm(cutpoint, mean1, sd1),
       1-pnorm(cutpoint, mean2, sd2),
       pch=16, cex=1.5)
#
# invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





# pdf(file="Schwarzer-Fig9.6.pdf", width=6) # uncomment line to generate PDF file
oldpar <- par(pty="s") # use a square plotting region
plot(1-md1$spec$spec, md1$sens$sens,
     xlim=c(0,1), ylim=c(0,1),
     xlab="False positive rate (1-Specificity)",
     ylab="Sensitivity", pch=16)
# invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





# pdf(file="Schwarzer-Fig9.7.pdf", width=6) # uncomment line to generate PDF file
oldpar <- par(pty="s") # use a square plotting region
ROCellipse(data16, pch=16)
invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





mrfit <- reitsma(data16)
print(summary(mrfit), digits=2)





# pdf(file="Schwarzer-Fig9.8.pdf", width=6) # uncomment line to generate PDF file
oldpar <- par(pty="s") # use a square plotting region
plot(mrfit, predict=TRUE, cex=2)
points(1-md1$spec$spec, md1$sens$sens, pch=16)
# Argument lty=2 gives the dashed line
mslSROC(data16, lty=2, add=TRUE)
# Argument lty=3 gives the dotted line
rsSROC(data16, lty=3, add=TRUE)
# invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





rs <- rsSROC(data16)
lambda <- rs$lambda
c(lambda, 1-lambda)
