#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 3
# "Meta-Analysis with Binary Outcomes"
#
#


library(meta)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





# 1. Read in the data
data7 <- read.csv("dataset07.csv")
# 2. Display data
data7
# 3. Calculate experimental and control event probabilities 
summary(data7$Ee/data7$Ne)
summary(data7$Ec/data7$Nc)





# 1. Calculate log odds ratio and its standard error for
#    Milpied trial
logOR <- with(data7[data7$study=="Milpied",],
              log((Ee*(Nc-Ec)) / (Ec*(Ne-Ee))))
selogOR <- with(data7[data7$study=="Milpied",],
                sqrt(1/Ee + 1/(Ne-Ee) + 1/Ec + 1/(Nc-Ec)))
# 2. Print odds ratio and limits of 95% confidence interval
round(exp(c(logOR,
            logOR + c(-1,1) *
            qnorm(1-0.05/2) * selogOR)), 4)





metabin(Ee, Ne, Ec, Nc, sm="OR", method="I",
        data=data7, subset=study=="Milpied")





# 1. Calculate log risk ratio and its standard error for
#    Milpied study
logRR <- with(data7[data7$study=="Milpied",],
              log((Ee/Ne) / (Ec/Nc)))
selogRR <- with(data7[data7$study=="Milpied",],
                sqrt(1/Ee + 1/Ec - 1/Ne - 1/Nc))
# 2. Print risk ratio and limits of 95% confidence interval
round(exp(c(logRR,
            logRR + c(-1,1) *
            qnorm(1-0.05/2) * selogRR)), 4)





metabin(Ee, Ne, Ec, Nc, sm="RR", method="I",
        data=data7, subset=study=="Milpied")





metabin(Ee, Ne, Ec, Nc, sm="RD", method="I",
        data=data7, subset=study=="Milpied")





# 1. Calculate arcsine difference and its standard error for
#    Milpied study
ASD <- with(data7[data7$study=="Milpied",],
            asin(sqrt(Ee/Ne)) - asin(sqrt(Ec/Nc)))
seASD <- with(data7[data7$study=="Milpied",],
              sqrt(1/(4*Ne) + 1/(4*Nc)))
# 2. Print arcsine difference and its 95% confidence interval
round(c(ASD,
        ASD + c(-1,1) *
        qnorm(1-0.05/2) * seASD), 4)





metabin(Ee, Ne, Ec, Nc, sm="ASD", method="I",
        data=data7, subset=study=="Milpied")





# 1. Read in the data
data8 <- read.csv("dataset08.csv")
# 2. Print dataset
data8
# 3. Calculate experimental and control event rates
summary(data8$Ee/data8$Ne)
summary(data8$Ec/data8$Nc)





# 1. Calculate log odds ratio and its standard error for
#    Australian study (with continuity correction)
logOR <- with(data8[data8$study=="Australian",],
              log(((Ee+0.5)*(Nc-Ec+0.5)) /
                  ((Ec+0.5)*(Ne-Ee+0.5))))
selogOR <- with(data8[data8$study=="Australian",],
                sqrt(1/(Ee+0.5) + 1/(Ne-Ee+0.5) +
                     1/(Ec+0.5) + 1/(Nc-Ec+0.5)))
# 2. Print odds ratio and limits of 95% confidence interval
round(exp(c(logOR,
            logOR + c(-1,1) * qnorm(1-0.05/2) * selogOR)), 4)





metabin(Ee, Ne, Ec, Nc, sm="OR", method="I",
        data=data8, subset=study=="Australian")





metabin(Ee, Ne, Ec, Nc, sm="OR", method="I",
        data=data8, subset=study=="Australian",
        incr=0.1)





metabin(Ee, Ne, Ec, Nc, sm="OR", method="I",
        data=data8, subset=study=="Australian",
        incr="TACC")





metabin(Ee, Ne, Ec, Nc, sm="RR", method="I",
        data=data8, subset=study=="Australian")





metabin(Ee, Ne, Ec, Nc, sm="OR", method="P",
        data=data7, subset=study=="Milpied")





metabin(Ee, Ne, Ec, Nc, sm="OR", method="P",
        data=data8, subset=study=="Australian")





# 1. Calculate log odds ratio, variance and weights
logOR <- with(data7,
              log((Ee*(Nc-Ec)) / (Ec*(Ne-Ee))))
varlogOR <- with(data7,
                 1/Ee + 1/(Ne-Ee) + 1/Ec + 1/(Nc-Ec))
weight <- 1/varlogOR
# 2. Calculate the inverse variance estimator
round(exp(weighted.mean(logOR, weight)), 4)
# 3. Calculate the variance
round(1/sum(weight), 4)





mb1 <- metabin(Ee, Ne, Ec, Nc, sm="OR", method="I",
               data=data7, studlab=study)
round(c(exp(mb1$TE.fixed), mb1$seTE.fixed^2), 4)





print(summary(mb1), digits=2)





# pdf(file="Schwarzer-Fig3.3.pdf", width=8.35, height=5) # uncomment line to generate PDF file
forest(mb1, comb.random=FALSE, hetstat=FALSE)
# invisible(dev.off()) # uncomment line to save PDF file





# 1. Calculate log odds ratio, variance and weights
logOR <- with(data8,
              log((Ee*(Nc-Ec)) / (Ec*(Ne-Ee))))
varlogOR <- with(data8,
                 1/Ee + 1/(Ne-Ee) + 1/Ec + 1/(Nc-Ec))
weight <- 1/varlogOR
# 2. Weight for Australian study
weight[data8$study=="Australian"]





mb2 <- metabin(Ee, Ne, Ec, Nc, sm="OR", method="I",
               data=data8, studlab=study)
print(summary(mb2), digits=2)





as.data.frame(mb2)[,c("studlab", "incr.e", "incr.c")]





mb1.mh <- metabin(Ee, Ne, Ec, Nc, sm="OR",
                  data=data7, studlab=study)
print(summary(mb1.mh), digits=2)





# pdf(file="Schwarzer-Fig3.4.pdf", width=8.35, height=5) # uncomment line to generate PDF file
forest(mb1.mh, comb.random=FALSE, hetstat=FALSE,
       text.fixed="MH estimate")
# invisible(dev.off()) # uncomment line to save PDF file





mb2.mh <- metabin(Ee, Ne, Ec, Nc, sm="OR", method="MH",
                  data=data8, studlab=study)
print(summary(mb2.mh), digits=2)





mb1.peto <- metabin(Ee, Ne, Ec, Nc, sm="OR", method="P",
                    data=data7, studlab=study)
print(summary(mb1.peto), digits=2)





mb2.peto <- metabin(Ee, Ne, Ec, Nc, sm="OR", method="Peto",
                    data=data8, studlab=study)
print(summary(mb2.peto), digits=2)





print(summary(mb1), digits=2)





#
# Web-appendix only (to generate Table 3.3 and 3.4)
#
restmp1 <- rbind(c(exp(mb1$TE.fixed), exp(mb1$lower.fixed), exp(mb1$upper.fixed),
                   exp(mb1$TE.random), exp(mb1$lower.random), exp(mb1$upper.random),
                   mb1$tau^2),
                 c(exp(mb1.mh$TE.fixed), exp(mb1.mh$lower.fixed), exp(mb1.mh$upper.fixed),
                   exp(mb1.mh$TE.random), exp(mb1.mh$lower.random), exp(mb1.mh$upper.random),
                   mb1.mh$tau^2),
                 c(exp(mb1.peto$TE.fixed), exp(mb1.peto$lower.fixed), exp(mb1.peto$upper.fixed),
                   exp(mb1.peto$TE.random), exp(mb1.peto$lower.random), exp(mb1.peto$upper.random),
                   mb1.peto$tau^2)
                 )
#
restmp1 <- as.data.frame(restmp1)
restmp1[,1:6] <- round(restmp1[,1:6], 2)
restmp1[,7] <- round(restmp1[,7], 4)
names(restmp1) <- c("OR (fixed)", "lower", "upper", "OR (random)", "lower", "upper", "tau^2")
row.names(restmp1) <- c("IV", "MH", "Peto")
#
#
restmp2 <- rbind(c(exp(mb2$TE.fixed), exp(mb2$lower.fixed), exp(mb2$upper.fixed),
                   exp(mb2$TE.random), exp(mb2$lower.random), exp(mb2$upper.random),
                   mb2$tau^2),
                 c(exp(mb2.mh$TE.fixed), exp(mb2.mh$lower.fixed), exp(mb2.mh$upper.fixed),
                   exp(mb2.mh$TE.random), exp(mb2.mh$lower.random), exp(mb2.mh$upper.random),
                   mb2.mh$tau^2),
                 c(exp(mb2.peto$TE.fixed), exp(mb2.peto$lower.fixed), exp(mb2.peto$upper.fixed),
                   exp(mb2.peto$TE.random), exp(mb2.peto$lower.random), exp(mb2.peto$upper.random),
                   mb2.peto$tau^2)
                 )
#
restmp2 <- as.data.frame(restmp2)
restmp2[,1:6] <- round(restmp2[,1:6], 2)
restmp2[,7] <- round(restmp2[,7], 4)
names(restmp2) <- c("OR (fixed)", "lower", "upper", "OR (random)", "lower", "upper", "tau^2")
row.names(restmp2) <- c("IV", "MH", "Peto")
#
#
restmp1
restmp2





# 1. Read in the data
data9 <- read.csv("dataset09.csv")
# 2. Print dataset
data9
# 3. Calculate experimental and control event rates
summary(data9$Ee/data9$Ne)
summary(data9$Ec/data9$Nc)





mb3 <- metabin(Ee, Ne, Ec, Nc, sm="RR", method="I",
               data=data9, studlab=study)
print(summary(mb3), digits=2)





mb3s <- update(mb3, byvar=blind, print.byvar=FALSE)
print(summary(mb3s), digits=2)
