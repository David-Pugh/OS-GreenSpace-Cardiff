# OS-GreenSpace-Cardiff
Experimenting with the OS Greenspace maps.

You can explore the [OS](https://www.ordnancesurvey.co.uk/) Greenspace maps in your browser at https://www.ordnancesurvey.co.uk/getoutside/greenspaces/ - a great way to see what open and green spaces are nearby and how you could create routes between them. OS Maps lets you find different places for leisure and recreation across England, Scotland and Wales.

In this code I play with the using the shapefiles from OS Greenspaces; overlaying them on geotiles to create my own bespoke maps using R, as well as interactive browser maps using Python and [Folium](https://folium.readthedocs.io/en/latest/)/Leaflet.js and React.js and Deck.gl. 

Access to the shapefiles is via OS at https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html 


## Shapefile
 
The greenspace data from OS is available in Geography Markup Language [GML](http://www.opengeospatial.org/standards/gml) and [ESRI Shapefile](https://www.esri.com/library/whitepapers/pdfs/shapefile.pdf)format. Both formats describe geographic features. I downloaded and used the Shapefile format. This is a digital vector storage format for storing geometric location and associated attribute information. The downloaded file consists of a readme, liscence information and the data in a subfolder. It consists of 3 mandatory files (shp, shx and dbf) along with a prj for the greenspace sites and also the access points for each site. These files need to be kept together.

* .shp — shape format; the feature geometry itself
* .shx — shape index format; a positional index of the feature geometry to allow seeking forwards and backwards quickly
* .dbf — attribute format; columnar attributes for each shape, in dBase IV format
* .prj — projection format; the coordinate system and projection information, a plain text file describing the projection

## Viewing the Shapefile with QGIS
[QGIS](https://www.qgis.org/en/site/) is a free and Open Source Geographic Information System. It allows you to create, edit, visualise, analyse and publish geospatial information on Windows, Mac, Linux and BSD. Its a great starting point to make sure the downloaded shapefile is ok and understand what it contains. 

Create a new project withn QGIS and add a vector layer - select the .shp file and it will load the data. The Greenspace sites and access points can be loaded as seperate layers - the latter appearing as dots and the former as polygons. A snapshot of the greenspaces near Cardiff City Centre are shown below at a scale of 1:25000; if you are familiar with the areas you can see Bute Park alongside the River Taff (centre left) and Roath Park, Roath Rec and Waterloo Gardens stretching in a long strip (centre right). However, just the layers themselves are not that useful! Lets look at adding a map behind them using different technologies.

![Greenspaces near Cardiff Centre as viewed in QGIS](/img/Cardiff_greenspace_qgis.png?raw=true "Optional Title")

## Exploring the Shapefile with R
The concept is quite straightforward - go grab the appropriate base map and then plot the shapefile over the top of it as a set of polygons. This is a good start and gets static maps that you can eaily edit and customise. However there are a few potential trip points! See the  [visualising_in_r](/visualising_in_r/) for details. 
