#' select_group
#' @title Select rows from dataset 
#' @description Select rows from dataset by values of 
#' first column
#' @param data The dataframe to subset
#' @param group String to be matched in first column. 
#' Can be a single string or multiple strings. For multiple
#' strings use: c("string1", "string2"). By default the function
#' returns exactly the original dataframe.
#' @usage select_group(data, group = "all")
#' @return A dataframe with the selected rows
#' @author Bruno Silva
#' @keywords internal
select_group <- function(data, group = "all"){
    if(length(group) > 1 || group != "all"){
    return(data <- data[which(data[[1]] %in% c(group)), ])
}
  data
}