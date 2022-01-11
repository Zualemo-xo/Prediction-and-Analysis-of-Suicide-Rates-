library(shiny)
library(plotly)
library(dplyr)
library(shinythemes)
library(data.table)
library(ggplot2)
library(shinydashboard)
shinyUI(
  
  dashboardPage(
    dashboardHeader(title = "SUICIDE ANALYSIS"),
    
    dashboardSidebar(sidebarMenu(
      menuItem("General Analysis",tabName="General_Analysis",icon=icon("tree")),
      menuItem("Analysis on States",tabName="Analysis_on_States",icon=icon("tree")),
      menuItem("Type Code",tabName="Type_Code",icon=icon("tree")),
      menuItem("Means and Causes Adopted",tabName="Means_and_Causes_Adopted",icon=icon("tree")),
      menuItem("Machine Learning Model",tabName="Machine_Learning",icon=icon("tree"))
      #menuItem("Characteristic_Of_Tournament",tabName="Characteristic_Of_Tournament",icon=icon("car"))
    )),
    dashboardBody(  
      tabItems(
        #tab1
        tabItem("General_Analysis",
                fluidPage(
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotOutput("plot1"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot2"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  ),
                  
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot3"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot4"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  )
                  
                )
        ),
        
        
        #tab2
        tabItem("Analysis_on_States",
                fluidPage(
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot5"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotOutput("plot6"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  ),
                  
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot7"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot8"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  )
                  
                )
        ),
        
        
        
        #tab3
        tabItem("Type_Code",
                fluidPage(
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot9"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot10"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  ),
                  
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot11"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot12"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  )
                  
                )
        ),
        
        
        
        #tab4
        tabItem("Means_and_Causes_Adopted",
                fluidPage(
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot13"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    
                    column(# width should be between 1 and 12
                      width=6,
                      box(plotlyOutput("plot14"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    )
                  ),
                  
                  fluidRow(
                    column(# width should be between 1 and 12
                      width=12,
                      box(plotlyOutput("plot15"), 
                          # For column based layouts, we can set box width to NULL
                          # This overrides the default value
                          width=NULL) 
                    ),
                    

                  )
                  
                )
        ),
        
        
        
        
        #tab5
        
        #tab4
        tabItem("Machine_Learning",
                fluidPage(
                   fluidRow(
                    
                    box(
                      title = "Prediction of Total Suicide Count"
                      ,status = "primary"
                      ,solidHeader = TRUE
                      ,collapsible = TRUE
                      # ,selectInput("filterVariable", "Filter:",
                      #             c("Course Title" = "courseTitle",
                      #               "Reviews" = "courseReviews"))
                      # ,uiOutput('dynamic')
                      ,textInput("Year",label="Year")
                      ,selectInput("AgeInp",label="Age Group",c("15-29"="Age_group15-29","30-44"="Age_group30-44","45-59"="Age_group45-59","60+"="Age_group60+"))
                      ,selectInput("StateInp",label="State",c("Maharashtra"="StateMaharashtra","West Bengal"="StateWest Bengal"))
                      
                      ,actionButton("Submit","Predict")
                    ),
                    tableOutput("prediction")
                  
                )
        ) )
        
        

        
      )
    )
  )
  
)
