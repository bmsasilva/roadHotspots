#' split_lines
#' @name split_lines
#' @title Split lines into same length segments
#' @description This function splits each line of an "sp" object of class SpatialLines into segments of a given length.
#' @param spatial_line An "sp" object of class SpatialLines or SpatialLinesDataFrame.
#' @param split_length The length of the segments to split the lines into, in units of the SpatialLines. Default 500.
#' @usage split_lines(spatial_line, split_length = 500)
#' @return SpatialLinesDataFrame
#' @author Duccio Aiazzi
#' @references http://math.stackexchange.com/questions/175896/finding-a-point-along-a-line-a-certain-distance-away-from-another-point?newreg=468f66d7274f449b8ecf3fa4e63f41fe
#' @references http://tutorial.math.lamar.edu/Classes/CalcII/Vectors_Basics.aspx
#' @keywords internal
split_lines <- function(spatial_line,
                      split_length = 500) {
   linedf <- lines2df(spatial_line)
  df <- data.frame(
    id = character(),
    fx = numeric(),
    fy = numeric(),
    tx = numeric(),
    ty = numeric(),
    stringsAsFactors = FALSE
  )

    for (i in 1:nrow(linedf)) {
    v_seg <- linedf[i, ]
    seg_length <- sqrt( (v_seg$fx - v_seg$tx) ^ 2 +
                        (v_seg$fy - v_seg$ty) ^ 2)
    if (seg_length <= split_length) {
      df[nrow(df) + 1, ] <- c(paste0(v_seg$id, "_", "0000"),
                            v_seg$fx,
                            v_seg$fy,
                            v_seg$tx,
                            v_seg$ty)
      next()
    }

    v <- c(v_seg$tx  -  v_seg$fx,
          v_seg$ty  -  v_seg$fy)
    u <- c(v[1]  /  sqrt(v[1]  ^  2 + v[2]  ^  2), 
           v[2]  /  sqrt(v[1]  ^  2 + v[2]  ^ 2))
    num_seg <- floor(seg_length  /  split_length)
    seg_left <- seg_length - (num_seg  *  split_length)

    for (i in 0:(num_seg  -  1)) {
      df[nrow(df)  +  1, ] <- c(
        paste0(v_seg$id, "_", formatC(i, width = 4, flag = "0")),
        v_seg$fx + u[1]  *  split_length  *  i,
        v_seg$fy + u[2]  *  split_length  *  i,
        v_seg$fx + u[1]  *  split_length  *  (i  +  1),
        v_seg$fy + u[2]  *  split_length  *  (i  +  1)
      )
    }
    df[nrow(df) + 1, ] <- c(
      paste0(v_seg$id, "_", formatC(
        num_seg, width = 4, flag = "0"
      )),
      v_seg$fx + u[1] * split_length * num_seg,
      v_seg$fy + u[2] * split_length * num_seg,
      v_seg$tx,
      v_seg$ty
    )
   }

  df$fx <- as.numeric(df$fx)
  df$fy <- as.numeric(df$fy)
  df$tx <- as.numeric(df$tx)
  df$ty <- as.numeric(df$ty)

  sl <- df2lines(df)
  sl <- sp::SpatialLinesDataFrame(sl, df, match.ID = FALSE)
  return(sl)
}
