library(tidyverse)
library(shiny)
library(xgboost)
server <- function(input, output) {
    newPredict<-reactive({data.frame(Sepal.Length=input$sep.length, Sepal.Width=input$sep.width,
                           Petal.Length=input$p.length, Petal.Width=input$p.width) 
    
  
       # x<-reactive({
        #  c(input$sep.length
       #   ,input$sep.width
       #  , input$p.length 
        #  ,input$p.width )
        })
        
 output$predictions<-DT::renderDataTable({
   newPredict<-as.matrix(newPredict())
    predict(IrisModel,newPredict) 
})
  }
 
#   
#   output$table <- DT::renderDataTable({
#     DF()
#   }#, options = list(autoWidth = TRUE)
#   )
#   
#   
#   output$AvePoints <- renderValueBox({
#     valueBox(
#       round(mean(DF()$PF), 2)
#       ,"Average Points"
#     )
#   })
#   
#   output$AvePA <- renderValueBox({
#     valueBox(
#       round(mean(DF()$PA), 2)
#       ,"Average Points Allowed"
#     )
#   })
#   
#   output$Wins <- renderValueBox({
#     valueBox(
#       sum(DF()$WL == 'W')
#       ,"Wins"
#     )
#   })
#   
#   
#   output$Losses <- renderValueBox({
#     valueBox(
#       sum(DF()$WL == 'L')
#       ,"Losses"
#     )
#   })
#   
# }


