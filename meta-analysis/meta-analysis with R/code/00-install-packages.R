#
#
# Use-R! - Meta-Analysis with R by Schwarzer, Carpenter, Rücker
#
# R code to install R packages used in the book
#
#


# List of R packages
pkgs <- c("mada", "meta", "metafor", "metasens", "mvmeta", "netmeta",
          "rmeta", "ellipse")

# Use your favorite CRAN mirror (argument 'repos')
# See website http://cran.r-project.org/mirrors.html for a list of
# CRAN mirrors
install.packages(pkgs,
                 repos="http://cran.at.r-project.org/")
