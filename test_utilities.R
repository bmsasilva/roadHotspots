library(leaflet)
library(shiny)
library(shinyFiles)
library(raster)
library(rgdal)
library(rgeos)
library(maptools)
library(magrittr)
library(MASS)
library(sp)

lintr::lint_package()

devtools::test()

roads_path <- "/home/bruno/Projectos/R_packages/development/roadHotspots/inst/extdata/roads.shp"
count_path <- "/home/bruno/Projectos/R_packages/development/roadHotspots/inst/extdata/count.csv"
