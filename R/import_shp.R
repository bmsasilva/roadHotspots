#' import_shp
#' @title Dsn and layer name from .shp filepath
#' @description Creates a valid dsn and layer name from a .shp filepath
#' @param path The full path of a .shp file
#' @return List with two elements: dsn and layer name
#' @usage import_shp(path)
#' @return List with two character components: dsn and layer
#' @author Bruno Silva
#' @keywords internal
import_shp <- function(path){

  dsn <- strsplit(path, "/|[\\]")[[1]]
  dsn <- paste(dsn[-c(length(dsn))], collapse = "/")

  layer <- strsplit(path, "/|[\\]")[[1]]
  layer <- layer[length(layer)]
  layer <- strsplit(as.character(layer), "\\.")[[1]][1]
  
  list(dsn = dsn, layer = layer)
}
