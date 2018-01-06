# onload ----
.onLoad <- function(libname, pkgname){
  message("Uses data from Geodatestyrelsens REST API\nTerms apply. Read more at: https://kortforsyningen.dk/indhold/vilkaar-og-betingelser")
}

# geo_url_builder ----
#' Helper function to build the urls
#'
#' The function builds the url needed in the geo_getter() function. It is not
#' exported.
#'
#' @param ... insert the relevant parameters for the call.
#'
#' @return a url
#'
#' @examples
#' # Set login and password ----
#' login <- 'xxx'
#' password <- 'yyy'
#'
#' # Build url
#' geo_url_builder(method = "adresse", vejnavn = "Rentemestervej", postnr = "2400", hits = "50", login = login, password = password)
#'
geo_url_builder <- function(...){
  # Build ulr based on input
  query <- list(...)

  query$servicename = "RestGeokeys_v2"
  query$geometry = "true"

  url_params <- list(
    scheme =  "https",
    hostname = "services.kortforsyningen.dk",
    query = query
  )

  class(url_params) <- "url"

  url <- httr::build_url(url_params)

  url
}

# geo_getter ----
#' Get data from Geodatestyrelsens REST API
#'
#' You need to create a user to use the service. You can set up your user here:
#' https://kortforsyningen.dk/indhold/min-side.
#'
#' You can see all the different ways of calling the service at this url
#' (https://kortforsyningen.dk/indhold/geonoegler-rest), ie what the different
#' parameters mean. You can also see the examples below to see a lot of working
#' examples.
#'
#' @param ... insert the relevant parameters for your call.
#'
#' @return Spatial data, lists and more
#' @export
#'
#' @examples
#' \dontrun{
#'  library(geoDK)
#'
#'  # Visit https://kortforsyningen.dk/indhold/geonoegler-rest to see more information.
#'  # NOTE: The site is in danish.
#'
#'  # Set login and password ----
#'  login <- 'xxx'
#'  password <- 'yyy'
#'
#'  # Calls with the "adresse" method ----
#'  geo_getter(method = "adresse", vejnavn = "Rentemestervej", postnr = "2400", hits = "50", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Lærkevej", postnr = "2400;4700", count = "true", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Lærkevej", postnr = "2400;4700", hits = "10", offset = "10", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Lærkevej", husnr = "1", postnr = "2400;4700", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Jernbanegade", husnr = "1", komkode = "0101;0370", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Skindergade", husnr = "10", postdist = "København K", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "ravnsøvej", geoenv = "550000,6221000;555000,6226000", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "dyremosevej", geoenv = "11.3930,55.6550;11.3970,55.6650", georef = "EPSG:4326", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Vest*", husnr = "2", postnr = "4000", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Ny*", postdist = "København K", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejnavn = "Lærkevej", husnr = "1", geop = "550000,6220000", login = login, password = password)
#'
#'  geo_getter(method = "adresse", vejkode = "0792", komkode = "0370", login = login, password = password)
#'
#'  geo_getter(method = "adresse", geop = "550000,6221000", georad = "100", login = login, password = password)
#'
#'  geo_getter(method = "adresse", geop = "11.39683742,55.66003658", georef = "EPSG:4326", georad = "250", login = login, password = password)
#'
#'  geo_getter(method = "adresse", geoenv = "550000,6221000;550400,6221400", login = login, password = password)
#'
#'  geo_getter(method = "adresse", geoenv = "11.3930,55.6550;11.3970,55.6650", georef = "EPSG:4326", login = login, password = password)
#'
#'  # Calls with the "padresse" method ----
#'  geo_getter(method = "padresse", vejnavn = "Karrebækvej", husnr = "1A", postnr = "4700", count = "true", login = login, password = password)
#'
#'  geo_getter(method = "padresse", vejnavn = "Karrebækvej", husnr = "1A", postnr = "4700", login = login, password = password)
#'
#'  geo_getter(method = "padresse", vejkode = "0792", husnr = "1A", komkode = "0370", login = login, password = password)
#'
#'  # Calls with the "nadresse" method ----
#'  geo_getter(method = "nadresse", geop = "550000,6221000", hits = "10", login = login, password = password)
#'
#'  geo_getter(method = "nadresse", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  # Calls with the "vej" method ----
#'  geo_getter(method = "vej", vejnavn = "Nordre*", komkode = "0101", login = login, password = password)
#'
#'  geo_getter(method = "vej", vejnavn = "Nordre*", komkode = "0101;0370", login = login, password = password)
#'
#'  geo_getter(method = "vej", komkode = "0370", login = login, password = password)
#'
#'  geo_getter(method = "vej", komkode = "0370", count = "true", login = login, password = password)
#'
#'  geo_getter(method = "vej", komkode = "0370", outgeoref = "EPSG:3857", login = login, password = password)
#'
#'  geo_getter(method = "vej", vejnavn = "Nybo*", geop = "724198,6175328", login = login, password = password)
#'
#'  geo_getter(method = "vej", vejkode = "5228", komkode = "0101", login = login, password = password)
#'
#'  geo_getter(method = "vej", vejnavn = "Od*", postnr = "2100", login = login, password = password)
#'
#'  geo_getter(method = "vej", vejnavn = "Od*", postnr = "2100;8000", login = login, password = password)
#'
#'  geo_getter(method = "vej", vejnavn = "jernbane*", geoenv = "719000,6176000;721000,6178000", login = login, password = password)
#'
#'  geo_getter(method = "vej", geoenv = "11.3930,55.6550;11.3970,55.6650", georef = "EPSG:4326", vejnavn = "*vej", login = login, password = password)
#'
#'  # Calls with the "postdistrikt" method ----
#'  geo_getter(method = "postdistrikt", postnr = "2100", login = login, password = password)
#'
#'  geo_getter(method = "postdistrikt", postnavn = "*skov*", login = login, password = password)
#'
#'  geo_getter(method = "postdistrikt", postnavn = "*skov*", scale = "2000000", login = login, password = password)
#'
#'  geo_getter(method = "postdistrikt", sognkode = "8182", login = login, password = password)
#'
#'  geo_getter(method = "postdistrikt", sognnavn = "sankt*", login = login, password = password)
#'
#'  # Calls with the "kommune" method ----
#'  geo_getter(method = "kommune", komkode = "0101", login = login, password = password)
#'
#'  geo_getter(method = "kommune", komnavn = "*skov*", login = login, password = password)
#'
#'  geo_getter(method = "kommune", regkode = "1084", login = login, password = password)
#'
#'  geo_getter(method = "kommune", regkode = "1084", login = login, password = password)
#'
#'  geo_getter(method = "kommune", geop = "550000,6220000", login = login, password = password)
#'
#'  geo_getter(method = "kommune", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  # Calls with the "sogn" method ----
#'  geo_getter(method = "sogn", sognnavn = "Sankt*", login = login, password = password)
#'
#'  geo_getter(method = "sogn", sognkode = "8182", login = login, password = password)
#'
#'  geo_getter(method = "sogn", sognkode = "8182", scale = "10000", login = login, password = password)
#'
#'  # Calls with the "politikreds" method ----
#'  geo_getter(method = "politikreds", polkredsnr = "8", login = login, password = password)
#'
#'  geo_getter(method = "politikreds", polkredsnr = "8", scale = "2000000", login = login, password = password)
#'
#'  geo_getter(method = "politikreds", polkredsnavn = "syd*", login = login, password = password)
#'
#'  geo_getter(method = "politikreds", geop = "550000,6220000", login = login, password = password)
#'
#'  geo_getter(method = "politikreds", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  geo_getter(method = "politikreds", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  # Calls with the "opstillingskreds" method ----
#'  geo_getter(method = "opstillingskreds", opstnr = "72", scale = "2000000", login = login, password = password)
#'
#'  geo_getter(method = "opstillingskreds", opstnavn = "*sted", login = login, password = password)
#'
#'  geo_getter(method = "opstillingskreds", opstnavn = "*sted", login = login, password = password)
#'
#'  geo_getter(method = "opstillingskreds", opstnavn = "*sted", login = login, password = password)
#'
#'  geo_getter(method = "opstillingskreds", geop = "550000,6220000", scale = "2000000", login = login, password = password)
#'
#'  geo_getter(method = "opstillingskreds", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  geo_getter(method = "opstillingskreds", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  # Calls with the "retskreds" method ----
#'  geo_getter(method = "retskreds", retskredsnr = "8", login = login, password = password)
#'
#'  geo_getter(method = "retskreds", retskredsnr = "8", scale = "2000000", login = login, password = password)
#'
#'  geo_getter(method = "retskreds", retskredsnavn = "*ens", login = login, password = password)
#'
#'  geo_getter(method = "retskreds", geop = "550000,6220000", login = login, password = password)
#'
#'  geo_getter(method = "retskreds", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  geo_getter(method = "retskreds", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  # Calls with the "matrikelnr" method ----
#'  geo_getter(method = "matrikelnr", ejkode = "240751", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", ejkode = "240751", count = "true", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", ejkode = "240751", outgeoref = "EPSG:4326", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", ejkode = "1061252", matnr = "11*", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", georef = "EPSG:4326", geoenv = "11.3930,55.6550;11.3970,55.6650", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", geopol = "550000,6220000;550000,6222000;551000,6221000;550000,6220000", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", geop = "550000,6221000", login = login, password = password)
#'
#'  geo_getter(method = "matrikelnr", georef = "EPSG:4326", geop = "11.2930,55.6550", login = login, password = password)
#'
#'  # Calls with the "esrejendom" method ----
#'  geo_getter(method = "esrejendom", esrejdnr = "1900000299", login = login, password = password)
#'
#'  geo_getter(method = "esrejendom", sfeejdnr = "9025885", login = login, password = password)
#'
#'  geo_getter(method = "esrejendom", ejkode = "1061252", matnr = "11y", login = login, password = password)
#'
#'  geo_getter(method = "sfeejendom", sfeejdnr = "9025885", login = login, password = password)
#'
#'  geo_getter(method = "sfeejendom", ejkode = "1061252", matnr = "11y", login = login, password = password)
#'
#'  # Calls with the "stedv2" method ----
#'  geo_getter(method = "stedv2", stednavn = "*øbi*", stedkat = "By", login = login, password = password)
#'
#'  geo_getter(method = "stedv2", stednavn = "kat*", stedkat = "gård", geop = "550000,6220000", login = login, password = password)
#'
#'  # Calls with the "stedkat" method ----
#'  geo_getter(method = "stedkat", login = login, password = password)
#'
#'  # Calls with the "koortrans" method ----
#'  geo_getter(method = "koortrans", ingeop = "550000,6220000", login = login, password = password)
#'
#'  geo_getter(method = "koortrans", ingeop = "550000,6220000;810000,6340000;720000,6230000", login = login, password = password)
#'
#'  geo_getter(method = "koortrans", ingeop = "11.2578,56.1167", ingeoref = "EPSG:4326", outgeoref = "EPSG:25832", login = login, password = password)
#'
#'  geo_getter(method = "koortrans", ingeop = "550000,6220000", outgeoref = "EPSG:3857", login = login, password = password)
#'
#'  geo_getter(method = "koortrans", ingeop = "550000,6220000", outgeoref = "EPSG:4094", login = login, password = password)
#'
#'  # Calls with elevationmodel = "dtm" ----
#'  geo_getter(elevationmodel = "dtm", method = "hoejde", geop = "720122,6175038", login = login, password = password)
#'
#'  geo_getter(elevationmodel = "dsm", method = "hoejde", geop = "720122,6175038", login = login, password = password)
#'
#'  geo_getter(elevationmodel = "dsm", method = "hoejde", geop = "720122,6175038", login = login, password = password)
#'
#'  geo_getter(elevationmodel = "dtm", method = "hoejde", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#'
#'  geo_getter(elevationmodel = "dtm", method = "geopmulti", geop = "720122,6175038;710122,6175038", elevationmodel = "dtm", login = login, password = password)
#'
#'  geo_getter(elevationmodel = "dtm", method = "geopmulti", geop = "720122,6175038;710122,6175038", elevationmodel = "dsm", login = login, password = password)
#'
#'  # Calls with the "hoejde" method ----
#'  geo_getter(method = "hoejde", geop = "11.39683742,55.66003658", georef = "EPSG:4326", login = login, password = password)
#' }
geo_getter <- function(...){

  url <- geo_url_builder(...)

  # Get data from API
  get_data <- httr::GET(url)
  s <- httr::content(get_data)

  # Create a polygon
  safe_readOGR <- purrr::safely(rgdal::readOGR)
  geodata <- safe_readOGR(s, "OGRGeoJSON", verbose = F, stringsAsFactors = FALSE)

  if(is.null(geodata$result)){
    safe_fromJSON <- purrr::safely(jsonlite::fromJSON)
    s <- safe_fromJSON(s)

    return(s$result)
  }

  # return data
  geodata$result
}
