# make_tidy_poly ----
#' Turns a spatial object into a tidy tibble
#'
#' This will then work with ggplot2
#'
#' @param spatial an object of class SpatialPolygonsDataFrame
#'
#' @return tibble
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' library(geoDK)
#' library(ggplot2)
#'
#' geo_reg <- geo_get_spatial("Danish regions")
#'
#' df <- make_tidy_poly(geo_reg)
#'
#' ggplot(df) +
#'   geom_polygon(aes(x = lng, y = lat, group = area, fill = regionkode),
#'                show.legend = FALSE) +
#'   coord_cartesian()
make_tidy_poly <- function(spatial){

  data <- area <- NULL

  temp_df <- spatial@polygons %>%
    purrr::map_df(function(x){
      df <- x@Polygons[[1]]@coords %>%
        tibble::as_tibble() %>%
        purrr::set_names(c("lng", "lat"))
      df$area <- x@Polygons[[1]]@area
      df
    }) %>%
    dplyr::group_by(area) %>%
    tidyr::nest()

  poly_df <- dplyr::bind_cols(temp_df, spatial@data) %>%
    tidyr::unnest(data)

  # return data
  return(poly_df)
}
