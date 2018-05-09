# OS-GreenSpace-Cardiff
## Exploring the Shapefile with R
The concept is quite straightforward - go grab the appropriate base map and then plot the shapefile over the top of it as a set of polygons. However there are a few potential trip points!

### Libraries

#### ggmap
[ggmap](https://cran.r-project.org/web/packages/ggmap/ggmap.pdf)(1) is a collection of functions to visualize spatial data and models on top of static maps from various online sources (e.g Google Maps and Stamen Maps). It includes tools common to those tasks, including functions for geolocation and routing.

However, recent updates to means that trying to display maps with ```ggmap()``` can lead to the following error:

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
This is fairly straightforward if you have ggmaps installed. Using ```get_map``` we can go get the appropriate map from a suitable source, .e.g., to get a map of South Wales centred around Cardiff from Google Maps:

```R
mapImage <- get_map( location = c(lon = 51.4816, lat =-3.1791), 
                    color = 'color',
                    source = 'google',
                    zoom = 8)
```
You can get the appropriate cordinates from [Google Maps](https://support.google.com/maps/answer/18539?co=GENIE.Platform%3DDesktop&hl=en) or other from many other [utilities](https://www.gps-coordinates.net). See Google for a guide to the [zoom](https://developers.google.com/maps/documentation/static-maps/intro#Zoomlevels) parameter.

This map image object can be plotted using ```ggmap(mapImage)```, but can also be handled like a [ggplot](http://ggplot2.org) object, so we can add layers.

### Getting the Shapefile data
Getting the shapefile into R and in the right format is fairly straightformward using the ```readOGR``` tool in rgdal. For a shapefile the dsn is the folder where all our required shapefile files are stored (including the shx, dbf and prj files) and the layer is the shapefile file name without the .shp extension. For example to load the greenspace sites:

```R
sites <-readOGR(dsn=folder, layer='ST_GreenspaceSite' )
```

Although rgdal is powerful, it can be quirky at times (e.g., [backslashes at the end of your folder reference will cause a fail](http://zevross.com/blog/2016/01/13/tips-for-reading-spatial-files-into-r-with-rgdal/) ). If it loads successfully you will see a brief summary of the shapefile, including the number of features and fields it contains.

The shapefile itself can be plotted and viewed 
```r
ggplot(data=fortify(sites), aes(long, lat, group=group)) + 
    geom_polygon(colour='black', fill='white') +
    theme_bw()
```

### Overlaying the Shapefile on the Basemap
We can build up a ggmap object using the basemap and the shapefile layers. However, we need to ensure the co-ordinate systems of the shapefile and ggmap match. To see what system the shapefile uses use the command ```proj4string(loaded_shapefile_data)``` (this data is stored in the .prj file). For OS Shapefiles we see the following: 
```
"+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +datum=OSGB36 +units=m +no_defs +ellps=airy +towgs84=446.448,-125.157,542.060,0.1502,0.2470,0.8421,-20.4894"
```
We need to transform the shapefile into the coordinates (latitude/longitude) on the World Geodetic System of 1984 (WGS84) datum as used by ggmaps. This is achieved using the rgdal package

```r
trans_shapefile_data <- spTransform(shpData, CRS("+proj=longlat +datum=WGS84"))
```

Nearly There! The issue we now have is that the zoom we have chosen and the area covered by the shapefile are likely to be different. The plot will default to showing whichever is larger - the shapefile or the map. If the map is zoomed in, this means it may appear as a small square within the larger shapefile:

![Greenspaces near Cardiff Centre as viewed in R, but without trimming to the cooridnates of the map](/img/cardiff_greenspace_notrim.png?raw=true "untrimmed data")

To avoid this we need to eliminate any points that are out of the map range. This allows us then to create a static map from Google, with the OS Greenspace sites overlaid. 

![Greenspaces near Cardiff Centre as viewed in R](/img/cardiff_greenspace.png?raw=true "Greenspace Data")

Adding the access points is very similar, just load up the shapefile, transform its coordinates and add as a geom_points layer. However, the data within the access points is in a slightly different format. The lat and long are bundled in a single column called coordinates (use ```head()``` to see the first few data points. After transformation the lat and long values are extracted out into new columns called coords.x1 and cords.x2. These can be renamed and used in the ```aes``` call in ```geom_point```. The data does not need to be fortified, just tell ggmap to intepret it as a dataframe.

```R
p <- ggmap(mapImage, extent = "normal", maprange = FALSE) +
     geom_polygon(data = fortify(sites.transformed),
                  aes(long, lat, group = group),
                  fill = "green", colour = "black", alpha = 0.3) +	 
    	geom_point(data = as.data.frame(access.transformed),
	 			             aes(long, lat),
	 			             colour='red', size = 0.9) +
     theme_bw() +
     coord_map(projection="mercator",
               xlim=c(attr(mapImage, "bb")$ll.lon, attr(mapImage, "bb")$ur.lon),
               ylim=c(attr(mapImage, "bb")$ll.lat, attr(mapImage, "bb")$ur.lat))

print(p)
```
You can play around with the zoom level and the map type to get different views of the Greenspaces near to you. You can use maps from various sources - see the [ggmap cheatsheet](https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/ggmap/ggmapCheatsheet.pdf) for ideas.

![Greenspaces near Cardiff Centre as viewed in R](/img/cardiff_greenspace_satellite.png?raw=true "Greenspace on Satellite Data")


### Citations
1. D. Kahle and H. Wickham. ggmap: Spatial Visualization with ggplot2, The R Journal, 5(1), 144-161. URL http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf
