#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 1
# "An Introduction to Meta-Analysis with R"
#
#


# demo
# demo()
# demo(graphics)
# q()





# set x to be 2
x <- 2
# same assignment
x = 2
# display x
x
# set x to be the vector 1,2,3 using R function c
x <- c(1,2,3)
# same assignment
x <- 1:3
# display x
x
# add up the elements of x:
sum(x)
# set x to be a matrix
x <- matrix(c(1,2,3,4), nrow=2)
# display x
x
# square the matrix x
x*x
# square x and add 3 to all entries
x*x + 3
# create a function, called f, which squares its argument
f <- function(x){x*x}
f(2)
f(c(1,2,3))
# square the matrix x using R function f
f(x)





# ?ls
# help(ls)
# help.start()





# getwd()





# ls()
# rm(g)
# ls()
# rm(list = ls())
# ls()





# save.image()





# Change working directory - replace 'my_directory' with the path to
# an existing directory containing the data files from the R book
# setwd("my_directory")





# list.files(pattern="dataset01")





# 1. Read in the data
data1 <- read.csv("dataset01.csv", as.is=TRUE)
# 2. Print structure of R object data1
str(data1)
# 3. To view an R object, just type its name:
data1





# save(data1, file="data1.rda")
# load("data1.rda")





# The following command would result in an error message
# "Error: object 'author' not found".
# author





data1$author





data1[, "author"]





data1[1:4, "author"] 





data1$author[1:4]





# List the first four authors in data frame data1
with(data1, author[1:4])
with(data1[1:4,], author)





# 1. Make variables of data frame data1 directly available:
attach(data1)
# 2. List the first four authors in data frame data1
author[1:4]
# 3. Detach data frame data1
detach(data1)





# 1. Create a new R object author (numeric variable)
author <- 123
# 2. Attaching data frame data1 results in a warning
attach(data1)
# 3. The following command prints the numeric variable author
author[1:4]
# 4. Search for R objects called "author"
find("author")
# 5. Detach data frame data1
detach(data1)
# 6. Remove R object author from global environment
rm(author)





data1[1:4, c("author", "year", "Ne", "Nc")]





# 1. Calculate and display the total sample sizes:
data1$Ne + data1$Nc
with(data1, Ne + Nc)
# 2. Calculate and display the total sample size
#    for the Chudry study
data1$Ne[data1$author=="Chudry"] +
  data1$Nc[data1$author=="Chudry"]
with(data1[data1$author=="Chudry",], Ne + Nc)





# First script example1.R:
# getwd()
# dir(pattern="example1")
# data1 <- read.csv("dataset01.csv")
# summary(data1)
# print(summary(data1))





# source("example1.R")





# help(package=meta)





# 1. Load add-on package meta
library(meta)
# 2. Do meta-analysis
m <- metacont(Ne, Me, Se, Nc, Mc, Sc,
              studlab=paste(author, year),
              data=data1)
# 3. Produce forest
# pdf(file="Schwarzer-Fig1.4.pdf", width=11) # uncomment line to generate PDF file
forest(m, xlab="Maximum % fall in FEV1")
# invisible(dev.off()) # uncomment line to save PDF file





args(metacont)





# Class of meta-analysis object m
class(m)
# Assign a numeric vector to object m
m <- 1:10
# Class of numeric vector m
class(m)
# Summary of vector with integers
summary(m)
