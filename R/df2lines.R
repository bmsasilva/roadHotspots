#' df2lines
#' @description  This function converts a dataframe of IDs and coordinates into a SpatialLines object of the package "sp".
#' @name df2lines
#' @param linedf a data frame with the following columns:
#'  id = generic ids of the lines,
#'  fx = coordinates x of the first point of the line,
#'  fy = coordinates y of the first point of the line,
#'  tx = coordinates x of the second point of the line,
#'  tx = coordinates y of the second point of the line.
#' @author Duccio Aiazzi
df2lines = function(linedf){
  sl = list()
  for(i in 1:nrow(linedf)){
    c1 = cbind(rbind(linedf$fx[i], linedf$tx[i]), rbind(linedf$fy[i], linedf$ty[i]))
    l1 = Line(c1)
    sl[[i]] = Lines(list(l1), ID = linedf$id[i])
  }
  SL = SpatialLines(sl)
  return(SL)
}
