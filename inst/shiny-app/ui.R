shinyUI(fluidPage(
  theme = "bootstrap.css",
  fluidRow(
    column(
      4,
      shinyFilesButton("file_count",
                       "Choose count file",
                       "Choose count file", FALSE)
    ),
    column(
      4,
      downloadButton("Kernel Shapefile", "Download Shapefile")
    ),
    br(),
    br(),
    fluidRow(
      column(
        4,
        shinyFilesButton("file_roads",
                         "Choose roads file",
                         "Choose roads file", FALSE)
      ),
      column(
        4,
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
