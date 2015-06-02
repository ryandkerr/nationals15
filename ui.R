library(shiny)
library(BH)
library(ggvis)

shinyUI(fluidPage(
  titlePanel("2015 College Ultimate Nationals - Men's and Women's"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("radio", label = "Division",
                   choices = list("Men's" = "mens", "Women's" = "womens"),
                   selected = "mens"),

      sliderInput("ast_range", "Assists:",
                  min = 0, max = 60, value = c(0, 60)),
      
      sliderInput("goal_range", "Goals:",
                  min = 0, max = 60, value = c(0, 60)),

      selectInput("team", label = "Team:",
                  choices = list("All Players", "Josh Fries Memorial", "No Flex Zone", "Swai Guys",
                                 "Rooftop Swai Farm", "Brawl or Nothing", "The Buns", "Lev Towers", "Motherhuckers "),
                  selected = "All Players")
    ),
    
    mainPanel(
      ggvisOutput("scatter")
    )
    
  )
))