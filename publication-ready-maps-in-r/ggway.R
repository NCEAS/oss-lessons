# Adapted from 
# https://gis.stackexchange.com/questions/222799/create-an-inset-map-in-r

library(raster) # Just for downloading
library(ggplot2)
library(ggthemes)
library(ggsn) # For arrow and scales

mapdata <- getData("GADM", country = "usa", level = 1)
mymap <- fortify(mapdata)

mypoint <- data.frame(long = -121.6945, lat = 39.36708)

g1 <- ggplot() +
  geom_blank(data = mymap, aes(x=long, y=lat)) +
  geom_map(data = mymap, map = mymap, 
           aes(group = group, map_id = id),
           fill = "#b2b2b2", color = "black", size = 0.3) +
  geom_point(data = mypoint, aes(x = long, y = lat),
             color = "black", size = 2) +
  scale_x_continuous(limits = c(-125, -114), expand = c(0, 0)) +
  scale_y_continuous(limits = c(32.2, 42.5), expand = c(0, 0)) +
  theme_map() +
  scalebar(location = "bottomleft", dist = 200,
           dd2km = TRUE, model = 'WGS84',           
           x.min = -124.5, x.max = -114,
           y.min = 33.2, y.max = 42.5) +
  north(x.min = -115.5, x.max = -114,
        y.min = 40.5, y.max = 41.5,
        location = "toprgiht", scale = 0.1)


foo <- map_data("state")

g2 <- ggplotGrob(
  ggplot() +
    geom_polygon(data = foo,
                 aes(x = long, y = lat, group = group),
                 fill = "#b2b2b2", color = "black", size = 0.3) +
    geom_point(data = mypoint, aes(x = long, y = lat),
               color = "black", size = 2) +
    coord_map("polyconic") +
    theme_map() +
    theme(panel.background = element_rect(fill = NULL))
)     

g3 <- g1 +
  annotation_custom(grob = g2, xmin = -119, xmax = -114,
                    ymin = 31.5, ymax = 36)

# Alternative way:
# http://r-nold.blogspot.com/2014/06/creating-inset-map-with-ggplot2.html