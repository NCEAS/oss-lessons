######################################################################################
# OSS 2017: Web Scraping challenge                                                   #
# Julien Brun, brun@nceas.ucsb.edu, NCEAS 2017                                       #
#                                                                                    #
# Challenge:                                                                         #
# Download all the fisheries shapefile for the Gulf of Mexico from the NOAA website: #
# http://sero.nmfs.noaa.gov/maps_gis_data/fisheries/gom/GOM_index.html               #
#                                                                                    #
######################################################################################


## LIBRARY ----
# install.packages("rvest")
library("rvest")


## CONSTANT ----

URL <- "http://sero.nmfs.noaa.gov/maps_gis_data/fisheries/gom/GOM_index.html"
dir_out <- "~/oss/data/GOM_fisheries_shapefiles"

## MAIN ----

# Get the webpage content
webpage <- read_html(URL)

# Extract the information of interest from the website
data <- html_nodes(webpage, ".dataBox p a")

# Grab the base URLs to download all the referenced data
url_base <- html_attr(data,"href")

# Filter the zip files
shapefile_base <- grep("*.zip",url_base, value=TRUE)

# Fix the double `//`
shapefile_fixed <- gsub("//", "/", shapefile_base)

# Add the URL prefix
shapefile_full <- paste0("http://sero.nmfs.noaa.gov/",shapefile_fixed)

# Create the output directory
dir.create(dir_out, showWarnings = FALSE)

# Create a list of filenames
filenames_full <- file.path(dir_out,basename(shapefile_full))

# Download the files
lapply(shapefile_full, FUN=function(x) download.file(x, file.path(dir_out,basename(x))))

# Unzip the files
unzip(filenames_full, overwrite = TRUE)



