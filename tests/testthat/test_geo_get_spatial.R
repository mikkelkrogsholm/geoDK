library(geoDK)
library(testthat)
library(stringr)

context("Testing that lut data is available")
out <- geoDK:::lut

test_that("The lut dimension are correct", {
  expect_true(class(out) == "data.frame")
  expect_true(ncol(out) > 0)
  expect_true(nrow(out) > 0)
})

context("Testing that the geo_get_spatial() works")
out <- geo_get_spatial("Danish zip codes")

test_that("The output is correct", {
  expect_true(class(out) == "SpatialPolygonsDataFrame")
  expect_true(length(out) > 0)

  expect_true(class(out@data) == "data.frame")
  expect_true(ncol(out@data) > 0)
  expect_true(nrow(out@data) > 0)

  expect_true(class(out@polygons) == "list")
  expect_true(length(out@polygons) > 0)

  expect_true(class(out@bbox) == "matrix")
  expect_true(ncol(out@bbox) == 2)
  expect_true(nrow(out@bbox) == 2)
})

context("Testing that the inner workings of geo_get_spatial() works")

my_temp <- tempfile()
spatial <- "Danish zip codes"
href <- geoDK:::lut %>% dplyr::filter(desc == spatial) %>% dplyr::pull(href)
download.file(href, destfile = my_temp)
poly <- readRDS(my_temp)

test_that("Temp object was created", {
  expect_true(exists("my_temp"))
})

test_that("href file was created", {
  expect_true(exists("href"))
  expect_true(str_detect(href, "https://files.osf.io/v1/resources/"))
})

test_that("file was downloaded", {
  expect_true(object.size(poly) > 3843000)
})

