library(shiny)
library(dplyr)
library(ggplot2)

dados <- readr::read_rds("../dados/pkmn.rds")

ui <- fluidPage(
  titlePanel("Shiny com sidebarLayout"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      selectInput(
        "geracao",
        label = "Selecione uma geração",
        choices = unique(dados$id_geracao)
      ),
      # uiOutput("ui_pokemon")
      selectInput(
        "pokemon",
        label = "Selecione um Pokemon",
        choices = c("Carregando..." = ""),
        selectize = TRUE
      )
    ),
    mainPanel = mainPanel(
      fluidRow(
        column(
          offset = 3,
          width = 6,
          imageOutput("imagem_pokemon",  height = "205px")
        )
      )
    )
  ),
  fluidRow(
    column(
      width = 12,
      plotOutput("grafico")
    )
  )
)

server <- function(input, output, session) {
  
  # output$ui_pokemon <- renderUI({
  #   Sys.sleep(2)
  #   escolhas <- dados |>
  #     filter(id_geracao == input$geracao) |>
  #     pull(pokemon)
  #   selectInput(
  #     "pokemon",
  #     label = "Selecione um Pokemon",
  #     choices = escolhas
  #   )
  # })
  
  observe({
    # Sys.sleep(3)
    escolhas <- dados |>
      filter(id_geracao == input$geracao) |>
      pull(pokemon)
    updateSelectInput(
      session,
      "pokemon",
      choices = escolhas
    )
  })
  
  output$imagem_pokemon <- renderImage({
    
    req(input$pokemon)
    
    # validate(need(
    #   isTruthy(input$pokemon),
    #   "Carregando as opções"
    # ))
    
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
      width = 200
    )
  })
  
  output$grafico <- renderPlot({
    req(input$pokemon)
    print("Passei por aqui")
    dados |> 
      filter(id_geracao == isolate(input$geracao)) |>
      mutate(flag = ifelse(
        pokemon == input$pokemon, 
        input$pokemon, 
        "Média da geração"
      )) |> 
      tidyr::pivot_longer(
        cols = hp:velocidade,
        names_to = "status",
        values_to = "valor"
      ) |>
      group_by(status, flag) |> 
      summarise(valor = mean(valor)) |> 
      ggplot(aes(x = status, y = valor, fill = flag)) +
      geom_col(position = "dodge")
  })
  
}

shinyApp(ui, server)