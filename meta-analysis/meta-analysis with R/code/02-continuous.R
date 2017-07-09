#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 2
# "Fixed Effect and Random Effects Meta-Analysis"
#
#


library(meta)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





# 1. Read in the data
data1 <- read.csv("dataset01.csv", as.is=TRUE)
# 2. Calculate mean difference and its standard error for
#    study 1 (Boner 1988) of dataset data1:
MD <- with(data1[1,], Me - Mc)
seMD <- with(data1[1,], sqrt(Se^2/Ne + Sc^2/Nc))
# 3. Print mean difference and limits of 95% confidence
#    interval using round function to show only two digits:
round(c(MD, MD + c(-1,1) * qnorm(1-(0.05/2)) * seMD), 2)





with(data1[1, ],
     print(metacont(Ne, Me, Se, Nc, Mc, Sc),
           digits=2))





print(metacont(Ne, Me, Se, Nc, Mc, Sc,
               data=data1, subset=1), digits=2)





zscore <- MD/seMD
round(c(zscore, 2*pnorm(abs(zscore), lower.tail=FALSE)), 4)





# 1. Read in the data:
data2 <- read.csv("dataset02.csv")
# 2. As usual, to view an object, type its name:
data2
# 3. Calculate total sample sizes
summary(data2$Ne+data2$Nc)





# 1. Calculate standardised mean difference (SMD) and
#    its standard error (seSMD) for study 1 (Blashki) of
#    dataset data2:
N <- with(data2[1,], Ne + Nc)
SMD <- with(data2[1,],
            (1 - 3/(4 * N - 9)) * (Me - Mc) /
            sqrt(((Ne - 1) * Se^2 + (Nc - 1) * Sc^2)/(N - 2)))
seSMD <- with(data2[1,],
              sqrt(N/(Ne * Nc) + SMD^2/(2 * (N - 3.94))))
# 2. Print standardised mean difference and limits of 95% CI
#    interval using round function to show only two digits:
round(c(SMD, SMD + c(-1,1) * qnorm(1-(0.05/2)) * seSMD), 2)





print(metacont(Ne, Me, Se, Nc, Mc, Sc, sm="SMD",
               data=data2, subset=1), digits=2)





# 1. Calculate mean difference, variance and weights
MD <- with(data1, Me - Mc)
varMD <- with(data1, Se^2/Ne + Sc^2/Nc)
weight <- 1/varMD
# 2. Calculate the inverse variance estimator
round(weighted.mean(MD, weight), 4)
# 3. Calculate the variance
round(1/sum(weight), 4)





mc1 <- metacont(Ne, Me, Se, Nc, Mc, Sc,
                data=data1,
                studlab=paste(author, year))
round(c(mc1$TE.fixed, mc1$seTE.fixed^2), 4)





print(mc1, digits=1)





mc1$w.fixed[1]
sum(mc1$w.fixed)
round(100*mc1$w.fixed[1] / sum(mc1$w.fixed), 2)





# pdf(file="Schwarzer-Fig2.3.pdf", width=9.6) # uncomment line to generate PDF file
forest(mc1, comb.random=FALSE, xlab=
       "Difference in mean response (intervention - control)
units: maximum % fall in FEV1",
       xlim=c(-50,10), xlab.pos=-20, smlab.pos=-20)
# invisible(dev.off()) # uncomment line to save PDF file





# 1. Apply generic inverse variance method
mc1.gen <- metagen(mc1$TE, mc1$seTE, sm="MD")
# 2. Same result
mc1.gen <- metagen(TE, seTE, data=mc1, sm="MD")
# 3. Print results for fixed effect and random effects method
c(mc1$TE.fixed, mc1$TE.random)
c(mc1.gen$TE.fixed, mc1.gen$TE.random)





# 1. Calculate standardised mean difference,
#    variance and weights
N <- with(data2, Ne + Nc)
SMD <- with(data2,
            (1 - 3/(4 * N - 9)) * (Me - Mc)/
            sqrt(((Ne - 1) * Se^2 + (Nc - 1) * Sc^2)/(N - 2)))
varSMD <- with(data2,
               N/(Ne * Nc) + SMD^2/(2 * (N - 3.94)))
weight <- 1/varSMD
# 2. Calculate the inverse variance estimator
round(weighted.mean(SMD, weight), 4)
# 3. Calculate the variance
round(1/sum(weight), 4)





mc2 <- metacont(Ne, Me, Se, Nc, Mc, Sc, sm="SMD",
                data=data2)
round(c(mc2$TE.fixed, mc2$seTE.fixed^2), 4)





print(summary(mc2), digits=2)





#
# Web-appendix only
#
# 1. Conduct meta-analyses
# 1a. DerSimonian-Laird estimator (default)
mg1.DL <- metagen(TE, seTE, data=mc1)
# 1b. Paule-Mandel estimator
mg1.PM <- metagen(TE, seTE, data=mc1, method.tau="PM")
# 1c. Restricted maximum-likelihood estimator
mg1.RM <- metagen(TE, seTE, data=mc1, method.tau="REML")
# 1d. Maximum-likelihood estimator
mg1.ML <- metagen(TE, seTE, data=mc1, method.tau="ML")
# 1e. Hunter-Schmidt estimator
mg1.HS <- metagen(TE, seTE, data=mc1, method.tau="HS")
# 1f. Sidik-Jonkman estimator
mg1.SJ <- metagen(TE, seTE, data=mc1, method.tau="SJ")
# 1g. Hedges estimator
mg1.HE <- metagen(TE, seTE, data=mc1, method.tau="HE")
# 1h. Empirical Bayes estimator
mg1.EB <- metagen(TE, seTE, data=mc1, method.tau="EB")
# 2. Extract between-study variance tau-squared
tau2 <- data.frame(tau2=round(c(0,
                     mg1.DL$tau^2, mg1.PM$tau^2,
                     mg1.RM$tau^2, mg1.ML$tau^2,
                     mg1.HS$tau^2, mg1.SJ$tau^2,
                     mg1.HE$tau^2, mg1.EB$tau^2), 2),
                   row.names=c("FE", "DL", "PM", "REML", "ML",
                     "HS", "SJ", "HE", "EB"))
# 3. Print tau-squared values
t(tau2)
# 4. Create dataset with summaries
res <- data.frame(MD=c(mg1.DL$TE.fixed,
                    mg1.DL$TE.random, mg1.PM$TE.random,
                    mg1.RM$TE.random, mg1.ML$TE.random,
                    mg1.HS$TE.random, mg1.SJ$TE.random,
                    mg1.HE$TE.random, mg1.EB$TE.random),
                  seMD=c(mg1.DL$seTE.fixed,
                    mg1.DL$seTE.random, mg1.PM$seTE.random,
                    mg1.RM$seTE.random, mg1.ML$seTE.random,
                    mg1.HS$seTE.random, mg1.SJ$seTE.random,
                    mg1.HE$seTE.random, mg1.EB$seTE.random),
                  method=c("",
                    "DerSimonian-Laird",
                    "Paule-Mandel",
                    "Restricted maximum-likelihood",
                    "Maximum-likelihood",
                    "Hunter-Schmidt",
                    "Sidik-Jonkman",
                    "Hedges",
                    "Empirical Bayes"),
                  tau2=tau2,
                  model=c("Fixed-effect model",
                    rep("Random-effect model", 8)))
# 5. Do meta-analysis
m <- metagen(MD, seMD, data=res,
             studlab=method,
             sm="MD",
             comb.fixed=FALSE, comb.random=FALSE,
             byvar=model)
# 6. Do forest plot
# pdf(file="Schwarzer-Fig2.5.pdf", width=8.1, height=4.0) # uncomment line to generate PDF file
forest(m,
       xlim=c(-20, -12),
       hetstat=FALSE, smlab="",
       leftcols=c("studlab", "tau2"),
       leftlabs=c("Method", "Between-study\nheterogeneity"),
       print.byvar=FALSE)
# invisible(dev.off()) # uncomment line to save PDF file





mc2.hk <- metacont(Ne, Me, Se, Nc, Mc, Sc, sm="SMD",
                   data=data2, comb.fixed=FALSE,
                   hakn=TRUE)





mc2.hk <- metagen(TE, seTE, data=mc2, comb.fixed=FALSE,
                  hakn=TRUE)





print(summary(mc2.hk), digits=2)





print(summary(mc1, prediction=TRUE), digits=2)





# pdf(file="Schwarzer-Fig2.6.pdf", width=11.0) # uncomment line to generate PDF file
forest(mc1, prediction=TRUE, col.predict="black")
# invisible(dev.off()) # uncomment line to save PDF file





# 1. Read in the data:
data3 <- read.csv("dataset03.csv")
# 2. As usual, to view an object, type its name:
data3





mc3 <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                studlab=paste(author, year))





mc3$studlab[mc3$w.fixed==0]





print(summary(mc3), digits=2)





mc3s <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
                 studlab=paste(author, year),
                 byvar=duration, print.byvar=FALSE)





mc3s <- update(mc3, byvar=duration, print.byvar=FALSE)





#mc3nodata <- metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
#                     studlab=paste(author, year),
#                     keepdata=FALSE)
#update(mc3nodata)





print(summary(mc3s), digits=2)





# pdf(file="Schwarzer-Fig2.8.pdf", width=10.35, height=9.25) # uncomment line to generate PDF file
forest(mc3s, xlim=c(-0.5, 0.2),
       xlab="Difference in mean number of acute exacerbations per month")
# invisible(dev.off()) # uncomment line to save PDF file





print(metacont(Ne, Me, Se, Nc, Mc, Sc, data=data3,
               subset=duration=="<= 3 months",
               studlab=paste(author, year)),
      digits=2)





print(update(mc3, subset=duration=="<= 3 months"),
      digits=2)





# 1. Read in the data
data4 <- read.csv("dataset04.csv")
# 2. Print data
data4





mg1 <- metagen(logHR, selogHR,
               studlab=paste(author, year), data=data4,
               sm="HR")





print(mg1, digits=2)





# 1. Read in the data
data5 <- read.csv("dataset05.csv")
# 2. Print data
data5





mg2 <- metagen(mean, SE, studlab=paste(author, year),
               data=data5, sm="MD")





print(summary(mg2), digits=2)





# 1. Read in the data
data6 <- read.csv("dataset06.csv")
# 2. Print data
data6





mg3 <- metagen(b, SE, studlab=paste(author, year),
               data=data6, sm="RR", backtransf=FALSE)





summary(mg3)
