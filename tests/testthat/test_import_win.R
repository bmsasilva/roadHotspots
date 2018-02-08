library(testthat)
library(roadHotspots)

context("Windows - Convert shapefile fullpath to file name and folder")

win <- import_shp("c:\\home\\user\\file.shp")

test_that("import_shp returns a list of 2", {
  expect_output(str(win), "List of 2")
})

test_that("import_shp returns two character elements", {
  expect_is(class(win$dsn), "character")
  expect_is(class(win$layer), "character")
})

test_that("import_shp returns two elements of length=1", {
  expect_equal(length(win$dsn), 1)
  expect_equal(length(win$layer), 1)
})