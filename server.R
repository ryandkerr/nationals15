library(shiny)
library(BH)
library(ggvis)
indoor <- read.csv("data/nationals15.csv")
indoor$Assists_per_Game <- round(indoor$Assists / indoor$Games, digits = 1)
indoor$Goals_per_Game <- round(indoor$Goals/indoor$Games, digits = 1)
indoor <- replace(indoor, is.na(indoor), 0)

shinyServer(function(input, output) {

  # modify data
  selection <- reactive({
    # min and max assists from slider
    ast_min <- input$ast_range[1]
    ast_max <- input$ast_range[2]
    
    # min and max goals from slider
    goal_min <- input$goal_range[1]
    goal_max <- input$goal_range[2]
    
    # min and max games played from slider
    games_min <- input$game_range[1]
    games_max <- input$game_range[2]
        
    # filtering data
    s <- indoor[indoor$Assists >= ast_min &
                        indoor$Assists <= ast_max &
                        indoor$Goals >= goal_min &
                        indoor$Goals <= goal_max &
                        indoor$Games >= games_min &
                        indoor$Games <= games_max,]
    
    # filter by team
    if(input$team[1] != "All Players") {
      s <- s[s$Team == input$team[1],]
    }
    
    s
  })
        
  # tooltip function
  player_tooltip <- function(x) {
    if(is.null(x)) return(NULL)
    if(is.null(x$ID)) return(NULL)    
    
    players <- isolate(selection())
    selected_player <- players[players$ID == x$ID,]
    if(input$radio[1] == "totals") {  
      paste0("<b>", selected_player$Player, "</b><br>",
             "<b>Team: </b>", selected_player$Team, "<br>",
             "<b>Ast/Gm: </b>", selected_player$Assists_per_Game, "<br>",
             "<b>Gol/Gm: </b>", selected_player$Goals_per_Game)
    } else {
      paste0("<b>", selected_player$Player, "</b><br>",
             "<b>Team: </b>", selected_player$Team, "<br>",
             "<b>Assists: </b>", selected_player$Assists, "<br>",
             "<b>Goals: </b>", selected_player$Goals)
    }
  }
  
  # creating ggvis scatterplot
  scatter <- reactive({
    # scatterplot of total points/ast
    if(input$radio[1] == "totals") {
      selection %>%
        ggvis(~Assists, ~Goals, key := ~ID, text:= ~Player) %>%
        layer_text(angle := 20) %>%
        add_tooltip(player_tooltip, "hover")
    
    # scatterplot of per game stats
    } else {
      selection %>%
        ggvis(~Assists_per_Game, ~Goals_per_Game, key := ~ID, text := ~Player) %>%
        layer_text(angle := 20) %>%
        add_axis("x", title = "Assists/Game") %>%
        add_axis("y", title = "Goals/Game") %>%
        add_tooltip(player_tooltip, "hover")
    }
  })
      
  scatter %>% bind_shiny("scatter")
    
})