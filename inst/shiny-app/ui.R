shiny::shinyUI(
  shinydashboard::dashboardPage(
    # skin = "black",
    shinydashboard::dashboardHeader(title = "Road Hotspots"), #final header
    shinydashboard::dashboardSidebar(
      shiny::fluidRow(
        shiny::column(12, "Choose files with roads and events"
        )),
      shiny::fluidRow(
        shiny::column(6,
                      shinyFiles::shinyFilesButton("file_roads",
                                                   "Roads .shp",
                                                   "Roads .shp", FALSE
                      )),
        shiny::column(6,
                      shinyFiles::shinyFilesButton("file_count",
                                                   "Events .csv",
                                                   "Events .csv", FALSE
                      ))),
      shiny::br(),
      shiny::br(),
      # shiny::selectInput(
      #   "bandw",
      #   NULL,
      #   choices = c("Bandwidth 500m" = 500,
      #               "Bandwidth 1000m" = 1000),
      #   selected =  500
      # ),

      shinydashboard::sidebarMenu(
        shinydashboard::menuItem("Total", 
                                 tabName = "Total",
                                 icon = icon("th")) #,
        #  menuItem("Espécies", tabName = "Especies", icon = icon("th")) #,
        # menuItem("Mapa", tabName = "Mapa", icon = icon("th"))
      )
    ), #final sidebar
    shinydashboard::dashboardBody(
      # Boxes need to be put in a row (or column)
      # Ver mais icons em: http://fontawesome.io/icons/
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "Total",
                                shiny::fluidRow(
                                  shiny::column(3,
                                                shiny::selectInput(
                                                  "bandw",
                                                  NULL,
                                                  choices = c("Bandwidth 500m" = 500,
                                                              "Bandwidth 1000m" = 1000),
                                                  selected =  500
                                                )),
                                  shiny::column(3,
                                                shiny::selectInput(
                                                  "map_type",
                                                  NULL,
                                                  choices = c("Map" = "OpenStreetMap.BlackAndWhite",
                                                              "Aerial" = "Esri.WorldImagery",
                                                              "Topography" = "Esri.WorldTopoMap"),
                                                  selected =  "OpenStreetMap.BlackAndWhite"
                                                ))
                                ), # final Fluidrow
                                shiny::fluidRow(leaflet::leafletOutput("mymap", height = 600))
                                #fluidRow(dataTableOutput("mortPlot")) # Para despistar erros no mortPlot
        ),#final tabItem Total
        
        shinydashboard::tabItem(tabName = "Especies",
                                #  h2("Tabela"),
                                shiny::fluidRow(
                                  shinydashboard::box(
                                    width = 6, #Controla o tamanho da caixa da tabela
                                    shiny::div(shiny::dataTableOutput('especiesTable'), 
                                               style = "font-size: 12px;")
                                    #                 ),
                                    #               box(
                                    #                 plotOutput("wordcloud")
                                  )
                                )
        )
        #,#final tabItem Especies      
        #tabItem(tabName = "Mapa",
        #       fluidRow(plotOutput("mapa", height="700px"))
        # )#final tabItem Mapa
        
        
        
        
      ) # final tabItens
      
      
    ) # final body
  )
)