library(shiny)
library(bs4Dash)
library(dplyr)
library(ggplot2)

# remotes::install_github("curso-r/basesCursoR")
# imdb <- basesCursoR::pegar_base("imdb")

separar <- function(tab, coluna) {
  tab |> 
    pull({{coluna}}) |> 
    stringr::str_split(", ") |> 
    purrr::flatten_chr() |> 
    unique()
}

separar_e_contar_distintos <- function(tab, coluna) {
  tab |> 
    separar({{coluna}})|> 
    length()
}

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info"),
      menuItem("Financeiro", tabName = "financeiro"),
      menuItem("Elenco", tabName = "elenco")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "info",
        fluidRow(
          column(
            width = 12,
            h2("Informações gerais dos filmes")
          )
        ),
        br(),
        fluidRow(
          infoBoxOutput(outputId = "num_filmes", width = 4),
          infoBoxOutput(outputId = "num_dir", width = 4),
          infoBoxOutput(outputId = "num_atr", width = 4)
        ),
        fluidRow(
          column(
            width = 12,
            plotOutput("grafico_filmes_ano", height = "400px")
          )
        )
      ),
      tabItem(
        tabName = "financeiro",
        fluidRow(
          column(
            width = 12,
            h2("Financeiro")
          )
        ),
        fluidRow(
          box(
            width = 4,
            title = "Filtros",
            status = "info",
            solidHeader = TRUE,
            uiOutput(outputId = "ui_fin_genero")
          ),
          box(
            width = 8,
            plotOutput("grafico_orc_vs_receita")
          )
        )
      ),
      tabItem(
        tabName = "elenco",
        # Lição de casa: dado um ator/atriz (ou diretor(a)), mostrar um
        # gráfico com os filmes feitos por essa pessoa e a nota desses filmes.
      )
    )
  )
)

server <- function(input, output, session) {
  
  # imdb <- readr::read_rds("dados/imdb.rds")
  imdb <- basesCursoR::pegar_base("imdb")
  
  output$num_filmes <- renderInfoBox({
    numero_de_filmes <- nrow(imdb) |> 
      scales::number(big.mark = ".", decimal.mark = ",")
    infoBox(
      title = "Número de filmes",
      value = numero_de_filmes,
      subtitle = "teste",
      color = "orange",
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$num_dir <- renderInfoBox({
    numero_dir <- separar_e_contar_distintos(imdb, direcao)
    infoBox(
      title = "Número de diretoras(res)",
      value = numero_dir,
      color = "fuchsia",
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$num_atr <- renderInfoBox({
    numero_atr <- separar_e_contar_distintos(imdb, elenco)
    numero_de_filmes <- nrow(imdb)
    infoBox(
      title = "Número de atores/atrizes",
      value = numero_atr,
      color = "navy",
      icon = icon("film"),
      fill = TRUE
    )
  })
  
  output$grafico_filmes_ano <- renderPlot({
    imdb |> 
      count(ano, sort = TRUE) |> 
      ggplot(aes(x = ano, y = n)) +
      geom_col(color = "black", fill = "pink") +
      ggtitle("Número de filmes por ano")
  })
  
  output$ui_fin_genero <- renderUI({
    generos <- separar(imdb, genero) |> sort()
    selectInput(
      inputId = "fin_genero",
      label = "Selecione um ou mais gêneros",
      multiple = TRUE,
      choices = generos,
      selected = "Action"
    )
  })
  
  output$grafico_orc_vs_receita <- renderPlot({
    imdb |> 
      mutate(
        genero = stringr::str_split(genero, ", ")
      ) |>
      tidyr::unnest(genero) |> 
      filter(genero %in% input$fin_genero) |>
      distinct(titulo, .keep_all = TRUE) |> 
      ggplot(aes(x = orcamento, y = receita)) +
      geom_point()
  })
  
}

shinyApp(ui, server)