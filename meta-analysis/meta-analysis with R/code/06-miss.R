#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 6
# "Missing Data in Meta-Analysis"
#
#


library(meta)





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





data1 <- read.csv("dataset01.csv", as.is=TRUE)





# 1. Do meta-analysis
m <- metacont(Ne, Me, Se, Nc, Mc, Sc,
              studlab=paste(author, year),
              data=data1)
# 2. Extract dataset
mdata <- as.data.frame(m)
mdata$studlab <- as.character(mdata$studlab)
# 3. Select seven studies with smallest standard error
data12 <- mdata[rank(mdata$seTE)<=7, c(7,1:6)]
names(data12) <- c("study", "Ne", "Me", "Se", "Nc", "Mc", "Sc")
# 4. Print dataset
data12





data12$Nem <- rep(0, length(data12$Ne))
data12$Nem[data12$study=="Novembre 1994f"] <- 8
data12$Nem[data12$study=="Oseid 1995"] <- 5
#
data12$Ncm <- data12$Nem
#
data12$Neo <- data12$Ne - data12$Nem
data12$Nco <- data12$Nc - data12$Ncm





mm1 <- metacont(Neo, Me, Se, Nco, Mc, Sc,
                data=data12, studlab=study)
data12$TE   <- mm1$TE
data12$seTE <- mm1$seTE
data12[, c("study", "TE", "seTE", "Neo", "Nco")]





#
# Part of web-appendix only
#
# pdf(file="Schwarzer-Fig6.2.pdf") # uncomment line to generate PDF file
funnel(mm1, studlab=TRUE, xlim=c(-28, -3))
# invisible(dev.off()) # uncomment line to save PDF file





semiss <- function(se, n.e, p.e, n.c, p.c,
                   mu.e, nu.e, mu.c, nu.c, rho){
  V1 <- function(p.e, p.c, nu.e, nu.c, rho)
    nu.e^2*p.e^2 + nu.c^2*p.c^2 - 2*rho*nu.e*nu.c*p.e*p.c
  V2 <- function(n.e, p.e, n.c, p.c, mu.e, nu.e, mu.c, nu.c)
  (mu.e^2+nu.e^2)*p.e*(1-p.e)/n.e +
    (mu.c^2+nu.c^2)*p.c*(1-p.c)/n.c
  #
  sqrt(se^2 +
       V1(p.e, p.c, nu.e, nu.c, rho) +
       V2(n.e, p.e, n.e, p.c,
          mu.e, nu.e, mu.c, nu.c))
}





# 1. Define parameters
mu.e <- mu.c <- 8
nu.e <- nu.c <- 0
rho <- 0
# 2. Calculate proportion missing in each study arm
data12$Pe <- with(data12, Pe <- (Ne - Neo) / Ne)
data12$Pc <- with(data12, Pc <- (Nc - Nco) / Nc)
# 3. Calculate the mean effect for each study under strategy 1
data12$TEs1 <- with(data12, TE + mu.e*Pe - mu.c*Pc)
data12$seTEs1 <- with(data12,
                        semiss(seTE, Neo, Pe, Nco, Pc,
                               mu.e, nu.e, mu.c, nu.c, rho))
# 4. Create indicator for studies with missings
selmiss <- data12$study %in% c("Novembre 1994f", "Oseid 1995")





data12[selmiss, c("study", "TE", "seTE", "TEs1", "seTEs1")]





mm1.s1 <- metagen(TEs1, seTEs1, data=data12,
                  studlab=study, comb.fixed=FALSE)
print(summary(mm1.s1), digits=2)





# 1. Define parameters
mu.e <- 8
mu.c <- -mu.e
nu.e <- nu.c <- 0
rho <- 0
# 2. Calculate the mean effect for each study under strategy 2
data12$TEs2 <- with(data12, TE + mu.e*Pe - mu.c*Pc)
data12$seTEs2 <- with(data12,
                        semiss(seTE, Neo, Pe, Nco, Pc,
                               mu.e, nu.e, mu.c, nu.c, rho))
# 3. Print calculate values
data12[selmiss, c("study", "TE", "seTE", "TEs2", "seTEs2")]
# 4. Do meta-analysis
mm1.s2 <- metagen(TEs2, seTEs2, data=data12,
                  studlab=study, comb.fixed=FALSE)
print(summary(mm1.s2), digits=2)





# 1. Define parameters
mu.e <- mu.c <- 8
nu.e <- nu.c <- sqrt(5)
rho <- 1
# 2. Calculate the mean effect for each study under strategy 2
data12$TEs3 <- with(data12, TE + mu.e*Pe - mu.c*Pc)
data12$seTEs3 <- with(data12,
                        semiss(seTE, Neo, Pe, Nco, Pc,
                               mu.e, nu.e, mu.c, nu.c, rho))
# 3. Print calculate values
data12[selmiss, c("study", "TE", "seTE", "TEs3", "seTEs3")]
# 4. Do meta-analysis
mm1.s3 <- metagen(TEs3, seTEs3, data=data12,
                  studlab=study, comb.fixed=FALSE)
print(summary(mm1.s3), digits=2)





# 1. Define parameters
mu.e <- 8
mu.c <- -mu.e
nu.e <- nu.c <- sqrt(5)
rho <- 0
# 2. Calculate the mean effect for each study under strategy 2
data12$TEs4 <- with(data12, TE + mu.e*Pe - mu.c*Pc)
data12$seTEs4 <- with(data12,
                        semiss(seTE, Neo, Pe, Nco, Pc,
                               mu.e, nu.e, mu.c, nu.c, rho))
# 3. Print calculate values
data12[selmiss, c("study", "TE", "seTE", "TEs4", "seTEs4")]
# 4. Do meta-analysis
mm1.s4 <- metagen(TEs4, seTEs4, data=data12,
                  studlab=study, comb.fixed=FALSE)
print(summary(mm1.s4), digits=2)





#
# Web-appendix
#
# pdf(file="Schwarzer-Fig6.3.pdf", width=12, height=9) # uncomment line to generate PDF file
# Divide the graphics window into four panels and
# set the margins around the plot (clockwise from bottom)
oldpar <- par(mfrow=c(2,2), mar=c(4.1,4.1,1.1,1.1))
#
funnel(mm1.s1,
       xlim=c(-28, -2),
       pch=ifelse(selmiss, 23, 21),
       cex=ifelse(selmiss, 2, 1),
       xlab=expression(paste("Difference in % reduction in ",
           FEV[1])),
       main="Strategy 1: Fixed Equal", cex.main=1)
# Add line showing random effect estimate from complete records
abline(v=mm1$TE.random, lty=1, col="darkgray")
#
funnel(mm1.s2,
       xlim=c(-28, -2),
       pch=ifelse(selmiss, 23, 21),
       cex=ifelse(selmiss, 2, 1),
       xlab=expression(paste("Difference in % reduction in ",
           FEV[1])),
       main="Strategy 2: Fixed Opposite", cex.main=1)
# Add line showing random effect estimate from complete records
abline(v=mm1$TE.random, lty=1, col="darkgray")
#
funnel(mm1.s3,
       xlim=c(-28, -2),
       pch=ifelse(selmiss, 23, 21),
       cex=ifelse(selmiss, 2, 1),
       xlab=expression(paste("Difference in % reduction in ",
           FEV[1])),
       main="Strategy 3: Random Equal", cex.main=1)
# Add line showing random effect estimate from complete records
abline(v=mm1$TE.random, lty=1, col="darkgray")
#
funnel(mm1.s4,
       xlim=c(-28, -2),
       pch=ifelse(selmiss, 23, 21),
       cex=ifelse(selmiss, 2, 1),
       xlab=expression(paste("Difference in % reduction in ",
           FEV[1])),
       main="Strategy 4: Random Uncorrelated", cex.main=1, cex.main=0.8)
# Add line showing random effect estimate from complete records
abline(v=mm1$TE.random, lty=1, col="darkgray")
# invisible(dev.off()) # uncomment line to save PDF file
par(oldpar)





# 1. Select seven studies with smallest standard error
data13 <- mdata[rank(mdata$seTE)<=7, c(7, 1:6)]
names(data13) <- c("study", "Ne", "Me", "Se", "Nc", "Mc", "Sc")
# 2. Set missing standard deviations for Shaw 1985 study
data13.noshaw <- data13
data13.noshaw$Se[data13.noshaw$study=="Shaw 1985"] <- NA
data13.noshaw$Sc[data13.noshaw$study=="Shaw 1985"] <- NA
# 3. Print dataset
data13.noshaw





# First study, i.e. Boner 1989, as reference group
f.tests <- with(data13.noshaw,
                c(pf(Se^2/Se[1]^2, Ne-1, Ne[1]-1),
                  pf(Sc^2/Sc[1]^2, Nc-1, Nc[1]-1)))
# Drop first study (reference group)
f.tests <- matrix(f.tests, ncol=2)[-1,]
# Define row and column names and print results
rownames(f.tests) <- data13.noshaw$study[-1]
colnames(f.tests) <- c("pval.e", "pval.c")
round(f.tests, 2)





# Define analysis dataset miss
miss <- data13.noshaw
# Set number of imputations
M <- 100
# Create data frame to hold results of each imputation
imp.shaw <- data.frame(seTE=rep(NA, M),
                       TE.fixed=NA, seTE.fixed=NA,
                       TE.random=NA, seTE.random=NA,
                       tau=NA)
# Set seed so results are reproducible
set.seed(10)
# Select studies for imputation
selimp <- !(miss$study %in% c("Shaw 1985", "Todaro 1993"))
selshaw <- miss$study=="Shaw 1985"
# Form pooled estimate of variability:
S2.e <- with(miss, sum((Ne[selimp]-1)*Se[selimp]^2))
S2.c <- with(miss, sum((Nc[selimp]-1)*Sc[selimp]^2))
# Calculate degrees of freedom:
df.e <- sum(miss$Ne[selimp]-1)
df.c <- sum(miss$Nc[selimp]-1)
#
miss$Se.shaw <- miss$Se
miss$Sc.shaw <- miss$Sc
#
for (m in 1:M) {
  # Draw sigma2.e, sigma2.c
  sigma2.e <- S2.e / rchisq(1, df=df.e)
  sigma2.c <- S2.c / rchisq(1, df=df.c)
  # Draw standard deviations for Shaw 1985
  sd.e.shaw <- sigma2.e *
    rchisq(1, df=miss$Ne[selshaw]-1)/(miss$Ne[selshaw]-1)
  sd.c.shaw <- sigma2.c *
    rchisq(1, df=miss$Nc[selshaw]-1)/(miss$Nc[selshaw]-1)
  # Store imputed standard error for illustrative funnel plot
  imp.shaw$seTE[m] <- sqrt(sd.e.shaw/miss$Ne[selshaw] +
                           sd.c.shaw/miss$Nc[selshaw])
  # Meta analyses of current imputed dataset
  miss$Se.shaw[selshaw] <- sqrt(sd.e.shaw)
  miss$Sc.shaw[selshaw] <- sqrt(sd.c.shaw)
  #
  m.shaw <- metacont(n.e=Ne, mean.e=Me, sd.e=Se.shaw,
                     n.c=Nc, mean.c=Mc, sd.c=Sc.shaw,
                     data=miss)
  # Store results
  imp.shaw$TE.fixed[m]    <- m.shaw$TE.fixed 
  imp.shaw$seTE.fixed[m]  <- m.shaw$seTE.fixed
  imp.shaw$TE.random[m]   <- m.shaw$TE.random
  imp.shaw$seTE.random[m] <- m.shaw$seTE.random
  imp.shaw$tau[m]         <- m.shaw$tau
}





# Calculate between and within variances
s2.b.fixed  <- var(imp.shaw$TE.fixed)
s2.b.random <- var(imp.shaw$TE.random)
s2.w.fixed  <- mean(imp.shaw$seTE.fixed^2)
s2.w.random <- mean(imp.shaw$seTE.random^2)
# Determine number of imputations
M <- length(imp.shaw$TE.fixed)
# Fixed effect estimate using multiple imputation
TE.fixed.imp   <- mean(imp.shaw$TE.fixed)
seTE.fixed.imp <- sqrt(var(imp.shaw$TE.fixed)*(1 + 1/M) +
                       mean(imp.shaw$seTE.fixed^2))
# Random effects estimate using multiple imputation
TE.random.imp   <- mean(imp.shaw$TE.random)
seTE.random.imp <- sqrt(var(imp.shaw$TE.random)*(1 + 1/M) +
                       mean(imp.shaw$seTE.random^2))
# Calculate degrees of freedom
df.fixed  <- (M-1)*(1 + s2.w.fixed /((1+1/M)*s2.b.fixed) )^2
df.random <- (M-1)*(1 + s2.w.random/((1+1/M)*s2.b.random))^2
# Print degrees of freedom
df.fixed
df.random





round(unlist(ci(TE.fixed.imp, seTE.fixed.imp))[1:5], 2)
round(unlist(ci(TE.random.imp, seTE.random.imp))[1:5], 2)





# pdf(file="Schwarzer-Fig6.4.pdf") # uncomment line to generate PDF file
# 1. Do meta-analysis of original data
mm2 <- metacont(Ne, Me, Se, Nc, Mc, Sc,
                studlab=study, data=data13)
TE.shaw   <- mm2$TE[mm2$studlab=="Shaw 1985"]
seTE.shaw <- mm2$seTE[mm2$studlab=="Shaw 1985"]
# 2. Generate funnel plot
funnel(mm2,
       xlim=c(-30, 0), ylim=c(max(imp.shaw$seTE), 0))
# 2a. Label Shaw 1985 study
text(TE.shaw-0.25, seTE.shaw-0.1, "Shaw 1985", cex=0.8, adj=1)
# 2b. Add small triangles representing imputed standard errors
set.seed(456) # Set seed so results are reproducible
points(jitter(rep(TE.shaw,
                  length(imp.shaw$seTE)), 0.5),
       imp.shaw$seTE, pch=2, cex=0.4)
# invisible(dev.off()) # uncomment line to save PDF file





#
# Web-appendix
#
# 1. Number of imputations resulting in tau-squared of zero
sum(imp.shaw$tau==0)
# 2. Do meta-analysis without Shaw 1985
mm2.noshaw <- metacont(Ne, Me, Se, Nc, Mc, Sc,
                       studlab=study,
                       data=data13,
                       subset=study!="Shaw 1985")
# 3. Print results for Table 6.2, rows 1 and 2
round(data.frame(TE.fixed=c(mm2$TE.fixed, mm2.noshaw$TE.fixed),
                 seTE.fixed=c(mm2$seTE.fixed, mm2.noshaw$seTE.fixed),
                 zval.fixed=c(mm2$zval.fixed, mm2.noshaw$zval.fixed),
                 TE.random=c(mm2$TE.random, mm2.noshaw$TE.random),
                 seTE.random=c(mm2$seTE.random, mm2.noshaw$seTE.random),
                 zval.random=c(mm2$zval.random, mm2.noshaw$zval.random)),
      2)
