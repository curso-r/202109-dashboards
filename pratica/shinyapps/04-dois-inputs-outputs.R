library(shiny)

opcoes <- names(mtcars)

ui <- fluidPage(
  selectInput(
    inputId = "variavel_A",
    label = "Variável A",
    choices = opcoes
  ),
  plotOutput(outputId = "histograma_A"),
  selectInput(
    inputId = "variavel_B",
    label = "Variável B",
    choices = opcoes,
    selected = opcoes[2]
  ),
  plotOutput(outputId = "histograma_B")
)

server <- function(input, output, session) {
  
  output$histograma_A <- renderPlot({
    print("RODEI O CODIGO DO A")
    hist(mtcars[[input$variavel_A]], main = "Histograma A")
  })
  
  output$histograma_B <- renderPlot({
    print("RODEI O CODIGO DO B")
    input$variavel_A
    hist(mtcars[[input$variavel_B]], main = "Histograma B")
  })
  
}

shinyApp(ui, server)