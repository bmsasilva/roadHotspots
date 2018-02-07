shinyUI(fluidPage(
  theme = "bootstrap.css",
  fluidRow(
    column(
      3,
      shinyFilesButton("file_count",
                       "Choose count file",
                       "Choose count file", FALSE)
    ),
    column(
      3,
      shinyFilesButton("file_roads",
                       "Choose roads file",
                       "Choose roads file", FALSE)
    ),
    br(),
    fluidRow(
      column(
      3,
      downloadButton("Kernel Shapefile", "Download Shapefile")
    ),
    column(
      3,
      selectInput(
        "bandw",
        NULL,
        choices = c("Bandwidth 500m" = 500,
                    "Bandwidth 1000m" = 1000),
        selected =  500
      )
    )),
    leafletOutput("mymap", height = 600)
  )
))
