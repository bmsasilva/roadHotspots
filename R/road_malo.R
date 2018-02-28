#' Title
#' @export
#' @title Road hotspots using Malo method
#' @name road_malo
#' @param count_path Path for the .csv file with the location of the observations
#' @param roads_path Path for the .shp file with the roads
#' @param thresh Probability threshold hotspot
#' @return a SpatialLinesDataFrame object with the hotspot road segments
#' @author Bruno Silva
road_malo <- function(count_path, roads_path, thresh = 0.95){
    shp <- import_shp(roads_path)
    csv <- as.character(count_path)
    samples <- utils::read.csv(csv, header = TRUE)
    
    lines <- rgdal::readOGR(dsn = shp$dsn, layer = shp$layer)
    proj <- raster::projection(lines)
    
    lines <- split_lines(lines, split_length = 500)
    raster::projection(lines) <- sp::CRS(proj)
    
    spoints <- sp::SpatialPoints(cbind(samples[, 2], samples[, 3]))
    raster::projection(spoints) <- sp::CRS(proj)
    
    snap <- maptools::snapPointsToLines(spoints, lines,
                                           maxDist = NA,
                                           withAttrs = FALSE, idField = NA)

    # Obtain data.frame with road segment and count of mortality by segment
    hot <- data.frame(line = snap$nearest_line_id)
    hot <- data.frame(table(hot$line))
    hot$Var1 <- as.character(hot$Var1)
    hot <- hot[order(hot$Var1), ]
    
    ## Eliminar os segmentos nao ehotistentes no dataframe da shape
    # Isto altera as contas. Optar por atribuir zero
    keep <- which(row.names(lines) %in% c(hot$Var1))
    lines@data <- lines@data[keep,]
    lines@lines<- lines@lines[keep]
    
    ## Calcular as probabilidades associadas a cada segmento com base em ppois
    hot$prob <- ppois(hot$Freq, lambda = mean(hot$Freq))
    hot$hotspot <- ifelse(hot$prob > thresh, 1, 0)
    
    ## Adicionar coluna com os hotspots identificados a shapefile
    ## e coluna com as respectivas probabilidades
    lines@data$hotspot <- hot$hotspot
    lines@data$hotspot.prob <- hot$prob

    ## Eliminar os não-hotspots da shape
    keep <- which(hot$hotspot == 1)
    lines@data <- lines@data[keep,]
    lines@lines<- lines@lines[keep]

    return(lines)
}