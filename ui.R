library(shiny)
library(BH)
library(ggvis)
nats <- data.frame(read.csv("data/nationals15.csv"))
team_vector <- as.vector(nats$Team)
teams <- c("All Teams")
for(i in 1:length(nats$Team)) {
  t <- team_vector[i]
  if(t %in% teams == FALSE) {
    teams <- append(t, teams)
  } 
}
teams <- sort(teams)


shinyUI(fluidPage(
  titlePanel("2015 College Ultimate Nationals - Men's and Women's"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("radio3", label = "Data:",
                   choices = c("Totals", "Per Game"), selected = "Totals"),
      
      radioButtons("radio", label = "Division",
                   choices = list("Men's" = "mens", "Women's" = "womens"),
                   selected = "mens"),

      sliderInput("ast_range", "Assists:",
                  min = 0, max = 60, value = c(0, 60)),
      
      sliderInput("goal_range", "Goals:",
                  min = 0, max = 60, value = c(0, 60)),

      helpText("When selecting teams be sure to also select the correct division above."),
      
      selectInput("team", label = "Team:",
                  choices = teams,
                  selected = "All Players"),
      
      radioButtons("radio2", label = "Plot", choices = c("Names", "Circles"),
                   selected = "Names")
    ),
    
    mainPanel(
      ggvisOutput("scatter")
    )
    
  )
))