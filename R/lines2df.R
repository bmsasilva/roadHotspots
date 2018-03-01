#' lines2df
#' @title SpatialLines to dataframe
#' @description This function extracts the coordinates of the start and end points of each segment of a Spatial Line and returns a dataframe.
#' @param spatial_line An object class SpatialLinesDataFrame from the package sp.
#' @usage lines2df(spatial_line)
#' @return SpatialLinesDataFrame
#' @author Duccio Aiazzi
#' @keywords internal
lines2df <- function(spatial_line) {
  df <- data.frame(id = character(),
                  mline_id = character(),
                  segment_id = character(),
                  fx = numeric(),
                  fy = numeric(),
                  tx = numeric(),
                  ty = numeric(), stringsAsFactors = FALSE)
  for (i in 1:length(spatial_line)) {
    coords <- spatial_line@lines[[i]]@Lines[[1]]@coords
    row_nums <- 1:(nrow(coords) - 1)
    mline_id <- formatC(i, width = 9, flag = "0")
    segment_id <- formatC(row_nums, width = 3, flag = "0")
    id <- paste0(mline_id, "_", segment_id)
    for (j in row_nums) {
      df[nrow(df) + 1, ] <- c(id[j], mline_id, segment_id[j],
                          coords[j, 1], coords[j, 2],
                          coords[j + 1, 1], coords[j + 1, 2])
    }
  }
  row.names(df) <- NULL
  df$fx <- as.numeric(df$fx)
  df$fy <- as.numeric(df$fy)
  df$tx <- as.numeric(df$tx)
  df$ty <- as.numeric(df$ty)
  return(df)
}
