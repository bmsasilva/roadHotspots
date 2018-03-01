#' The road sections with high observation rates are defined 
#' by detecting clusters of animal locations. The spatial pattern of observations is 
#' compared with that expected in a random situation. Based on the hypothesis
#' that observations for each road section would show a 
#' Poisson distribution (Boots & Getis 1988), the probability of any 
#' road segment having x number of observations is: p(x) = λx/(x!eλ).
#' Hotspots are then defined as those segments whose probability of observations
#' is lower than the threshold probability. For instance a 0.95 threshold value 
#' means that segments whose number of observations have less than 5% probability
#' of ocurrence (1-0.95 = 0.05), given the observations distribution, are considered hotspots
#' @export
#' @title Identify hotspots on roads
#' @description Identify hotspots on roads using an adaptation of Malo et al. (2004) method.
#' @param count_path Path for the .csv file with the location of the observations
#' @param roads_path Path for the .shp file with the roads
#' @param thresh Hotspot probability threshold. Can assume values in the range [0, 1]
#' @param split_length Length of the road segments in map units
#' @usage road_malo (count_path, roads_path, thresh = 0.95, split_length = 500)
#' @return SpatialLinesDataFrame object with the road segments identified as hotspots
#' @examples roads_path <- system.file("extdata/roads.shp", package = "roadHotspots")
#' count_path <- system.file("extdata/count.csv", package = "roadHotspots")
#' output <- road_malo(count_path, roads_path) 
#' @references Malo, J.E., Suarez, F., Diez, A. (2004) Can we mitigate 
#' animal-vehicle accidents using predictive models? 
#' J. Appl. Ecol. 41, 701-710 (doi: 10.1111/j.0021-8901.2004.00929.x)
#' @author Bruno Silva
road_malo <- function(count_path, roads_path,
                      thresh = 0.95, split_length = 500){
    shp <- import_shp(roads_path)
    csv <- as.character(count_path)
    samples <- utils::read.csv(csv, header = TRUE)
  
    lines <- rgdal::readOGR(dsn = shp$dsn, layer = shp$layer)
    proj <- raster::projection(lines)
  
    lines <- split_lines(lines, split_length = split_length)
    raster::projection(lines) <- sp::CRS(proj)
  
    spoints <- sp::SpatialPoints(cbind(samples[, 2], samples[, 3]))
    raster::projection(spoints) <- sp::CRS(proj)
  
    snap <- maptools::snapPointsToLines(spoints, lines,
                                           maxDist = NA,
                                           withAttrs = FALSE, idField = NA)

    hot <- data.frame(line = snap$nearest_line_id)
    hot <- data.frame(table(hot$line))
    hot$Var1 <- as.character(hot$Var1)
    hot <- hot[order(hot$Var1), ]
  
    ## Eliminar os segmentos nao ehotistentes no dataframe da shape
    # Isto altera as contas. Optar por atribuir zero
    keep <- which(row.names(lines) %in% c(hot$Var1))
    lines@data <- lines@data[keep, ]
    lines@lines <- lines@lines[keep]
  
    hot$prob <- stats::ppois(hot$Freq, lambda = mean(hot$Freq))
    hot$hotspot <- ifelse(hot$prob > thresh, 1, 0)
  
    lines@data$hotspot <- hot$hotspot
    lines@data$hotspot.prob <- hot$prob

    keep <- which(hot$hotspot == 1)
    lines@data <- lines@data[keep, ]
    lines@lines <- lines@lines[keep]

    return(lines)
}