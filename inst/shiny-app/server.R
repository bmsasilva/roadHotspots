library("leaflet")
library("shiny")
library("shinyFiles")
library("raster")
library("rgdal")
library("maptools")
################################################################################
shinyServer(function(input, output, session) {

  shinyFiles::shinyFileChoose(
    input, "file_count", session = session,
    roots = getVolumes(), filetypes = c("csv")
  )

  shinyFiles::shinyFileChoose(
    input, "file_roads", session = session,
    roots = getVolumes(), filetypes = c("shp")
  )

  count_path <- shiny::reactive({
    parseFilePaths(getVolumes(), input$file_count)
  })

  roads_path <- shiny::reactive({
    parseFilePaths(getVolumes(), input$file_roads)
    })

  shape_dens <- shiny::reactive({
    shp <- import_shp(roads_path()$datapath)
    csv <- as.character(count_path()$datapath)
    samples <- utils::read.csv(csv, header = TRUE)

    # Importing lines feature
    lines <- rgdal::readOGR(dsn = shp$dsn, layer = shp$layer)
    projection(lines) <- sp::CRS("+init=epsg:32629")

    ## Importing mortality points and converting to spatial points
    spoints <- sp::SpatialPoints(cbind(samples[, 2], samples[, 3]))
    projection(spoints) <- sp::CRS("+init=epsg:32629")

    # Snap points to road segments
    spoints <- maptools::snapPointsToLines(spoints, lines,
                                 maxDist = NA, withAttrs = FALSE, idField = NA)

    # Obtain kernel
    dens <- MASS::kde2d(coordinates(spoints)[, 1], coordinates(spoints)[, 2],
                        lims = c(565000, 620000, 4265000, 4305000),
                        n = c(550, 400),
                        h = as.numeric(input$bandw))

    # Convert to raster
    bias <- raster::raster(dens)
    projection(bias) <- sp::CRS("+init=epsg:32629")

    x <- raster::getValues(bias) / max(raster::getValues(bias))
    bias <- raster::setValues(bias, x)

    x <- ifelse(raster::getValues(bias) < 0.25, NA, raster::getValues(bias))

    x <- ifelse(raster::getValues(bias) < 0.25, NA,
                ifelse(raster::getValues(bias) <= 0.5, 1,
                       ifelse(raster::getValues(bias) > 0.5 &
                                raster::getValues(bias) <= 0.75, 2,
                              3)))

    bias <- raster::setValues(bias, x)

    bias <- raster::rasterToPolygons(bias,
                             fun = NULL, n = 4, na.rm = TRUE,
                             digits = 12, dissolve = TRUE)
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
      leaflet::addTiles() %>%
      leaflet::addPolygons(data = bias, group = "layer",
                  color = c("darkgreen", "yellow", "red"),
                  stroke = FALSE, fillOpacity = 0.75)
    })
 })
