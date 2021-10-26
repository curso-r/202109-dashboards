# Dispersão

dispersao_ui <- function(id) {
  ns <- NS(id)
  opcoes <- names(mtcars)
  tagList(
    fluidRow(
      column(
        width = 6,
        selectInput(
          ns("variavel_x"),
          "Selecione a variável do eixo X",
          choices = opcoes
        )
      ),
      column(
        width = 6,
        selectInput(
          ns("variavel_y"),
          "Selecione a variável do eixo Y",
          choices = opcoes,
          selected = opcoes[2]
        )
      )
    ),
    br(),
    fluidRow(
      column(
        width = 12,
        plotOutput(ns("grafico"))
      )
    )
  )
}

dispersao_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$grafico <- renderPlot({
      plot(mtcars[[input$variavel_x]], mtcars[[input$variavel_y]])
    })
    
  })
}