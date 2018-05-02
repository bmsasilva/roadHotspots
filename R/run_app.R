#' The app provides a GUI for the functions provided in this package
#' @export
#' @title Shiny app to visualize road hotspots
#' @description Shiny app to visualize road hotspots using Malo's method 
#' or a gaussian kernel density estimation
#' @return Nothing
#' @author Bruno Silva
#' @importFrom magrittr "%>%"
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "roadHotspots")
  if (app_dir == "") {
    stop("Could not find example directory.
         Try re-installing `roadHotspots`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
