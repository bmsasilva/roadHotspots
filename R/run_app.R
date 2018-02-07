#' Interactive visualization of hotspots
#' @export
#' @title Interactive visualization of hotspots
#' @name run_app
#' @return Nothing
#' @author Bruno Silva
#' @examples
#' run_app()
run_app <- function() {
  app_dir <- system.file("shiny-app", package = "roadHotspots")
  if (app_dir == "") {
    stop("Could not find example directory.
         Try re-installing `roadHotspots`.", call. = FALSE)
  }
  shiny::runApp(app_dir, display.mode = "normal")
}
