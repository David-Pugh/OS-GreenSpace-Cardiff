# OS-GreenSpace-Cardiff
Experimenting with the OS Greenspace maps.

You can explore the [OS](https://www.ordnancesurvey.co.uk/) Greenspace maps in your browser at https://www.ordnancesurvey.co.uk/getoutside/greenspaces/ - a great way to see what open and green spaces are nearby and how you could create routes between them. OS Maps lets you find different places for leisure and recreation across England, Scotland and Wales.

In this code I play with the using the shapefiles from OS Greenspaces; overlaying them on geotiles to create my own bespoke maps using R, as well as interactive browser maps using Python and [Folium](https://folium.readthedocs.io/en/latest/)/Leaflet.js. 

Access to the shapefiles is via OS at https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html 


## Shapefile
 
The greenspace data from OS is available in Geography Markup Language [GML](http://www.opengeospatial.org/standards/gml) and [ESRI Shapefile](https://www.esri.com/library/whitepapers/pdfs/shapefile.pdf)format. Both formats describe geographic features. I downloaded and used the Shapefile format. This is a digital vector storage format for storing geometric location and associated attribute information. The downloaded file consists of a readme, liscence information and the data in a subfolder. It consists of 3 mandatory files (shp, shx and dbf) along with a prj for the greenspace sites and also the access points for each site. These files need to be kept together.

* .shp — shape format; the feature geometry itself
* .shx — shape index format; a positional index of the feature geometry to allow seeking forwards and backwards quickly
* .dbf — attribute format; columnar attributes for each shape, in dBase IV format
* .prj — projection format; the coordinate system and projection information, a plain text file describing the projection

## Viewing the Shapefile with QGIS
[QGIS](https://www.qgis.org/en/site/) is a free and Open Source Geographic Information System. It allows you to create, edit, visualise, analyse and publish geospatial information on Windows, Mac, Linux and BSD. Its a great starting point to make sure the downloaded shapefile is ok and understand what it contains. 

Create a new project withn QGIS and add a vector layer - select the .shp file and it will load the data. The Greenspace sites and access points can be loaded as seperate layers - the latter appearing as dots and the former as polygons. A snapshot of the greenspaces near Cardiff City Centre are shown below at a scale of 1:25000; if you are familiar with the areas you can see Bute Park alongside the River Taff (centre left) and Roath Park, Roath Rec and Waterloo Gardens stretching in a long strip (centre right). However, just the layers themselves are not that useful! Lets look at adding a map behind them.

![Greenspaces near Cardiff Centre as viewed in QGIS](/img/Cardiff_greenspace_qgis.png?raw=true "Optional Title")

## Exploring the Shapefile with R
The concept is quite straightforward - go grab the appropriate base map and then plot the shapefile over the top of it as a set of polygons. However there are a few potential trip points!

### Libraries

#### ggmap
[ggmap](https://cran.r-project.org/web/packages/ggmap/ggmap.pdf)(1) is a collection of functions to visualize spatial data and models on top of static maps from various online sources (e.g Google Maps and Stamen Maps). It includes tools common to those tasks, including functions for geolocation and routing.

However, recent updates to means that displaying maps can lead to the following error:

```R
Error: GeomRasterAnn was built with an incompatible version of ggproto.
Please reinstall the package that provides this extension.
```

This is a reported problem https://github.com/dkahle/ggmap/issues/122 and the solution is to install ggmap direct from github (2.6.2) https://github.com/dkahle/ggmap using devtools. Make sure all the dependencies are installed too (e.g., tibble) and the install is a success.

```R
devtools::install_github("dkahle/ggmap")
```
#### rgdal
[rgdal](https://cran.r-project.org/web/packages/rgdal/rgdal.pdf) is a set of tools for reading vector-based spatial data. It provides bindings to the Geospatial Data Abstraction Library (GDAL) for reading, writing and converting between spatial formats. This library is used to open and handle the ONS Greenspace shapefile. 

### Getting the base map
This is fairly straightforward if you have ggmaps installed. Using ```get_map``` we can go get the appropriate map from an appopriate source, .e.g., to get a map of South Wales centred around Cardiff from Google Maps:

```R
mapImage <- get_map( location = c(lon =, lat =), 
                    color = 'color',
                    source = 'google',
                    zoom = 8)
```
You can get the appropriate cordinates from [Google Maps](https://support.google.com/maps/answer/18539?co=GENIE.Platform%3DDesktop&hl=en) or other from many other [utilities](https://www.gps-coordinates.net). See Google for a guide to the [zoom](https://developers.google.com/maps/documentation/static-maps/intro#Zoomlevels) parameter.

This map image object can be plotted using ```ggmap(mapImage)```, but can also be handled like a [ggplot](http://ggplot2.org) object, so we can add layers.

### Getting the Shapefile data
Getting the shapefile into R an din the right format is fairly straightformward using the ```readOGR``` tool in rgdal. For shapefile the dsn is the folder where all our required shapefile files are stored (including the shx, dbf and prj files) and the layer is the shapefile file name without the .shp extension. For example to load the greenspace sites:

```R
sites <-readOGR(dsn=folder, layer='ST_GreenspaceSite' )
```

Although rgdal is powerful, it can be quirky at times (e.g., [backslashes at the end of your folder reference will cause a fail](http://zevross.com/blog/2016/01/13/tips-for-reading-spatial-files-into-r-with-rgdal/). If it loads successfully you will see a brief summary of the shapefile, including the number of features and fields it contains.

### Overlaying the Shapefile on the Basemap


### Citations
1. D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2, The R Journal, 5(1), 144-161. URL http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf
