library(testthat)
library(geoDK)
library(tidyverse)

context("Testing that make_tidy_poly() is working")

geo_reg <- geo_get_spatial("Danish regions")

df <- make_tidy_poly(geo_reg)

test_that("the outpout of make_tidy_poly() is correct", {
  expect_true(is_tibble(df))
  expect_true(ncol(df) > 0)
  expect_true(nrow(df) > 0)
  expect_true(all(names(geo_reg) %in% names(df)))
})


