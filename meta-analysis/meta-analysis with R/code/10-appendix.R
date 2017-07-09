#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Appendix A
#
#


# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





rd1 <- read.csv("dataset01.csv", as.is=TRUE)
rd2 <- read.csv2("dataset01.csv", as.is=TRUE,
                 sep=",", dec=".")
rd3 <- read.delim("dataset01.csv", as.is=TRUE,
                  sep=",", dec=".")
rd4 <- read.delim2("dataset01.csv", as.is=TRUE,
                   sep=",", dec=".")
rd5 <- read.table("dataset01.csv", as.is=TRUE,
                  sep=",", dec=".", header=TRUE)





all.equal(rd1, rd2)
all.equal(rd1, rd3)
all.equal(rd1, rd4)
all.equal(rd1, rd5)





library(meta)
examples <- read.rm5("Examples from Meta-Analysis with R.csv",
                     numbers.in.labels=FALSE)
dim(examples)
class(examples)





examples[, 1:6]





args(metacr)





mc1.cr <- metacr(examples)
mb1.cr <- metacr(examples, 2, 1)





# 1. Read in the data
data1 <- read.csv("dataset01.csv", as.is=TRUE)
# 2. Conduct meta-analysis
mc1.md <- metacont(Ne, Me, Se, Nc, Mc, Sc,
                   data=data1, studlab=paste(author, year),
                   comb.random=FALSE)
# 3. Read in the data
data7 <- read.csv("dataset07.csv")
# 4. Conduct meta-analysis
mb1.rr <- metabin(Ee, Ne, Ec, Nc, data=data7, studlab=study,
                  comb.random=FALSE)





class(mc1.cr)
class(mc1.md)





print(summary(mc1.cr), digits=2)
print(summary(mc1.md), digits=2)





# print(summary(mb1.cr), digits=2)
# print(summary(mb1.rr), digits=2)





#metacont(Ne, Me, Se, Nc, Mc, Sc,
#         data=data1, studlab=paste(author, year),
#         comb.random=FALSE,
#         title="Examples from Meta-Analysis with R",
#         complab="Chapter 2 - Meta-Analysis with Continuous Outcomes",
#         outclab="Example 2.1 - Nedocromil sodium for bronchoconstriction")





metabias(examples)





detach(package:meta)





# Make R package meta available
library(meta)
mb1.meta <- metabin(Ee, Ne, Ec, Nc, data=data7, studlab=study,
                    comb.random=FALSE)





# Make R package metafor available
library(metafor)
# Do meta-analysis using default settings (numbers of events
mb1.metafor <- rma.mh(Ee, Ne-Ee, Ec, Nc-Ec,
                      data=data7, measure="RR")
# Do meta-analysis using same input as R function metabin
mb1.metafor <- rma.mh(ai=Ee, n1i=Ne, ci=Ec, n2i=Nc,
                      data=data7, measure="RR")





# Make R package rmeta available
library(rmeta)
mb1.rmeta <- meta.MH(Ne, Nc, Ee, Ec, data=data7,
                     statistic="RR")





print(summary(mb1.meta), digits=2)





print(mb1.metafor, digits=2)





print(mb1.rmeta)
