#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 5
# "Small-Study Effects in Meta-Analysis"
#
#


library(meta)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





# 1. Read in the data
data11 <- read.csv("dataset11.csv")
# 2. Print structure of R object data11
str(data11)
# 3. Calculate experimental and control event probabilities 
summary(data11$Ee/data11$Ne)
summary(data11$Ec/data11$Nc)





ms1 <- metabin(Ee, Ne, Ec, Nc, data=data11, sm="OR")
# pdf(file="Schwarzer-Fig5.2.pdf", width=10, height=11) # uncomment line to generate PDF file
forest(ms1,
       label.left="NSAIDS worse", label.right="NSAIDS better",
       ff.lr="bold")
# invisible(dev.off()) # uncomment line to save PDF file





#
# Part of web-appendix only
#
# Simulation of K=25 studies (2x2 tables)
# Two groups with group sizes n1 and n2, respectively
# A ~ Binomial(n1, p1), C ~ Binomial(n2,p2)
#
# Sample size distribution following
# Schwarzer, G., Antes, G., Schumacher, M.: Inflation of type I error
# rate in two statistical tests for the detection of publication bias
# in meta-analyses with binary outcomes. Statistics in Medicine 21,
# 2465–2477 (2002)
#
set.seed(1995)
K <- 25
n <- (rlnorm(K, 3.798, sqrt(1.104))%/%2)*2 + 2
n1 <- rbinom(K, n, 0.5)
n2 <- n - n1
# Fixed effect model with true OR=0.8
OR <- 0.8
# p0 random
p0 <- runif(K, 0.05, 0.2)
# p1 calculated
p1 <- p0*OR/(p0*OR + 1 - p0)
#
A <- rbinom(K, n1, p1)
C <- rbinom(K, n2, p0)
#
ms0 <- metabin(event.e=A, n.e=n1, event.c=C, n.c=n2, sm="OR")
#
# pdf(file="Schwarzer-Fig5.3.pdf") # uncomment line to generate PDF file
funnel(ms0)
# invisible(dev.off()) # uncomment line to save PDF file





# plot(ms1$TE, ms1$seTE, ylim=c(max(ms1$seTE), 0))
# plot(exp(ms1$TE), ms1$seTE, ylim=c(max(ms1$seTE), 0),
#      log="x", xlab="Odds Ratio", ylab="Standard error")





# pdf(file="Schwarzer-Fig5.4.pdf") # uncomment line to generate PDF file
funnel(ms1)
# invisible(dev.off()) # uncomment line to save PDF file





args(funnel.meta)





# help(funnel.meta)
# ?funnel.meta





# pdf(file="Schwarzer-Fig5.5.pdf") # uncomment line to generate PDF file
funnel(ms1, comb.random=FALSE, pch=16,
       contour=c(0.9, 0.95, 0.99), 
       col.contour=c("darkgray", "gray","lightgray"))
legend(0.25, 1.25,
       c("0.1 > p > 0.05", "0.05 > p > 0.01", "< 0.01"),
       fill=c("darkgray", "gray","lightgray"), bty="n")
# invisible(dev.off()) # uncomment line to save PDF file





# plot(1/ms1$seTE, ms1$TE/ms1$seTE)





# pdf(file="Schwarzer-Fig5.6.pdf") # uncomment line to generate PDF file
radial(ms1)
# invisible(dev.off()) # uncomment line to save PDF file





metabias(ms1, method="rank")





metabias(ms1, method="linreg")





reg <- lm(I(ms1$TE/ms1$seTE) ~ I(1/ms1$seTE))
summary(reg)





# pdf(file="Schwarzer-Fig5.7.pdf") # uncomment line to generate PDF file
radial(ms1)
abline(reg)
# invisible(dev.off()) # uncomment line to save PDF file





# metabias(ms1, method = "linreg", plotit=TRUE)





metabias(ms1, method = "mm")





metabias(ms1, method = "score")





metabias(ms1, method = "peters")





metabias(ms1, method = "count")





# ms1.asd <- metabin(Ee, Ne, Ec, Nc, data=data11, sm="ASD")





# pdf(file="Schwarzer-Fig5.8.pdf", width=10) # uncomment line to generate PDF file
oldpar <- par(mfrow=c(1,2), pty="s")
ms1.asd <- update(ms1, sm="ASD")
summary(ms1.asd)
funnel(ms1.asd)
metabias(ms1.asd, method = "mm", plotit=TRUE) 
# invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





# pdf(file="Schwarzer-Fig5.9.pdf") # uncomment line to generate PDF file
tf1 <- trimfill(ms1)
class(tf1)
funnel(tf1)
# invisible(dev.off()) # uncomment line to save PDF file





print(tf1, digits=2, comb.fixed=TRUE)





# pdf(file="Schwarzer-Fig5.10.pdf", width=8.2) # uncomment line to generate PDF file
library(metasens)
c1 <- copas(ms1)
plot(c1)
# invisible(dev.off()) # uncomment line to save PDF file





c1$TE.slope





max(c1$seTE)





gamma0 <- min(c1$gamma0.range) + c1$x.slope*diff(c1$gamma0.range)
gamma1 <- min(c1$gamma1.range) + c1$y.slope*diff(c1$gamma1.range)





print(pnorm(gamma0 + gamma1/max(c1$seTE)), digits=2)





print(summary(c1), digits=2)





c1





# pdf(file="Schwarzer-Fig5.11.pdf") # uncomment line to generate PDF file
c2 <- copas(ms1, gamma0.range=c(-1,2), gamma1.range=c(0,1))
plot(c2)
print(summary(c2), digits=2)
# invisible(dev.off()) # uncomment line to save PDF file





l1 <- limitmeta(ms1)
print(l1, digits=2)





# pdf(file="Schwarzer-Fig5.12.pdf") # uncomment line to generate PDF file
funnel(l1)
# invisible(dev.off()) # uncomment line to save PDF file
