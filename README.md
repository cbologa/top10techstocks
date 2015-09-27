**Note to reviewers**
Thank you for evaluating my work for this project assignment. This very small and limited application demonstrates very basic Shiny functionality, as required in the project assignment. The application displays a number of indicators for 10 selected large technology stocks, and also predicts their Adjusted value for a limited period of time (up to 9 months in the past plus 12 months in the future). 

**Basic functionality:**
* Use the drop-down menu *Choose a stock* to change the `input$stock` variable, causing a new interactive plot to be rendered, in the *Display*, or "Predict" tab.
* While in the *Display* tab, switch different radio buttons to change the indicator being displayed in the interactiv graph
* In the *Predict* tab, change the start of the prediction period (only since the begining of the 2015 until now), and see how the predicted values and intervals change.

**Comments**
This application is not intended to solve a real world problem, but only to satisfy the requirements of the project assignment. Although it is possible to make it more robust and more general, I chose not to do it in order to make it faster to run and easier to evaluate. For those reasons I chose to not validate any inputs, and to not retrieve stock market data online, but to download it for only 10 large technology companies.
 
