library(testthat)
library(roadHotspots)

context("Unix - Convert shapefile fullpath to file name and folder")

unix <- import_shp("home/user/file.shp")

 test_that("import_shp returns a list of 2", {
   expect_output(str(unix), "List of 2")
 })
 
 test_that("import_shp returns two character elements", {
   expect_is(class(unix$dsn), "character")
   expect_is(class(unix$layer), "character")
 })
 
 test_that("import_shp returns two elements of length=1", {
   expect_equal(length(unix$dsn), 1)
   expect_equal(length(unix$layer), 1)
 })
 
 test_that("import_shp returns the correct strings", {
   expect_equal(print(unix$dsn), "home/user")
   expect_equal(print(unix$layer), "file")
 })
