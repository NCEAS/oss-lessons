#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 7
# "Multivariate Meta-Analysis"
#
#


library(meta)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





# 1. Read in the data
data14 <- read.csv("dataset14.csv")
# 2. Print dataset
data14





# Univariate meta-analysis of the DAS-28 outcome
m.das <- metagen(mean.das, se.das,
                 data=data14, sm="MD",
                 studlab=paste(author, year),
                 comb.random=FALSE)
# Univariate meta-analysis of the HAQ outcome
m.haq <- metagen(mean.haq, se.haq,
                 data=data14, sm="MD",
                 studlab=paste(author, year),
                 comb.random=FALSE)
#
# pdf(file="Schwarzer-Fig7.2a.pdf", width=7.5, height=3.5) # uncomment line to generate PDF file
forest(m.das, hetstat=FALSE)
# invisible(dev.off()) # uncomment line to save PDF file
#
# pdf(file="Schwarzer-Fig7.2b.pdf", width=7.5, height=3.5) # uncomment line to generate PDF file
forest(m.haq, hetstat=FALSE)
# invisible(dev.off()) # uncomment line to save PDF file





library(mvmeta)
args(mvmeta)





cor2cov <- function(sd1, sd2, cor) sd1*sd2*cor





theta <- cbind(data14$mean.das, data14$mean.haq)
dimnames(theta) <- list(data14$author, c("mean.das", "mean.haq"))
rho <- 0
S.arth <- cbind(data14$se.das^2,
                cor2cov(data14$se.das, data14$se.haq, rho),
                data14$se.haq^2)
dimnames(S.arth) <- list(data14$author,
                         c("var.das", "cov", "var.haq"))
S.arth





m.arth <- mvmeta(theta, S.arth, method="fixed")
print(summary(m.arth), digits=2)





# All studies have a correlation of 0.9 between outcomes
rho <- 0.9
S.arth2 <- cbind(data14$se.das^2,
                 cor2cov(data14$se.das, data14$se.haq, rho),
                 data14$se.haq^2)
dimnames(S.arth2) <- dimnames(S.arth)
# All studies have a correlation of -0.9 between outcomes
rho <- -0.9
S.arth3 <- cbind(data14$se.das^2,
                 cor2cov(data14$se.das, data14$se.haq, rho),
                 data14$se.haq^2)
dimnames(S.arth3) <- dimnames(S.arth)
# A mix of modest positive correlations between outcomes
rho <- c(0.5, 0.2, 0.1, 0.6, 0.4)
S.arth4 <- cbind(data14$se.das^2,
                 cor2cov(data14$se.das, data14$se.haq, rho),
                 data14$se.haq^2)
dimnames(S.arth4) <- dimnames(S.arth)
# Do meta-analyses
m.arth2 <- mvmeta(theta, S.arth2, method="fixed")
m.arth3 <- mvmeta(theta, S.arth3, method="fixed")
m.arth4 <- mvmeta(theta, S.arth4, method="fixed")





# Fixed effect means
round(coef(m.arth2), 3)
# Covariance matrix
vcov(m.arth2)
# Standard errors of fixed effect means
round(sqrt(diag(vcov(m.arth2))), 4)





rho <- 0.9
sample.sizes <- c(27,188,810,68,41)
# We use matrix multiplication (of a 5-by-1 and a 1-by-3 matrix)
# as a concise way of generating the argument S for mvmeta:
S.arth.common <- matrix(1/sample.sizes, ncol=1) %*% 
  matrix(c(2.146, rho*sqrt(2.146*0.352), 0.352), nrow=1)
dimnames(S.arth.common) <- list(data14$author,
                                c("var.das", "cov", "var.haq"))
round(S.arth.common, 4)
# Conduct and print bivariate meta-analysis
m.arth.common <- mvmeta(theta, S.arth.common, method="fixed")
print(summary(m.arth.common), digits=2)





#
# Web-appendix only (same results as rho=0.9 for a common response
# covariance matrix)
#
rho <- -0.9
sample.sizes <- c(27,188,810,68,41)
# We use matrix multiplication (of a 5-by-1 and a 1-by-3 matrix)
# as a concise way of generating the argument S for mvmeta:
S.arth2.common <- matrix(1/sample.sizes, ncol=1) %*% 
  matrix(c(2.146, rho*sqrt(2.146*0.352), 0.352), nrow=1)
dimnames(S.arth2.common) <- list(data14$author,
                                c("var.das", "cov", "var.haq"))
round(S.arth2.common, 4)
# Conduct and print bivariate meta-analysis
m.arth2.common <- mvmeta(theta, S.arth2.common, method="fixed")
print(summary(m.arth2.common), digits=2)





# pdf(file="Schwarzer-Fig7.3.pdf", width=12, height=6) # uncomment line to generate PDF file
oldpar <- par(mfrow=c(1,2), mar=c(4,4.1,1,1.8))
#
funnel(m.das,
       xlab="Mean difference in DAS-28 score from baseline")
sel <- m.das$studlab %in% c("Bennet 2005", "Bombardieri 2007",
                            "Navarro-Sarabia 2009")
text(m.das$TE[sel]-0.015, m.das$seTE[sel]-0.002,
     m.das$studlab[sel],
     adj=1, cex=0.8)
text(m.das$TE[!sel]+0.015, m.das$seTE[!sel]-0.002,
     m.das$studlab[!sel],
     adj=0, cex=0.8)
funnel(m.haq,
       xlab="Mean difference in HAQ score from baseline")
text(m.haq$TE-0.005, m.haq$seTE-0.002,
     m.haq$studlab,
     adj=1, cex=0.8)
# invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





# pdf("Schwarzer-Fig7.4.pdf") # uncomment line to generate PDF file
# Load R library ellipse which provides R function ellipse
library(ellipse)
# Plot the study means, setting the x-limits and y-limits
# so that the confidence regions will be visible
plot(data14$mean.das, data14$mean.haq,
     xlim=c(-2.5, -0.5), ylim=c(-0.7, 0), pch="+",
     xlab="Mean difference in DAS-28 score from baseline",
     ylab="Mean difference in HAQ score from baseline")
# Add confidence regions
rho <- 0.25
with(data14,
     for (i in seq(along=mean.das)){
       S <- matrix(c(se.das[i]^2,
                     se.das[i]*se.haq[i]*rho,
                     se.das[i]*se.haq[i]*rho,
                     se.haq[i]^2),
                   byrow=TRUE, ncol=2)
       lines(ellipse(S, centre=c(mean.das[i], mean.haq[i]),
                     level=0.95 ), col="grey")
     })
# Add study labels
studlab <- paste(data14$author, data14$year)
# Study label from Van der Bijl needs a line break
# in order not to overwrite another label
bijl <- data14$author=="Van der Bijl"
studlab[bijl] <- paste(data14$author[bijl], "\n", data14$year[bijl])
text(data14$mean.das+0.015, data14$mean.haq, studlab, adj=0)
# invisible(dev.off()) # uncomment line to save PDF file





theta.miss <- theta
selnava <- rownames(theta.miss)=="Navarro-Sarabia"
theta.miss[selnava, "mean.das"] <- NA
theta.miss





m.arth.miss <- mvmeta(theta.miss, S.arth, method="fixed")
print(summary(m.arth.miss), digits=2)





#
# Web-Appendix only (Table 7.3)
#
rho <- c(0.25, 0.25, 0.25, 0.25, 0.25)
S.arth.nomiss <- cbind(data14$se.das^2,
                       cor2cov(data14$se.das, data14$se.haq, rho),
                       data14$se.haq^2)
m.arth.nomiss <- mvmeta(theta, S.arth.nomiss, method="fixed")
#
m.das.miss <- metagen(ifelse(author=="Navarro-Sarabia",
                             NA, mean.das),
                      se.das,
                      data=data14, sm="MD",
                      studlab=paste(author, year),
                      comb.random=FALSE)
#
rho <- c(0.25, 0.25, 0.25, NA, 0.25)
S.arth2.miss <- cbind(data14$se.das^2,
                      cor2cov(data14$se.das, data14$se.haq, rho),
                      data14$se.haq^2)
m.arth2.miss <- mvmeta(theta.miss, S.arth2.miss, method="fixed")
#
rho <- c(0.90, 0.90, 0.90, NA, 0.90)
S.arth3.miss <- cbind(data14$se.das^2,
                      cor2cov(data14$se.das, data14$se.haq, rho),
                      data14$se.haq^2)
m.arth3.miss <- mvmeta(theta.miss, S.arth3.miss, method="fixed")
#
rho <- c(0.00, 0.00, 0.90, NA, 0.00)
S.arth4.miss <- cbind(data14$se.das^2,
                      cor2cov(data14$se.das, data14$se.haq, rho),
                      data14$se.haq^2)
m.arth4.miss <- mvmeta(theta.miss, S.arth4.miss, method="fixed")
#
rho <- c(0.90, 0.90, 0.00, NA, 0.90)
S.arth5.miss <- cbind(data14$se.das^2,
                      cor2cov(data14$se.das, data14$se.haq, rho),
                      data14$se.haq^2)
m.arth5.miss <- mvmeta(theta.miss, S.arth5.miss, method="fixed")
#
TE73 <- matrix(c(m.das$TE.fixed, m.haq$TE.fixed,
                 coef(m.arth.nomiss),
                 m.das.miss$TE.fixed, m.haq$TE.fixed,
                 coef(m.arth2.miss),
                 coef(m.arth3.miss),
                 coef(m.arth4.miss),
                 coef(m.arth5.miss)),
               byrow=TRUE, ncol=2)
#
seTE73 <- matrix(c(m.das$seTE.fixed, m.haq$seTE.fixed,
                   sqrt(diag(vcov(m.arth.nomiss))),
                   m.das.miss$seTE.fixed, m.haq$seTE.fixed,
                   sqrt(diag(vcov(m.arth2.miss))),
                   sqrt(diag(vcov(m.arth3.miss))),
                   sqrt(diag(vcov(m.arth4.miss))),
                   sqrt(diag(vcov(m.arth5.miss)))),
                 byrow=TRUE, ncol=2)

#
round(data.frame(TE.das=TE73[,1], seTE.das=seTE73[,1],
                 TE.haq=TE73[,2], seTE.haq=seTE73[,2]),
      3)





rho <- 0.25
S.arth.r <- cbind(data14$se.das^2,
                  cor2cov(data14$se.das, data14$se.haq, rho),
                  data14$se.haq^2)
m.arth.reml <- mvmeta(theta, S.arth.r, method="reml")
m.arth.ml   <- mvmeta(theta, S.arth.r, method="ml")
m.arth.mm   <- mvmeta(theta, S.arth.r, method="mm")





print(summary(m.arth.reml), digits=2)





#
# Web-appendix only (Table 7.4)
#
TE74 <- matrix(c(coef(m.arth.reml),
                 coef(m.arth.ml),
                 coef(m.arth.mm)),
               byrow=TRUE, ncol=2)
#
seTE74 <- matrix(c(sqrt(diag(vcov(m.arth.reml))),
                   sqrt(diag(vcov(m.arth.ml))),
                   sqrt(diag(vcov(m.arth.mm)))),
                 byrow=TRUE, ncol=2)

#
round(data.frame(TE.das=TE74[,1], seTE.das=seTE74[,1],
                 TE.haq=TE74[,2], seTE.haq=seTE74[,2]),
      3)





blup(m.arth.mm)
blup(m.arth.mm) - fitted(m.arth.mm)





#
# Web-Appendix only (Table 7.5)
#
rho <- 0
S.arth.mm <- cbind(data14$se.das^2,
                   cor2cov(data14$se.das, data14$se.haq, rho),
                   data14$se.haq^2)
m.arth.mm <- mvmeta(theta, S.arth.mm, method="mm")
#
rho <- 0.25
S.arth.mm2 <- cbind(data14$se.das^2,
                    cor2cov(data14$se.das, data14$se.haq, rho),
                    data14$se.haq^2)
m.arth.mm2 <- mvmeta(theta, S.arth.mm2, method="mm")
#
rho <- 0.9
S.arth.mm3 <- cbind(data14$se.das^2,
                    cor2cov(data14$se.das, data14$se.haq, rho),
                    data14$se.haq^2)
m.arth.mm3 <- mvmeta(theta, S.arth.mm3, method="mm")
#
rho <- -0.9
S.arth.mm4 <- cbind(data14$se.das^2,
                    cor2cov(data14$se.das, data14$se.haq, rho),
                    data14$se.haq^2)
m.arth.mm4 <- mvmeta(theta, S.arth.mm4, method="mm")
#
TE75 <- matrix(c(m.das$TE.random, m.haq$TE.random,
                 coef(m.arth.mm),
                 coef(m.arth.mm2),
                 coef(m.arth.mm3),
                 coef(m.arth.mm4)),
               byrow=TRUE, ncol=2)
#
seTE75 <- matrix(c(m.das$seTE.random, m.haq$seTE.random,
                   sqrt(diag(vcov(m.arth.mm))),
                   sqrt(diag(vcov(m.arth.mm2))),
                   sqrt(diag(vcov(m.arth.mm3))),
                   sqrt(diag(vcov(m.arth.mm4)))),
                 byrow=TRUE, ncol=2)

#
round(data.frame(TE.das=TE75[,1], seTE.das=seTE75[,1],
                 TE.haq=TE75[,2], seTE.haq=seTE75[,2]),
      3)
