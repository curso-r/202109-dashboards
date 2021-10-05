library(shiny)

ui <- fluidPage(
  "Um histograma",
  selectInput(
    inputId = "variavel",
    label = "Escolha uma variável",
    choices = names(mtcars)
  ),
  plotOutput(outputId = "histograma")
)

server <- function(input, output, session) {
  
  output$histograma <- renderPlot({
    hist(mtcars[[input$variavel]], main = titulo)
  })
  
  titulo <- "Meu histograma"
  
}

shinyApp(ui, server)