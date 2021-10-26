library(shiny)
library(ggplot2)
library(dplyr)

pokemon <- readr::read_rds("../../../dados/pkmn.rds")

ui <- navbarPage(
  title = "Pokémon",
  id = "menu"
)

server <- function(input, output, session) {

  tipos <- pokemon$tipo_1
  
  purrr::walk(
    unique(tipos),
    ~ appendTab(
      "menu",
      tabPanel(
        title = stringr::str_to_title(.x),
        # no Windows precisou tirar os acentos dos ids
        conteudoUI(abjutils::rm_accent(.x))
      ),
      select = ifelse(.x == "grama", TRUE, FALSE)
    )
  )

  purrr::walk(
    unique(tipos),
    # no Windows precisou tirar os acentos dos ids
    ~ conteudoServer(abjutils::rm_accent(.x), .x, pokemon)
  )

}

shinyApp(ui, server)
