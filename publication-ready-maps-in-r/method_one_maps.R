# Modified slightly from
# https://gis.stackexchange.com/questions/222799/create-an-inset-map-in-r

library(maps)
library(maptools)
library(GISTools)  

pdf("map.pdf", width = 8, height = 8)

# Base map
map("state", fill = FALSE, xlim = c(-88, -80), ylim = c(24, 31))
title(xlab = expression(~Longitude ~degree ~N), 
      ylab = expression(~Latitude ~degree ~W))
map.axes()

# Dot on Tampa, FL
points(-82.4571776, 27.950575, bg = "black", pch = 21)

# Scale bar
maps::map.scale(x=-87.6, y=24.5, ratio=FALSE, relwidth=0.3)

# Compass rose
north.arrow(xb=-80.5, yb=30.5, len=0.10, lab="N") 

# Inset map
par(usr=c(-216, -63, 22, 144))
rect(xleft =-126.2, ybottom = 23.8, xright = -65.5,ytop = 50.6,col = "white")
map("usa", xlim=c(-126.2,-65.5), ylim=c(23.8,50.6),add=T)
map("state", xlim=c(-126.2,-65.5), ylim=c(23.8,50.6),add=T, boundary = F, interior = T, lty=2)
map("state", region="florida", fill=T, add=T)
points(-82.4571776, 27.950575, bg = "white", pch = 21)

dev.off()
