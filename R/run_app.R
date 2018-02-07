#' Shiny app to visualize hotspots
#' @export
#' @title Shiny app to visualize hotspots
#' @name run_app
#' @author Bruno Silva
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "visualHotspots")
  if (app_dir == "") {
    stop("Could not find example directory. Try re-installing `visualHotspots`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}