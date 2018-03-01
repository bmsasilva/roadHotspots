library(testthat)
library(roadHotspots)

context("Convert shapefile fullpath to file name and folder")

unix <- import_shp("home/user/file.shp")
win <- import_shp("c:\\home\\user\\file.shp")

 test_that("unix - import_shp returns a list of 2", {
   expect_output(str(unix), "List of 2")
 })
 
 test_that("unix - import_shp returns two character elements", {
   expect_is(class(unix$dsn), "character")
   expect_is(class(unix$layer), "character")
 })
 
 test_that("unix - import_shp returns two elements of length=1", {
   expect_equal(length(unix$dsn), 1)
   expect_equal(length(unix$layer), 1)
 })
 
 test_that("unix - import_shp returns the correct strings", {
   expect_equal(print(unix$dsn), "home/user")
   expect_equal(print(unix$layer), "file")
 })
 
 test_that("win - import_shp returns a list of 2", {
   expect_output(str(win), "List of 2")
 })
 
 test_that("win - import_shp returns two character elements", {
   expect_is(class(win$dsn), "character")
   expect_is(class(win$layer), "character")
 })
 
 test_that("win - import_shp returns two elements of length=1", {
   expect_equal(length(win$dsn), 1)
   expect_equal(length(win$layer), 1)
 })
 
 test_that("win - import_shp returns the correct strings", {
   expect_equal(print(win$dsn), "c:/home/user")
   expect_equal(print(win$layer), "file")
 })
 
