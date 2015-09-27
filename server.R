
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(quantmod)
library(dygraphs)
library(forecast)
#from.dat <- as.Date("01/01/05", format="%m/%d/%y")
#to.dat <- as.Date("12/31/15", format="%m/%d/%y")
#symbols <- c('AAPL','GOOGL','MSFT','AMZN','T','VZ','ORCL','CMCSA','IBM','INTC')
#names <- c('Apple', 'Google', 'Microsoft', 'Amazon', 'AT&T', 'Verizon', 'Oracle', 'Comcast', 'IBM', 'Intel')
#symbolList <- list()
#symbolList <- lapply(symbols, function(x) {getSymbols(x,src="yahoo", from = from.dat, to = to.dat, auto.assign=FALSE)} )
#names(symbolList) <- symbols
#saveRDS(symbolList,"symbolList.rds")
symbolList <- readRDS("symbolList.rds")

shinyServer(function(input, output) {

  stockInput <- reactive({input$stock})
  paramInput <- reactive({input$param})
  startDateInput <- reactive({input$date})
  symb <- reactive({
    switch(stockInput(),
           "Apple"     = 'AAPL', 
           "Google"    = 'GOOGL', 
           "Microsoft" = 'MSFT', 
           "Amazon"    = 'AMZN', 
           "AT&T"      = 'T', 
           "Verizon"   = 'VZ', 
           "Oracle"    = 'ORCL', 
           "Comcast"   = 'CMCSA', 
           "IBM"       = 'IBM', 
           "Intel"     = 'INTC',
           'AAPL')
  })
  output$dygraph <- renderDygraph({
    s <- symbolList[[symb()]]
    data <- switch(paramInput(),
                   "Open"      = Op(s),
                   "High"      = Hi(s),
                   "Low"       = Lo(s),
                   "Close"     = Cl(s),
                   "Volume"    = Vo(s),
                   "Adjusted"  = Ad(s),
                   Ad(s)
    )
    
    dygraph(data, main = stockInput()) %>% 
      dySeries(paste0(symb(),'.',paramInput()), label = symb()) %>%
      dyRangeSelector()
  })
  
  output$plot <- renderPlot({
    # retrieve selected stock data
    s <- symbolList[[symb()]]
    
    #compute no of months for the prediction period
    excluded <- s[index(s)>=startDateInput()]
    mExcluded <- to.monthly(excluded)
    h=nrow(mExcluded)
    
    #
    mAll <- to.monthly(s)
    mAllAd <- Ad(mAll)
    ts1All <- ts(mAllAd,frequency=12,start=c(2005,1))
    year <- as.numeric(format(startDateInput(), "%Y"))
    month <- as.numeric(format(startDateInput(), "%m"))
    ts1Test <- window(ts1All,start=c(year,month))
    ts1Train <- window(ts1All,end=c(year,month))
      
    ets1 <- ets(ts1Train,model="MMM")
    
    #Forecast until one year in the future
    fcast <- forecast(ets1,h=h+12)
    plot(fcast,xlab="Year", ylab=paste0(symb(),".Adjusted"))
    #draw actual values for comparison with the predicted ones
    lines(ts1Test,col="black")
    legend('topleft', c("Actual","Predicted"), 
           lty=1, col=c('black', 'blue'), bty='n', cex=1)
  })
  
})
