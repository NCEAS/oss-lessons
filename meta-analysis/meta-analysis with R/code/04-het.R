#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 4
# "Heterogeneity and Meta-Regression"
#
#


library(meta)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





data1 <- read.csv("dataset01.csv")
mc1 <- metacont(Ne, Me, Se, Nc, Mc, Sc,
                data=data1,
                studlab=paste(author, year))
data3 <- read.csv("dataset03.csv")
mc3 <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                studlab=paste(author, year))
mc3s <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                 studlab=paste(author, year),
                 byvar=duration, print.byvar=FALSE)
data9 <- read.csv("dataset09.csv")





round(mc1$Q, 2) # Cochran's Q statistic
round(100*c(mc1$I2, mc1$lower.I2, mc1$upper.I2), 1) # I-squared
round(mc1$tau^2, 4) # Between-study variance tau-squared





# Conduct meta-analysis for first subgroup:
mc3s1 <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                  studlab=paste(author, year),
                  subset=duration=="<= 3 months")
# Conduct meta-analysis for second subgroup:
mc3s2 <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                  studlab=paste(author, year),
                  subset=duration=="> 3 months")





# Subgroup treatment effects (fixed effect model)
TE.duration <- c(mc3s1$TE.fixed, mc3s2$TE.fixed)
# Corresponding standard errors (fixed effect model)
seTE.duration <- c(mc3s1$seTE.fixed, mc3s2$seTE.fixed)





mh1 <- metagen(TE.duration, seTE.duration,
               sm="MD",
               studlab=c("<= 3 months", " > 3 months"),
               comb.random=FALSE)
print(mh1, digits=2)





print(summary(mc3s), digits=2)





mh1$Q
mc3s$Q.b.fixed





data.frame(duration=c("<= 3 months", " > 3 months"),
           tau2=round(c(mc3s1$tau^2, mc3s2$tau^2), 4))





round((mc3s1$Q - (mc3s1$k-1))/mc3s1$C, 4)





# Subgroup treatment effects (random effects model)
TE.duration.r <- c(mc3s1$TE.random, mc3s2$TE.random)
# Corresponding standard errors (random effects model)
seTE.duration.r <- c(mc3s1$seTE.random, mc3s2$seTE.random)
# Do meta-analysis of subgroup estimates
mh1.r <- metagen(TE.duration.r, seTE.duration.r,
                 sm="MD",
                 studlab=c("<= 3 months", " > 3 months"),
                 comb.random=FALSE)
print(mh1.r, digits=2)





# Q-statistic within subgroups
Q.g <- c(mc3s1$Q, mc3s2$Q)
# Degrees of freedom within subgroups
df.Q.g <- c(mc3s1$k-1, mc3s2$k-1)
# Scaling factor within subgroups
C.g <- c(mc3s1$C, mc3s2$C)





# Calculate common estimate of tau-squared
tau2.common <- (sum(Q.g) - sum(df.Q.g)) / sum(C.g)
# Set negative value of tau.common to zero
tau2.common <- ifelse(tau2.common < 0, 0, tau2.common)
# Print common between-study variance
round(tau2.common, 4)





mc3s.p <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                   studlab=paste(author, year),
                   byvar=duration, print.byvar=FALSE,
                   tau.preset=sqrt(tau2.common))
print(summary(mc3s.p), digits=2)




mc3s.c <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                   studlab=paste(author, year),
                   byvar=duration, print.byvar=FALSE,
                   tau.common=TRUE, comb.fixed=FALSE)
print(summary(mc3s.c), digits=2)

# update(mc3tp, method.tau="REML")





mc3s.mr <- metareg(mc3s.c, duration)





print(mc3s.mr, digits=2)





# Variance-covariance matrix
varcov <- vcov(mc3s.mr)
# Estimated treatment effect in studies with longer duration
TE.s2 <- sum(coef(mc3s.mr))
# Standard error of treatment effect
seTE.s2 <- sqrt(sum(diag(varcov)) + 2*varcov[1,2])





print(metagen(TE.s2, seTE.s2, sm="MD"), digits=2)





mb3s.c <- metabin(Ee, Ne, Ec, Nc, sm="RR", method="I",
                  data=data9, studlab=study,
                  byvar=blind, print.byvar=FALSE,
                  tau.common=TRUE)
print(summary(mb3s.c), digits=2)





mb3s.mr <- metareg(mb3s.c)
print(mb3s.mr, digits=2)





# Treatment effect in studies with adequate blinding
round(exp(coef(mb3s.mr)["intrcpt"]), 2)
# Treatment effect in studies with unclear method of blinding
round(exp(sum(coef(mb3s.mr))), 2)





data(dat.colditz1994, package="metafor")
data10 <- dat.colditz1994





mh2 <- metabin(tpos, tpos+tneg, cpos, cpos+cneg,
               data=data10, studlab=paste(author, year))





summary(mh2)





table(data10$ablat)





mh2.mr <- metareg(mh2, ablat)
print(mh2.mr, digits=2)





# pdf(file="Schwarzer-Fig4.1.pdf") # uncomment line to generate PDF file
bubble(mh2.mr)
# invisible(dev.off()) # uncomment line to save PDF file




mean(data10$ablat)
ablat.c <- with(data10, ablat - mean(ablat))
mh2.mr.c <- metareg(mh2, ablat.c)
print(mh2.mr.c, digits=2)





round(exp(coef(mh2.mr.c)["intrcpt"]), 2)





TE.33.5 <- coef(mh2.mr.c)["intrcpt"]
seTE.33.5 <- sqrt(vcov(mh2.mr.c)["intrcpt", "intrcpt"])
print(metagen(TE.33.5, seTE.33.5, sm="RR"), digits=2)
