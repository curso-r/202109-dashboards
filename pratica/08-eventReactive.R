library(shiny)

ui <- fluidPage(
  "Formulário",
  textInput(
    inputId = "nome",
    label = "Digite o seu nome"
  ),
  numericInput(
    inputId = "idade",
    label = "Idade",
    value = 30,
    min = 18,
    max = NA,
    step = 1
  ),
  textInput(
    inputId = "estado",
    label = "Estado onde mora"
  ),
  actionButton(
    inputId = "botao",
    label = "Enviar"
  ),
  br(),
  "Resposta",
  br(),
  textOutput(outputId = "resposta")
)

server <- function(input, output, session) {
  
  # frase <- eventReactive(input$botao, {
  #   glue::glue(
  #     "Olá! Eu sou {input$nome}, tenho {input$idade} e moro em/no {input$estado}."
  #   )
  # })

  
  frase <- reactive({
    nome <- isolate(input$nome)
    idade <- isolate(input$idade)
    "a" + 1
    glue::glue(
      "Olá! Eu sou {nome}, tenho {idade} e moro em/no {input$estado}."
    )
  })
  
  output$resposta <- renderText({
    frase()
  })
  
}

shinyApp(ui, server)