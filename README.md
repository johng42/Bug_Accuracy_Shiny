# Bug_Accuracy_Shiny
R version of bug accuracy stochastic sim


A tester on my team saw a new tool that promises >90% accuracy in performing validations and wanted to integrate that into our automation.  I immediately replied “No!  That is not nearly ready for general use.”  

The immediate reaction I had stunned the engineer a bit.  I wanted to explain why I had such an emphatic reaction.  In the past, I would try to explain the statistics behind why this is not a valid test to actually use.  Being a mathematician at heart, I would rely on some probability theory in my explanation.  Sadly, when I tried this approach, I would notice eyes glazing over when I started to say things like, “The probability of A given the probability of B…”  As a result, I was not able to effectively explain why this is a bad validation to implement, and the team would just kind of nod along and never be convinced that we wanted to avoid this.  Now, we all know that most folks around here are pretty smart and there should be a way to explain this that makes sense without getting into the details of the finer points of statistics.  

After mulling this over for quite a while, I finally decided to try something we all understand around here: code.  I wrote a little down-n-dirty simulation - https://johng42.shinyapps.io/Bug_Accuracy/ -  to show the necessity of accurate tests.  In mathematical lingo, this is a stochastic simulation of the following model:
1.	Assume you are testing 10K lines of code
2.	You can set the percent chance any line of code contains a bug.  By default, this is 0.5%
3.	You also control how accurate your test is.  The default is 90% accurate
a.	Detail oriented folks will notice that there are 58 bugs to find in the sim.  
b.	I used R 3.2 with a random seed of 75961 to populate the list – it just works out in this case that you get 58 bugs.
4.	Twiddle the settings and you can see how many bugs you correctly identify.  With 90% accuracy, you find 50 of the 58 bugs – not bad at 86%!
5.	Sadly, you also get almost 1000 false failures in that case.  The chance that a failing test is actually a bug is only 5%.  
6.	I also through in a control to let you see how many hours you will need to investigate the failures.

To me, point 5 is the key.  The problem is that so much code is bug free that a 90% accurate test will take about 10% of the clean code and mislabel it.  Looking at the code and results of this simulation might be more useful than brushing up on the math we learned in that one introductory stats class we took years ago…

Tl,dr; You need tests that have a 99.93% accuracy to get near tests identifying bugs 90% of the time.  


Bonus fun: change the nouns in this sim from "bug" to "terrorist" and from "clean code" to "innocent citizen."  



Thanks,
John
