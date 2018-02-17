library(testthat)
library(roadHotspots)

context("Compute density kernel")

aux <- road_kernel("/home/ubc/DADOS/BRUNO/MyPackges/roadHotspots/inst/extdata/count.csv",
                   "/home/ubc/DADOS/BRUNO/MyPackges/roadHotspots/inst/extdata/roads.shp")

pj <- raster::projection(rgdal::readOGR(dsn = "/home/ubc/DADOS/BRUNO/MyPackges/roadHotspots/inst/extdata/", layer = "roads"))

 test_that("road_kernel exports a SpatialPolygonsDataFrame", {
   expect_output(str(aux), "SpatialPolygonsDataFrame")
 })
 
 test_that("the projection of the kernel is the same as the roads projection", {
   expect_equal(raster::projection(aux), pj)
 })
 
 # test_that("import_shp returns two character elements", {
 #   expect_is(class(unix$dsn), "character")
 #   expect_is(class(unix$layer), "character")
 # })
 # 
 # test_that("import_shp returns two elements of length=1", {
 #   expect_equal(length(unix$dsn), 1)
 #   expect_equal(length(unix$layer), 1)
 # })
