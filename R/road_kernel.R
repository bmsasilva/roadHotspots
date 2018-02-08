#' Title
#'
#' @param count_path 
#' @param roads_path 
#' @param bandw 
#'
#' @return string
#' @export
#'
#' @examples 
#' not run
road_kernel <- function(count_path, roads_path, bandw = 500) {
  shp <- import_shp(roads_path)
  csv <- as.character(count_path)
  samples <- utils::read.csv(csv, header = TRUE)

  lines <- rgdal::readOGR(dsn = shp$dsn, layer = shp$layer)
  proj <- raster::projection(lines)

  spoints <- sp::SpatialPoints(cbind(samples[, 2], samples[, 3]))
  raster::projection(spoints) <- sp::CRS(proj)

  spoints <- maptools::snapPointsToLines(spoints, lines,
                                         maxDist = NA,
                                         withAttrs = FALSE, idField = NA)

  dens <- MASS::kde2d(sp::coordinates(spoints)[, 1], sp::coordinates(spoints)[, 2],
                      lims = c(raster::xmin(spoints), raster::xmax(spoints),
                               raster::ymin(spoints), raster::ymax(spoints)),
                      n = 500,
                      h = as.numeric(bandw))

  bias <- raster::raster(dens)
  raster::projection(bias) <- sp::CRS(proj)

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
  bias
}
