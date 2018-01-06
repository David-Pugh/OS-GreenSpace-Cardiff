# OS-GreenSpace-Cardiff
Experimenting with the OS Greenspace maps.

You can explore the [OS](https://www.ordnancesurvey.co.uk/) Greenspace maps in your browser at https://www.ordnancesurvey.co.uk/getoutside/greenspaces/ - a great way to see what open and green spaces are nearby and how you could create routes between them. OS Maps lets you find different places for leisure and recreation across England, Scotland and Wales.

In this code I play with the using the shapefiles from OS Greenspaces; overlaying them on geotiles to create my own bespoke maps using R, as well as interactive browser maps using Python and [Folium](https://folium.readthedocs.io/en/latest/)/Leaflet.js. 

Access to the shapefiles is via OS at https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html 


## Exploring the Shapefile with R

### Libraries
The main library used in R is [ggmap](https://cran.r-project.org/web/packages/ggmap/ggmap.pdf). This is a collection of functions to visualize spatial data and models on top of static maps from various online sources (e.g Google Maps and Stamen Maps). It includes tools common to those tasks, including functions for geolocation and routing.

However, recent updates to means that displaying maps can lead to the following error:

``` Error: GeomRasterAnn was built with an incompatible version of ggproto.
Please reinstall the package that provides this extension.
```

This is a reported problem https://github.com/dkahle/ggmap/issues/122 and the solution is to install ggmap direct from github (2.6.2) https://github.com/dkahle/ggmap using devtools.

```R
devtools::install_github("dkahle/ggmap")
```
