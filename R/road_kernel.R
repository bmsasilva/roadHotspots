#' Observations are snaped to closest roads prior to  
#' estimation and the resulting kernel is clipped to the road. The kernel 
#' density estimation is rescaled to [0, 1] and recoded in 
#' three categories: 1 = 0.25 to 0.50, 2 = 0.50 to 0.75,
#' 3 = 0.75 to 1
#' @export
#' @title Kernel density estimation on roads
#' @description Kernel density estimation on roads using the function \code{\link[MASS]{kde2d}}
#' from package MASS.   
#' @param count_path Path for the .csv file with the location of the observations. 
#' The file must have three headed columns (ID, x coordinate and y coordinate) 
#' with one observation per row. The coordinates must have the same projection as 
#' the roads shapefile. The header names are indiferent but 
#' the columns position must be as described.
#' @param roads_path Path for the .shp file with the roads
#' @param bandw Vector of bandwidths for x and y directions. 
#' A scalar value will be taken to apply to both directions.
#' @param group String used to subset species/groups from 
#' the observations dataframe. Can be a single string or multiple strings. 
#' For multiple strings use: c("spe1", "spe2"). By default all observations
#' are used.
#' @usage road_kernel (count_path, roads_path, bandw = 500, group = "all")
#' @return A SpatialPolygonsDataFrame object with the kernel 
#' density estimation
#' @examples roads_path <- system.file("extdata/roads.shp", package = "roadHotspots")
#' count_path <- system.file("extdata/count.csv", package = "roadHotspots")
#' output <- road_kernel(count_path, roads_path) 
#' @references Venables, W. N. and Ripley, B. D. (2002) Modern Applied 
#' Statistics with S. Fourth edition. Springer.
#' @author Bruno Silva
road_kernel <- function(count_path, roads_path, bandw = 500, group = "all") {
  shp <- import_shp(roads_path)
  csv <- as.character(count_path)
  samples <- utils::read.csv(csv, header = TRUE)
  samples <- select_group(samples, group)

  lines <- rgdal::readOGR(dsn = shp$dsn, layer = shp$layer)
  proj <- raster::projection(lines)

  spoints <- sp::SpatialPoints(cbind(samples[, 2], samples[, 3]))
  raster::projection(spoints) <- sp::CRS(proj)

  spoints <- maptools::snapPointsToLines(spoints, lines,
                                         maxDist = NA,
                                         withAttrs = FALSE, idField = NA)

  dens <- MASS::kde2d(sp::coordinates(spoints)[, 1],
                      sp::coordinates(spoints)[, 2],
                      lims = c(raster::xmin(spoints), raster::xmax(spoints),
                               raster::ymin(spoints), raster::ymax(spoints)),
                      n = 250,
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

  bias <- road_clip(bias, lines, buf_width = 50)

  bias
}
