library(testthat)
library(roadHotspots)

context("Test spatial data manipulation")

roads_path <- system.file("extdata/roads.shp", package = "roadHotspots")
count_path <- system.file("extdata/count.csv", package = "roadHotspots")
pj <- raster::projection(rgdal::readOGR(dsn = system.file("extdata", package = "roadHotspots"), layer = "roads"))

output_kernel <- road_kernel(count_path, roads_path)
output_malo <- road_malo(count_path, roads_path)

 test_that("road_kernel exports a SpatialPolygonsDataFrame", {
   expect_output(str(output_kernel), "SpatialPolygonsDataFrame")
 })
 
 test_that("the projection of the kernel is the same as the roads projection", {
   expect_equal(raster::projection(output_kernel), pj)
 })

 test_that("road_malo exports a SpatialLinesDataFrame", {
   expect_output(str(output_malo), "SpatialLinesDataFrame")
 })
 
 test_that("the projection of the road segments is the same as the original roads projection", {
   expect_equal(raster::projection(output_malo), pj)
 })