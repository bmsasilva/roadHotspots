shiny::shinyServer(function(input, output, session) {

  shinyFiles::shinyFileChoose(
    input, "file_count", session = session,
    roots = shinyFiles::getVolumes(), filetypes = c("csv")
  )

  shinyFiles::shinyFileChoose(
    input, "file_roads", session = session,
    roots = shinyFiles::getVolumes(), filetypes = c("shp")
  )

  count_path <- shiny::reactive({
    shinyFiles::parseFilePaths(shinyFiles::getVolumes(), input$file_count)
  })

  roads_path <- shiny::reactive({
    shinyFiles::parseFilePaths(shinyFiles::getVolumes(), input$file_roads)
    })

  shape_dens <- shiny::reactive({
    road_kernel(count_path()$datapath, roads_path()$datapath, 500)
  })

  output$download_kernel <- shiny::downloadHandler(

    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("kernel.zip")
    },

    # This function should write data to a file given to it by
    # the argument "file".
    content = function(file) {

      # Write to a file specified by the "file" argument
      rgdal::writeOGR(shape_dens(), ".", "kernel/kernel",
               driver = "ESRI Shapefile", overwrite_layer = TRUE)

      utils::zip(zipfile = file,
          files = c("kernel/kernel.shp",
                  "kernel/kernel.prj",
                  "kernel/kernel.shx",
                  "kernel/kernel.dbf"))
    }
  )

  ordem <- shiny::reactive({
    samples <- utils::read.csv(input$file_count, header = TRUE)

    if (input$group == "TOTAL"){
      out <- c("Todas")
    } else {
      samples <- samples[which(samples$Classe %in% input$group), ]
      out <- c("Todas", as.character(unique(samples$Ordem)))
    }
    out
  })

    output$mymap <- leaflet::renderLeaflet({
    bias <- sp::spTransform(shape_dens(),
                        CRS("+proj=longlat +datum=WGS84 +no_defs"))
    leaflet::leaflet() %>%
      leaflet::addProviderTiles(input$map_type)%>%
     # leaflet::addTiles() %>%
      leaflet::addPolygons(data = bias, group = "layer",
                  color = c("darkgreen", "yellow", "red"),
                  stroke = FALSE, fillOpacity = 0.75)
    })
 })
