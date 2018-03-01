#' run_app
#' @export
#' @title Interactive visualization of hotspots
#' @description Shiny app to visualize road hotspots using both malo method and a gaussian density kernel
#' @name run_app
#' @return Nothing
#' @author Bruno Silva
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "roadHotspots")
  if (app_dir == "") {
    stop("Could not find example directory.
         Try re-installing `roadHotspots`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
