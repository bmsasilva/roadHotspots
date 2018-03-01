#' road_kernel
#' @title Clips a polygon to a buffer
#' @description Clips a density kernel to a buffer around linear features
#' @param kernel_shape Density kernel shapefile
#' @param road_shape Roads shapefile
#' @param buf_width Buffer width in maps units
#' @usage road_clip(kernel_shape, road_shape, buf_width)
#' @return SpatialPolygonsDataFrame
#' @author Bruno Silva
#' @keywords internal
road_clip <- function(kernel_shape, road_shape, buf_width){
  buf_roads <- rgeos::gBuffer(road_shape, width = buf_width)
  new_kernel <- rgeos::gIntersection(kernel_shape, buf_roads, byid = TRUE)
  row.names(new_kernel) <- gsub(" buffer", "", row.names(new_kernel))
  keep <- row.names(new_kernel)
  new_kernel <- sp::spChFIDs(new_kernel, keep)
  new_kernel_data <- as.data.frame(kernel_shape@data[keep, ])
  new_kernel <- sp::SpatialPolygonsDataFrame(new_kernel, new_kernel_data)
  new_kernel
}
