
<!-- README.md is generated from README.Rmd. Please edit that file -->
geoDK
=====

The goal of geoDK is to make it easy to use danish GIS data in R.

Installation
------------

You can install geoDK from github with:

``` r
# install.packages("devtools")
devtools::install_github("56north/geoDK")
```

Polygons
--------

geoDK contains polygon data for a range of danish administrative areas. It has data for:

-   parishes
-   zip codes
-   municipalities
-   rural areas
-   regions

Let me show you a few examples.

#### First load packages and necessary data

``` r
library(geoDK)

data("region.polygon")
```

#### Plot it using `ggplot()`

We can also plot the data using ggplot2. We just need to do a little data wrangling to make the data plotable through ggplot2.

``` r
# Load ggplot2
library(ggplot2)

# Load ggthemes to get the theme_map() function
library(ggthemes)

# We need to fortify the polygon. It basically takes the polygon and turns it into a 
# data frame that ggplot2 can use for plotting.
region.df = fortify(region.polygon)
#> Loading required package: sp
#> Regions defined for each Polygons

# Lets have a look at it
head(region.df, 10)
#>        long      lat order  hole piece id group
#> 1  10.60365 57.72044     1 FALSE     1  0   0.1
#> 2  10.59572 57.71650     2 FALSE     1  0   0.1
#> 3  10.59356 57.71694     3 FALSE     1  0   0.1
#> 4  10.59210 57.71917     4 FALSE     1  0   0.1
#> 5  10.58851 57.71924     5 FALSE     1  0   0.1
#> 6  10.58768 57.71879     6 FALSE     1  0   0.1
#> 7  10.58241 57.71654     7 FALSE     1  0   0.1
#> 8  10.58725 57.71476     8 FALSE     1  0   0.1
#> 9  10.58313 57.71415     9 FALSE     1  0   0.1
#> 10 10.58263 57.71420    10 FALSE     1  0   0.1
```

What a nice tidy data frame. Now lets plot it.

``` r
# First we give ggplot() the data frame, then we specify long and lat on the axis
# and we tell it to group by group and give fill-color by id.
ggplot(region.df, aes(long, lat, group = group, fill = id)) + 
  # Then we plot the polygons
  geom_polygon(show.legend = F) +
  # Then we draw white lines to separate the regions
  geom_path(color="white") + 
  # Finally we apply the map theme
  theme_map()
#> Warning: `panel.margin` is deprecated. Please use `panel.spacing` property
#> instead
```

![](README-unnamed-chunk-3-1.png)

Since this is a ggplot object it also means that you can you all sorts of things to it. Like put an underlying map under it.

#### Plot it with `ggmap()` and `ggplot()`

``` r
library(ggmap)
#> Google Maps API Terms of Service: http://developers.google.com/maps/terms.
#> Please cite ggmap if you use it: see citation("ggmap") for details.

# First we get map data for our underlying map. 
mymap <- get_map(location = c(min(region.df$long), min(region.df$lat),
                              max(region.df$long), max(region.df$lat)),
                source = "osm")
```

With our new map we can easily overlay the ggplot2 elements from above. Lets draw red regional boundaries on the map.

``` r
ggmap(mymap) +
  geom_path(data = region.df, aes(long, lat, group = group), color = "red")
```

![](README-unnamed-chunk-5-1.png)

Or lets fill the map with our regions

``` r
ggmap(mymap) +
  geom_polygon(data = region.df, aes(long, lat, group = group, fill = id), show.legend = F) +
  geom_path(data = region.df, aes(long, lat, group = group), color = "red")
```

![](README-unnamed-chunk-6-1.png)

#### Plot it with `leaflet()`

It is also really easy to plot it interactively with the leaflet package.

``` r
library(leaflet)

leaflet(region.polygon) %>%
  addTiles() %>%
  addPolygons()
```

![](plot1.png)

Voila! Interactive map.
