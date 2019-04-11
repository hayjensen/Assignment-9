## ui.R ##
library(shinydashboard)


dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    numericInput(
      "sep.length"
      , "Sepal Length:"
      , 5)
    ,
    numericInput(
      "sep.width"
      ,'Sepal Width:'
      ,3)
    ,
    numericInput(
      "p.length"
      ,'Petal Length:'
      ,1)
    ,
    numericInput(
      "p.width"
      ,'Petal Width:'
      ,.3)
  ),
  dashboardBody(
    fluidRow(
      box(DT::dataTableOutput("predictions"))
      # ,box(plotOutput("graph"))
    )
    
    )
  )

