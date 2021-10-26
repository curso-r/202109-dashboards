# Histograma

histograma_ui <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(
      ns("variavel_x"),
      "Selecione uma variável",
      choices = names(mtcars)
    ),
    br(),
    plotOutput(ns("grafico"))
  )
}

histograma_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$grafico <- renderPlot({
      hist(mtcars[[input$variavel_x]])
    })
    
    # variavel_x <- reactive({
    #   input$variavel_x
    # })
    # 
    # 
    # return(input$variavel_x)
    
  })
}

# Versão parametrizada
#
# histograma_ui <- function(id, base) {
#   ns <- NS(id)
#   tagList(
#     selectInput(
#       ns("variavel_x"),
#       "Selecione uma variável",
#       choices = names(base)
#     ),
#     br(),
#     plotOutput(ns("grafico"))
#   )
# }
# 
# histograma_server <- function(id, base) {
#   moduleServer(id, function(input, output, session) {
#     
#     output$grafico <- renderPlot({
#       hist(base[[input$variavel_x]])
#     })
#     
#   })
# }