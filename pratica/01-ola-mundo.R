library(shiny)

ui <- fluidPage("Olá, mundo")

server <- function(input, output, session) {
  # código R
}

shinyApp(ui, server)