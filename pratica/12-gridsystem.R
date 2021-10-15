quadrado <- function(text = "") {
  div(
    style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;", 
    text
  )
}

quadrado2 <- function(text = "") {
  div(
    style = "background: green; height: 100px; text-align: center; color: white; font-size: 24px;", 
    text
  )
}

library(shiny)

ui <- fluidPage(
  br(),
  fluidRow(
    column(
      width = 3,
      offset = 9,
      quadrado("Canto superior direito")
    )
  ),
  br(),
  fluidRow(
    column(
      width = 3,
      quadrado(1)
    ),
    column(
      width = 3,
      quadrado(2)
    ),
    column(
      width = 3,
      quadrado(3)
    ),
    column(
      width = 3,
      quadrado(4)
    )
  ),
  br(),
  fluidRow(
    column(width = 1, quadrado(5)),
    column(width = 3, offset = 8, quadrado(6))
  ),
  br(),
  fluidRow(
    column(
      width = 6,
      quadrado("Coluna de tamanho 6"),
      fluidRow(
        column(
          width = 10,
          quadrado2("Coluna2 de tamanho 10")
        ),
        column(
          width = 2,
          quadrado2("T2")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)