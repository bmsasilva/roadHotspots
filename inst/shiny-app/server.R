 shiny::shinyServer(function(input, output, session) {
# 
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
    validate(
      need(roads_path()$datapath != "",
           "Please select a shapefile with roads"),
      need(count_path()$datapath != "",
           "Please select a file with observed events")
      )
    road_kernel(as.character(count_path()$datapath),
                as.character(roads_path()$datapath),
                input$bandw, input$ID)
  })

  shape_malo <- shiny::reactive({
    validate(
      need(roads_path()$datapath != "",
           "Please select a shapefile with roads"),
      need(count_path()$datapath != "",
           "Please select a file with observed events")
    )
    road_malo(as.character(count_path()$datapath),
              as.character(roads_path()$datapath),
              input$thresh, input$ID)
  })

  bound_box <- shiny::reactive({
    aux <- sp::spTransform(shape_dens(),
                            CRS("+proj=longlat +datum=WGS84 +no_defs"))

  })
  
  # Future implementation 
  # output$download_kernel <- shiny::downloadHandler(
  # 
  #   # This function returns a string which tells the client
  #   # browser what name to use when saving the file.
  #   filename = function() {
  #     paste("kernel.zip")
  #   },
  # 
  #   # This function should write data to a file given to it by
  #   # the argument "file".
  #   content = function(file) {
  # 
  #     # Write to a file specified by the "file" argument
  #     rgdal::writeOGR(shape_dens(), ".", "kernel/kernel",
  #              driver = "ESRI Shapefile", overwrite_layer = TRUE)
  # 
  #     utils::zip(zipfile = file,
  #         files = c("kernel/kernel.shp",
  #                 "kernel/kernel.prj",
  #                 "kernel/kernel.shx",
  #                 "kernel/kernel.dbf"))
  #   }
  # )
  
# Future implementation 
#   groups <- shiny::reactive({
#     if(!is.null(input$file_count)){
#   samples <- utils::read.csv(as.character(count_path()$datapath), header = TRUE)
# output <- c("all", unique(as.character(samples[[1]])))
#     } else{
#       output <- "all"
# }
# output
#   })

   
# Future implementation
# observe({
#   updateSelectInput(session, "ID",
#                     choices = groups(),
#                     selected =  "all"
#   )})

    output$mymap <- leaflet::renderLeaflet({
    kernel <- sp::spTransform(shape_dens(),
                        CRS("+proj=longlat +datum=WGS84 +no_defs"))
    malo <- sp::spTransform(shape_malo(),
                              CRS("+proj=longlat +datum=WGS84 +no_defs"))
    leaflet::leaflet() %>%
      leaflet::addProviderTiles(input$map_type) %>%
     # leaflet::addTiles() %>%
      leaflet::addPolygons(data = malo, color = "black",
                           group = "malo", opacity = 1) %>%
      leaflet::addPolygons(data = kernel, group = "kernel",
                           color = c("darkgreen", "yellow", "red"),
                           stroke = FALSE, fillOpacity = 0.75) %>%
      addLayersControl(
                overlayGroups = c("kernel", "malo"),
        options = layersControlOptions(collapsed = FALSE)
      )
    })
 })
