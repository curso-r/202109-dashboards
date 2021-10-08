library(shiny)
library(dplyr)

imdb <- readr::read_rds("../dados/imdb.rds")

ui <- fluidPage(
  sliderInput(
    inputId = "anos",
    label = "Selecione o intervalo de anos",
    min = min(imdb$ano, na.rm = TRUE),
    max = max(imdb$ano, na.rm = TRUE),
    value = c(2000, 2010),
    step = 1,
    sep = ""
  ),
  tableOutput(outputId = "table")
)

server <- function(input, output, session) {
  
  # dados <- reactive({
  #   query(banco_de_dados, imdb, input$anos[1]:input$anos[2])
  # })
  
  output$table <- renderTable({
    dados() %>% 
      filter(ano %in% input$anos[1]:input$anos[2]) %>% 
      select(titulo, ano, diretor, receita, orcamento) %>% 
      mutate(lucro = receita - orcamento) %>%
      top_n(20, lucro) %>% 
      arrange(desc(lucro)) %>% 
      mutate_at(vars(lucro, receita, orcamento), ~ scales::dollar(.x))
  })
  
}

shinyApp(ui, server)