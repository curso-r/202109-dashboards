library(shiny)

ui <- navbarPage(
  title = "Shiny com navbarPage",
  header = icon("user"),
  footer = icon("user"),
  tabPanel(
    title = "Tela 1",
    h2("Conteúdo da tela 1"),
    sliderInput(
      "tamanho",
      label = "Tamanho da amostra",
      value = 100,
      min = 1,
      max = 1000
    )
  ),
  tabPanel(
    title = "Tela 2",
    h2("Conteúdo da tela 2"),
    plotOutput("grafico")
  ),
  navbarMenu(
    title = "Várias telas",
    tabPanel(
      title = "Tela 3",
      h2("Conteúdo da tela 3")
    ),
    tabPanel(
      title = "Tela 4",
      h2("Conteúdo da tela 4")
    )
  )
)

server <- function(input, output, session) {
  
  output$grafico <- renderPlot({
    Sys.sleep(5)
    rnorm(input$tamanho) |> 
      hist()
  })
  
}

shinyApp(ui, server)