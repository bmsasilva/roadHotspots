#' df2lines
#' @title Dataframe to SpatialLines
#' @description  Converts a dataframe of IDs and coordinates into a SpatialLines object of the package "sp".
#' @param linedf a data frame with the following columns:
#'  id = generic ids of the lines,
#'  fx = coordinates x of the first point of the line,
#'  fy = coordinates y of the first point of the line,
#'  tx = coordinates x of the second point of the line,
#'  tx = coordinates y of the second point of the line.
#' @usage df2lines(linedf)
#' @return SpatialLinesDataFrame
#' @author Duccio Aiazzi
#' @keywords internal
df2lines <- function(linedf){
  sl <- list()
  for (i in 1:nrow(linedf)){
    c1 <- cbind(rbind(linedf$fx[i], linedf$tx[i]),
                rbind(linedf$fy[i], linedf$ty[i]))
    l1 <- sp::Line(c1)
    sl[[i]] <- sp::Lines(list(l1), ID = linedf$id[i])
  }
  SL <- sp::SpatialLines(sl)
  return(SL)
}
