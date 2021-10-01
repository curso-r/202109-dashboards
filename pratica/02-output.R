library(shiny)

ui <- fluidPage(
  "Um histograma",
  plotOutput(outputId = "histograma")
)

server <- function(input, output, session) {
  
  output$histograma <- renderPlot({
    hist(mtcars$mpg)
  })
  
}

shinyApp(ui, server)