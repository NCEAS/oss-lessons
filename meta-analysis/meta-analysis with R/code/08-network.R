#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code for Chapter 8
# "Network Meta-Analysis"
#
#


#
# Web-appendix only (Figure 8.1)
#
library(netmeta)
# pdf("Schwarzer-Fig8.1.pdf") # uncomment line to generate PDF file
netgraph(netmeta(rep(1, 5), rep(1, 5),
                 c("A", "A", "B", "B", "C"),
                 c("B", "D", "C", "D", "D"),
                 1:5),
         start="prcomp", iterate=TRUE, 
         lwd=4, col=1, cex=2,
         points=TRUE, col.points=1, cex.points=3)
# dev.off()
detach(package:netmeta)
detach(package:meta)





# 1. Make R package netmeta available
library(netmeta)
# 2. Load dataset
data(Senn2013)
data15 <- Senn2013
# 3. Print dataset
data15





# help(Senn2013)





willms <- data.frame(treatment=c("metf", "acar", "plac"),
                     n=c(29, 31, 29),
                     mean=c(-2.5, -2.3, -1.3),
                     sd=c(0.862, 1.782, 1.831),
                     stringsAsFactors=FALSE)
willms





comp12 <- metacont(n[1], mean[1], sd[1], n[2], mean[2], sd[2],
                   data=willms, sm="MD")
comp13 <- metacont(n[1], mean[1], sd[1], n[3], mean[3], sd[3],
                   data=willms, sm="MD")
comp23 <- metacont(n[2], mean[2], sd[2], n[3], mean[3], sd[3],
                   data=willms, sm="MD")





TE <- c(comp12$TE, comp13$TE, comp23$TE)
seTE <- c(comp12$seTE, comp13$seTE, comp23$seTE)





treat1 <- c(willms$treatment[1], willms$treatment[1],
            willms$treatment[2])
treat2 <- c(willms$treatment[2], willms$treatment[3],
            willms$treatment[3])

# Print calculated treatment comparisons for Willms 1999
data.frame(TE, seTE=round(seTE, 4), treat1, treat2)





args(netmeta)





mn0 <- netmeta(TE, seTE, treat1, treat2, data=data15)





mn0





mn1 <- netmeta(TE, seTE, treat1, treat2, studlab,
               data=data15, sm="MD")





# pdf(file="Schwarzer-Fig8.3.pdf") # uncomment line to generate PDF file
netgraph(mn1, seq=c("plac", "benf", "migl", "acar", "sulf",
                    "metf", "rosi", "piog", "sita", "vild"))
# invisible(dev.off()) # uncomment line to save PDF file





print(mn1, digits=2)





mn1$n
mn1$m
mean(mn1$leverage.fixed)
(mn1$n-1)/mn1$m





print(summary(mn1))





netgraph(mn1, start="random", iterate=TRUE,
         col="darkgray", cex=1.5, multiarm=FALSE,
         points=TRUE, col.points="green", cex.points=3)





# pdf(file="Schwarzer-Fig8.4.pdf") # uncomment line to generate PDF file
netgraph(mn1, start="circle", iterate=TRUE,
         col="darkgray", cex=1.5, 
         points=TRUE, col.points="black", cex.points=3, 
         col.multiarm="gray")
# invisible(dev.off()) # uncomment line to save PDF file





# netgraph(mn1, start="circle", iterate=TRUE,
#          col="darkgray", cex=1.5, 
#          points=TRUE, col.points="black", cex.points=3, 
#          col.multiarm="gray", allfigures=TRUE)





summary(mn1, ref="plac")





forest(mn1, ref="plac")





# Command results in an error
# forest(mn1)





args(forest.netmeta)





# pdf(file="Schwarzer-Fig8.5.pdf", width=5.8, height=4) # uncomment line to generate PDF file
forest(mn1, xlim=c(-1.5, 1), ref="plac",
       leftlabs="Contrast to Placebo",
       xlab="HbA1c difference")
# invisible(dev.off()) # uncomment line to save PDF file
# pdf(file="Schwarzer-Fig8.6.pdf", width=5.8, height=4) # uncomment line to generate PDF file
forest(mn1, xlim=c(-1.5, 1), ref="plac",
       leftlabs="Contrast to placebo",
       xlab="HbA1c difference",
       pooled="random")
# invisible(dev.off()) # uncomment line to save PDF file





round(decomp.design(mn1)$Q.decomp, 3)





print(decomp.design(mn1)$Q.het.design, digits=2)





round(decomp.design(mn1)$Q.inc.random, 3) 





# pdf(file="Schwarzer-Fig8.7.pdf") # uncomment line to generate PDF file
netheat(mn1)
# invisible(dev.off()) # uncomment line to save PDF file





round(decomp.design(mn1)$Q.inc.design, 2)





# pdf(file="Schwarzer-Fig8.8.pdf") # uncomment line to generate PDF file
netheat(mn1, random=TRUE)
# invisible(dev.off()) # uncomment line to save PDF file





# pdf(file="Schwarzer-Fig8.9.pdf") # uncomment line to generate PDF file
# Set seed so results are reproducible
set.seed(125)
fe <- mn1$TE.nma.fixed 
re <- mn1$TE.nma.random
plot(jitter((fe+re)/2, 5), jitter(fe-re, 5),
     xlim=c(-1.2, 1.2),
     ylim=c(-0.25, 0.25),
     xlab="Mean treatment effect (in fixed effect and random effects model)",
     ylab="Difference of treatment effect (fixed effect minus random effects model)")
abline(h=0)
# invisible(dev.off()) # uncomment line to save PDF file





summary(mn1$seTE.nma.random / mn1$seTE.nma.fixed)
