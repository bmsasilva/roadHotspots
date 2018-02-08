#' Creates a valid dsn and layer name from a .shp filepath
#' @export
#' @title Creates a valid dsn and layer name from a .shp filepath
#' @name import_shp
#' @param path The full path of a .shp file
#' @return List with two elements: dsn and layer name
#' @author Bruno Silva
#' @examples
#' import_shp("home/user/data/shapefile.shp")
import_shp <- function(path){
  aux <- strsplit(as.character(path), "\\.")[[1]][1]

  dsn <- strsplit(aux, "/|[\\]")[[1]]
  dsn <- paste(dsn[-c(length(dsn))], collapse = "/")

  layer <- strsplit(aux, "/|[\\]")[[1]]
  layer <- layer[length(layer)]

  list(dsn = dsn, layer = layer)
}
