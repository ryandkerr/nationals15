library(shiny)
library(BH)
library(ggvis)
nationals <- read.csv("data/nationals15.csv")
nationals$ID <- 1:nrow(nationals)
nationals$Assists_per_Game <- round(nationals$Assists / nationals$Games, digits = 1)
nationals$Goals_per_Game <- round(nationals$Goals/nationals$Games, digits = 1)
nationals <- replace(nationals, is.na(nationals), 0)

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
    # games_min <- input$game_range[1]
    # games_max <- input$game_range[2]
        
    # filtering data
    s <- nationals[nationals$Assists >= ast_min &
                        nationals$Assists <= ast_max &
                        nationals$Goals >= goal_min &
                        nationals$Goals <= goal_max,]
                        # indoor$Games >= gLames_min &
                        # indoor$Games <= games_max,]
    
    if(input$radio[1] == "mens") {
      s <- s[s$Division == "Men's",]
    } else {
      s <- s[s$Division == "Women's",]
    }

    # filter by team
    if(input$team[1] != "All Teams") {
      s <- s[s$Team == input$team[1],]
    }
    
    s
  })
        
  # tooltip function
  player_tooltip <- function(x) {
    # if(is.null(x)) return(NULL)
    # if(is.null(x$ID)) return(NULL)    
    
    players <- isolate(selection())
    selected_player <- players[players$ID == x$ID,]
    # paste0("<b>", selected_player$Player, "</b><br>",
    #        "<b>Team: </b>", selected_player$Team, "<br>",
    #        "<b>Ast/Gm: </b>", selected_player$Assists_per_Game, "<br>",
    #        "<b>Gol/Gm: </b>", selected_player$Goals_per_Game)
    
    paste0("<b>", selected_player$Player, "</b><br>",
           "<b>Team: </b>", selected_player$Team, "<br>",
           "<b>Assists: </b>", selected_player$Assists, "<br>",
           "<b>Goals: </b>", selected_player$Goals)
  }
  
  # creating ggvis scatterplot
  scatter <- reactive({
    if(input$radio2[1] == "Names" && input$radio3 == "Totals") {
      selection %>%
        ggvis(~Assists, ~Goals, key := ~ID, text:= ~Player) %>%
        layer_text(angle := 20) %>%
        add_tooltip(player_tooltip, "hover")
      
    } else if(input$radio2[1] == "Circles" && input$radio3 == "Totals") {
      selection %>%
        ggvis(~Assists, ~Goals, key := ~ID) %>%
        layer_points(fill = ~Team, size := 75, size.hover := 200,
                     fillOpacity := 0.45, fillOpacity.hover := 0.7,
                     strokeWidth := 0) %>%
        add_tooltip(player_tooltip, "hover")
    
    } else if(input$radio2[1] == "Names" && input$radio3 == "Per Game") {
      selection %>%
        ggvis(~Assists_per_Game, ~Goals_per_Game, key := ~ID, text := ~Player) %>%
        layer_text(angle := 20) %>%
        add_axis("x", title = "Assists per Game") %>%
        add_axis("y", title = "Goals per Game") %>%
        add_tooltip(player_tooltip, "hover") %>%
        hide_legend("fill")
    } else {
      selection %>%
        ggvis(~Assists_per_Game, ~Goals_per_Game, key := ~ID) %>%
        layer_points(stroke := "black", fill = ~Team, size := 75, size.hover := 200,
                     fillOpacity := 0.45, fillOpacity.hover := 0.7,
                     strokeWidth := 0) %>%
        add_axis("x", title = "Assists per Game") %>%
        add_axis("y", title = "Goals per Game") %>%
        add_tooltip(player_tooltip, "hover") %>%
        hide_legend("fill")
    }
  })
      
  scatter %>% bind_shiny("scatter")
    
})