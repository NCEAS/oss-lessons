#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Always load shiny
library(shiny)

# Package for our analysis
library(dplyr)
library(tidyr)
library(gstat)
library(rgdal)
library(raster)

# Bring in sea level data and make it spatial
sea_level_2000 <- read.csv("tues-data/sea_lev_2000.csv")
sea_level_2000 <- sea_level_2000 %>%
  drop_na()
coordinates(sea_level_2000) <- ~long + lat

# Create a grid to IDW over
grd <- expand.grid(x = seq(-99, -80, by = 0.1),
                   y = seq(24, 32, by = 0.1))
coordinates(grd) <- ~x + y
gridded(grd) <- TRUE

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Inverse Distance Weighting"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("power",
                  "Power",
                  min = 0,
                  max = 25,
                  value = 1,
                  step = 0.1),
      checkboxInput("enablemaxdist",
                    "Enable MaxDist cutoff",
                    value = FALSE),
      sliderInput("maxdist",
                  "Max Dist",
                  min = 0,
                  max = 5,
                  value = 5,
                  step = 0.1,
                  round = FALSE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    if (input$enablemaxdist) {
      idw_pow1 <- idw(formula = elev_mm ~ 1,
                      locations = sea_level_2000,
                      newdata = grd,
                      maxdist = input$maxdist,
                      idp = input$power)
    } else {
      idw_pow1 <- idw(formula = elev_mm ~ 1,
                      locations = sea_level_2000,
                      newdata = grd,
                      idp = input$power)
    }
    
    plot(idw_pow1,
         col = terrain.colors(55),
         legend = FALSE)   
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

