library(testthat)
library(roadHotspots)

context("Clip density kernel to roads")

aux <- road_clip("/home/ubc/DADOS/BRUNO/MyPackges/roadHotspots/inst/extdata/count.csv",
                   "/home/ubc/DADOS/BRUNO/MyPackges/roadHotspots/inst/extdata/roads.shp")

 test_that("road_clip exports a SpatialPolygonsDataFrame", {
   expect_output(str(aux), "SpatialPolygonsDataFrame")
 })
 