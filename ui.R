shinyUI(fluidPage(
    titlePanel("Test Accuracy Simulation"),
    
    sidebarLayout(
        sidebarPanel(
            helpText("Identify bugs in 10,000 lines of code using 10,000 test with a given accuracy.  
                     You control the accuracy of the test and the percent of the code that 
                     has a bug.  Try to maximize bugs found while minimizing false positives"),
            
            sliderInput("testAccy", 
                        label = "Accuracy of Test:",
                        min = .5, max = 1, value = 0.9, step =.00025),
            
            sliderInput("pctBugs", 
                    label = "Percent of code that has a bug",
                    min = 0, max = 1, value = 0.005, step =.001),
            
            sliderInput('timeToInvestigate',
                        label = 'Investigation minutes needed per failure (need to toggle to refresh)',
                        min = 0, max = 120, value = 10, step = 1)
            ),
        
        mainPanel(
            plotOutput('barChart'),
            textOutput('time')
        )
    )
))