library(shiny)
library(dplyr)

dados <- readr::read_rds("../dados/pkmn.rds")

ui <- fluidPage(
  titlePanel("Shiny com sidebarLayout"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(
        "pokemon",
        label = "Selecione um Pokemon",
        choices = unique(dados$pokemon)
      )
    ),
    mainPanel = mainPanel(
      fluidRow(
        column(
          offset = 3,
          width = 6,
          imageOutput("imagem_pokemon")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$imagem_pokemon <- renderImage({
    id <- dados |> 
      filter(pokemon == input$pokemon) |> 
      pull(id) |> 
      stringr::str_pad(width = 3, side = "left", pad = 0)
    
    url <- glue::glue(
      "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
    )
    
    arquivo <- tempfile(fileext = ".png")
    # arquivo <- "pokemon.png"
    httr::GET(url, httr::write_disk(arquivo, overwrite = TRUE))
    # download.file(url, arquivo)
    
    list(
      src = arquivo,
      width = 300
    )
  })
  
}

shinyApp(ui, server)