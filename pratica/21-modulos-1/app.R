library(shiny)

# Se a pasta não se chamar R
# source("R0/histograma.R")
# source("R0/dispersao.R")

# UI ----------------------------------------------------------------------

ui <- fluidPage(
  h1("Treinando a construção de módulos"),
  fluidRow(
    column(
      width = 6,
      histograma_ui("histograma"),
    ),
    column(
      width = 6,
      dispersao_ui("dispersao")
    )
  )
)


# server ------------------------------------------------------------------

server <- function(input, output, session) {

  histograma_server("histograma")
  
  dispersao_server("dispersao")
    
  # variavel_x <- histograma_server("histograma")
  # outroModulo_server("id_do_outro_mod", variavel_x)
}

shinyApp(ui, server)