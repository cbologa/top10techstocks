

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dygraphs)

shinyUI(fluidPage(
  # Application title
  titlePanel("Stock Market Display And Prediction"),
  
  # Custom layout
  helpText(
    "Displays and predicts stock values for ten selected large technology companies"
  ),
  
  selectInput(
    "stock",
    label = "Choose a stock",
    choices = list(
      "Apple", "Google", "Microsoft", "Amazon", "AT&T",
      "Verizon", "Oracle", "Comcast", "IBM", "Intel"
    ),
    selected = "Apple"
  ),
  
  tabsetPanel(
    tabPanel("Display",
             fluidRow(
               column(
                 1,
                 radioButtons(
                   "param",
                   label = "Choose indicator",
                   choices = list("Open", "High", "Low", 
                                  "Close", "Volume", "Adjusted"),
                   selected = "Adjusted"
                 )
               ),
               column(11,
                      dygraphOutput("dygraph"))
             )),

    tabPanel(
      "Predict",
      dateInput(
        "date", label = "Prediction Start Date",
        value = "2015-01-01",
        min   = "2015-01-01",
        max   = "2015-09-15",
        format = "yyyy-mm-dd"
      ),
      plotOutput("plot")
    )
  )
))
