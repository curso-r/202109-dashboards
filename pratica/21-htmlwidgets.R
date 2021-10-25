library(shiny)
library(shinydashboard)

library(plotly)
library(reactable)
library(leaflet)

# remotes::install_github("abjur/abjData")

pnud <- abjData::pnud_min %>% 
  dplyr::filter(ano == "2010")

ui <- dashboardPage(
  
  skin = "purple",
  
  dashboardHeader(title = "PNUD"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Informações gerais", tabName = "info") 
    )
  ),
  
  dashboardBody(
    
    tabItems(
      tabItem(
        tabName = "info",
        h2("Informações gerais dos municípios"),
        br(),
        # primeira linha - cards
        fluidRow(
          infoBoxOutput(
            outputId = "num_muni",
            width = 4
          ),
          infoBoxOutput(
            outputId = "maior_idhm",
            width = 4
          ),
          infoBoxOutput(
            outputId = "menor_idhm",
            width = 4
          )
        ),
        # segunda linha
        fluidRow(
          
          box(
            width = 6,
            title = "Gráfico",
            plotlyOutput("grafico")
          ),
          
          box(
            width = 6,
            title = "Mapa",
            leafletOutput("mapa")
          )
          
          
        ),
        
        # terceira linha
        fluidRow(
          
          
          box(
            width = 12,
            title = "Dados",
            reactableOutput("tabela"),
            downloadButton("baixar", "Baixar!")
          )
          
        )
        
      )
    )
    
  )
  
)

server <- function(input, output, session) {
  
  dados <- reactive({
    
    pnud
    
  })
  
  output$grafico <- renderPlotly({
    
    # browser()
    
    p <- pnud %>% 
      ggplot(aes(rdpc, espvida, colour = regiao_nm,
                 size = pop/1e6)) +
      geom_point() +
      scale_colour_viridis_d(begin = .2, end = .8) +
      labs(
        x = "Renda per capita",
        y = "Expectativa de vida",
        colour = "Região",
        size = "População"
      ) +
      theme_minimal(12)
    
    if (!is.null(selected())) {
      linha_selecionada <- pnud %>% 
        dplyr::slice(selected())
      
      p <- p +
        geom_point(colour = "red", data = linha_selecionada)
      
    }

    
    
    ggplotly(p)
    
  })
  
  
  output$mapa <- renderLeaflet({
    
    pnud %>% 
      leaflet() %>% 
      addTiles() %>% 
      addMarkers(
        lng = ~lon,
        lat = ~lat,
        popup = ~muni_nm,
        clusterOptions = markerClusterOptions()
      )
    
  })
  
  selected <- reactive({
    getReactableState("tabela", "selected")
  })
  
  output$tabela <- renderReactable({
    
    pnud %>% 
      dplyr::select(
        muni_id, muni_nm, uf_sigla, regiao_nm, idhm,
        espvida, rdpc, gini, pop
      ) %>% 
      reactable(
        striped = TRUE,
        compact = TRUE,
        highlight = TRUE,
        selection = "multiple",
        columns = list(
          
          muni_id = colDef("ID"),
          muni_nm = colDef(
            "Município", 
            minWidth = 200, cell = function(value, index) {
              
              url <- sprintf("https://wikipedia.org/wiki/%s", value)
              htmltools::tags$a(href = url, target = "_blank", as.character(value))
              
            }
          ),
          uf_sigla = colDef("UF"),
          regiao_nm = colDef("Região"),
          idhm = colDef("IDH-M", format = colFormat(digits = 3)),
          espvida = colDef("Exp. Vida"),
          rdpc = colDef("Renda", format = colFormat(
            currency = "BRL"
          )),
          gini = colDef("Gini", format = colFormat(digits = 2)),
          pop = colDef("População", format = colFormat(
            digits = 0, separators = TRUE, locales = "pt-BR"
          ))
          
        )
      )
    
  })
  
  output$baixar <- downloadHandler(
    filename = function() {
      "arquivo.csv"
    },
    content = function(file) {
      # openxlsx::
      readr::write_csv(dados(), file)
      # readr::write_csv(dados(), paste(file, "2"))
    }
  )
  
}

shinyApp(ui, server)