#' lines2df
#' @name Lines2df
#' @description This function extracts the coordinates of the start and end points of each segment of a Spatial Line and returns a dataframe.
#' @param spatial_line An object class SpatialLinesDataFrame from the package sp.
#' @usage lines2df(spatial_line)
#' @examples library("sp","sptools")
#' c1 = cbind(c(0,2), c(0,2))
#' l1 = Line(c1)
#' sl = list(Lines(list(l1), ID = 1))
#' lines2df(SpatialLines(sl))
#' @author Duccio Aiazzi
lines2df = function(spatial_line) {
  df = data.frame(id = character(),
                  mline_id = character(),
                  segment_id = character(),
                  fx = numeric(),
                  fy = numeric(),
                  tx = numeric(),
                  ty = numeric(), stringsAsFactors = FALSE)
  for (i in 1:length(spatial_line)) {
    coords = spatial_line@lines[[i]]@Lines[[1]]@coords # For each line takes the coords of the vertex
    row_nums = 1:(nrow(coords) - 1)
    mline_id = formatC(i, width = 9, flag = '0') # Creates id for the line
    segment_id = formatC(row_nums, width = 3, flag = '0') # Creates id for each single segment belonging to the line
    id = paste0(mline_id, '_', segment_id) # Creates a composite id
    for (j in row_nums) { # For each segment stores ids and coordinates
      df[nrow(df)+1,] = c(id[j], mline_id, segment_id[j],
                          coords[j, 1], coords[j, 2], coords[j + 1, 1], coords[j +1, 2])
    }
  }
  row.names(df) = NULL
  df$fx = as.numeric(df$fx)
  df$fy = as.numeric(df$fy)
  df$tx = as.numeric(df$tx)
  df$ty = as.numeric(df$ty)
  return(df)
}
