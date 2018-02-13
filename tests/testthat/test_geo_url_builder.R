library(geoDK)
library(testthat)
library(stringr)

context("Testing that geo_url_builder() is working")

# Set login and password ----
login <- 'xxx'
password <- 'yyy'

# Build url
my_url <- geo_url_builder(method = "adresse", vejnavn = "Rentemestervej", postnr = "2400", hits = "50", login = login, password = password)

test_that("The my_url is correct", {
  expect_true(is.character(my_url))
  expect_true(nchar(my_url) == 158)
  expect_true(str_detect(my_url, "https://services.kortforsyningen.dk/"))
  expect_true(my_url == "https://services.kortforsyningen.dk/?method=adresse&vejnavn=Rentemestervej&postnr=2400&hits=50&login=xxx&password=yyy&servicename=RestGeokeys_v2&geometry=true")
})
