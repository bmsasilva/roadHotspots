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
      
      shiny::fluidRow(
        shiny::column(12, "Choose species/groups"
        )),
      shiny::fluidRow(
        shiny::column(12,
                      shiny::selectInput(
                        "ID",
                        NULL,
                        choices = c("all" = "all"),
                        selected =  "all",
                        multiple = FALSE
                      ))),
      
      shinydashboard::sidebarMenu(
        shinydashboard::menuItem("Map",
                                 tabName = "Map",
                                 icon = icon("th"))
      )
    ),
    shinydashboard::dashboardBody(
      shinydashboard::tabItems(
        shinydashboard::tabItem(tabName = "Map",
                                shiny::fluidRow(
                                  shiny::column(3,
                                                shiny::selectInput(
                                                  "bandw",
                                                  NULL,
                                                  choices = c(
                                                    "Bandwidth 500m" = 500,
                                                    "Bandwidth 1000m" = 1000),
                                                  selected =  500
                                                )),
                                  shiny::column(3,
                                                shiny::selectInput(
                                                  "thresh",
                                                  NULL,
                                                  choices = c("90%" = 0.9,
                                                              "95%" = 0.95,
                                                              "99%" = 0.99),
                                                  selected =  0.95
                                                )),
                                  shiny::column(3,
                                                shiny::selectInput(
                                                  "map_type",
                                                  NULL,
                                                  choices = c(
                                                    "Map" = "OpenStreetMap.BlackAndWhite",
                                                    "Aerial" = "Esri.WorldImagery",
                                                    "Topography" = "Esri.WorldTopoMap"),
                                                  selected =  "Esri.WorldTopoMap"
                                                ))
                                ),
                                shiny::fluidRow(
                                  leaflet::leafletOutput("mymap", height = 600))
        )
      )
    )
  )
)