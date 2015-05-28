shinyServer
(
    function(input, output){
        
        createCodeList <- function(pctBugs)
        {
            r<-runif(1)
            
            if(r<pctBugs)
            {
                return("Bug")
            }
            return("CleanCode")
        }
        
        
        RunTheSim <- function( testAccy = 0.9, pctBug = 0.005, fixedSeed = TRUE)
        {
            if(fixedSeed==TRUE)
            {
                set.seed(75961)
            }
            
            totalLoc <- 10000 #10,000 lines of code
            numBugs = 0
            codeList <- array("", dim=c(1,totalLoc))
            i<-totalLoc
            
            #first, create the 10,000 citizens that will be tested
            while (i>0)
            {
                codeList[i]<- createCodeList(pctBug)
                if(codeList[i]=='Bug')
                {
                    numBugs = numBugs + 1
                }
                i=i-1
            }
            
            #now we have an array or citizens that are either Innocent or Terrorist
            #subject them to the test
            i<-totalLoc
            
            
            #set up results values
            #tp is true positives.  This is the sum of actual bugs identified as bugs
            #tn is true negatives.  This is the sum of clean code identified as bug free
            #fp is false positives. This is the sum of clean code identified as buggy - BAD!
            #fn is false negatives. This is the sum of bugs identified as clean - bugs we ship to customers
            tp=0
            fp=0
            tn=0
            fn=0
            
            while(i>0)
            {
                r<-runif(1)
                #4 states.  The test can be accurate or inaccurate
                #           The code can be buggy or clean
                
                if (r<testAccy)
                {
                    #then we have accurately discovered if line of code is a bug or clean
                    #this code is written for simplicity of understanding, not performance
                    if(codeList[i]=="Bug")
                    {
                        tp=tp+1
                    }
                    if(codeList[i]=="CleanCode")
                    {
                        tn=tn+1
                    }
                }
                #this means the test was inaccurate
                #again, simplicity, not performance
                if(r>= testAccy)
                {
                    if(codeList[i]=="Bug")
                    {
                        fp=fp+1
                    }
                    if(codeList[i]=="CleanCode")
                    {
                        fn=fn+1
                    }          
                }
                i=i-1
            }
            
            #for most purposes, the sim can ignore the true negatives (clean code tagged as clean)
            #to make the rest of the bars scale better
            zoomPlot<-c(numBugs,tp,fp,fn)
            ymax = which.max(zoomPlot)
            bugChance <- round(tp / (fn+tp),3)
            actualBugPctFound <- round(tp / numBugs, 3)
            myPlot<-barplot(zoomPlot,main=paste("Finding Bugs\nBug pct Found = ",as.numeric(actualBugPctFound)*100,"%",
                                                "\nChance Failing test is bug = ",as.numeric(bugChance)*100,"%"),
                            names.arg=c(paste("Actual Bugs", numBugs),
                                        paste("Bugs Caught",tp),
                                        paste("Bugs Missed",fp),
                                        paste("Clean Code IDed as bug",fn)),
                            col = c("blue","green","red","red"),
                            ylim=c(0,zoomPlot[ymax])
            )
            
            return (c(tp,fp,tn,fn, myPlot))
        }
            tp<<-0
            fp<<-0

            output$barChart <- renderPlot({
                                results<-RunTheSim(input$testAccy, input$pctBugs)
                                tp<<- results[1]
                                fp<<-results[4]
                                })

            output$time <- renderText({
                totalMins <- input$timeToInvestigate * (tp+fp)
                totalHours <- as.integer(totalMins / 60)
                totalMins <- round(totalMins %% 60,2)
                duration <<- paste(totalHours,"hours, ", totalMins," minutes")
                paste('Time needed to investigate all failures:', duration)})

})