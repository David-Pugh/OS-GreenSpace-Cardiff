# OS-GreenSpace-Cardiff
Experimenting with the OS Greenspace maps.

You can explore the [OS](https://www.ordnancesurvey.co.uk/) Greenspace maps in your browser at https://www.ordnancesurvey.co.uk/getoutside/greenspaces/ - a great way to see what open and green spaces are nearby and how you could create routes between them. OS Maps lets you find different places for leisure and recreation across England, Scotland and Wales.

In this code I play with the using the shapefiles from OS Greenspaces; overlaying them on geotiles to create my own bespoke maps using R, as well as interactive browser maps using Python and [Folium](https://folium.readthedocs.io/en/latest/)/Leaflet.js. 

Access to the shapefiles is via OS at https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html 


## Exploring the Shapefile with R
The concept is quite straightforward - go grab the appopriate base map and then plot the shapefile over the top of it as a set of polygons. However there are a few potential trip points!


### Libraries

#### ggmap
[ggmap](https://cran.r-project.org/web/packages/ggmap/ggmap.pdf) is a collection of functions to visualize spatial data and models on top of static maps from various online sources (e.g Google Maps and Stamen Maps). It includes tools common to those tasks, including functions for geolocation and routing.

However, recent updates to means that displaying maps can lead to the following error:

```R
Error: GeomRasterAnn was built with an incompatible version of ggproto.
Please reinstall the package that provides this extension.
```

This is a reported problem https://github.com/dkahle/ggmap/issues/122 and the solution is to install ggmap direct from github (2.6.2) https://github.com/dkahle/ggmap using devtools. Make sure all the dependencies are installed too (e.g., tibble) and the install is a success.

```R
devtools::install_github("dkahle/ggmap")
```
#### maptools
[maptools](https://cran.r-project.org/web/packages/maptools/maptools.pdf) is a set of tools for manipulating and reading geographic data, in particular ESRI Shape- files. This library is used to open and handle the ONS Greenspace shapefile. 

### Getting the base map
This is fairly straightforward if you have ggmaps installed. Using ```get_map``` we can go get the appropriate map from an appopriate source, .e.g., to get a map of South Wales centred around Cardiff:

```R
mapImage <- get_map( location = c(lon =, lat =), 
                    color = 'color',
                    source = 'google',
                    zoom = 8)
```

This map image object can be plotted using ```ggmap(mapImage)```.
