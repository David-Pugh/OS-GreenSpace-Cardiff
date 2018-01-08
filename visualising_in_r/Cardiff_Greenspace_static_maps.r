
## Get the latest devlopment version of ggmap, you only have to do this once
#library(devtools)
#devtools::install_github("dkahle/ggmap")

library(rgdal)
library(ggmap)
library(ggplot2)


## central location and zoom of your base map

lat = 51.48
lon = -3.17
zoom = 14


######## Get the static base map
mapImage <- get_map(location = c(lon = lon, lat = lat),
            color = "color",
            source = "google",
            maptype = "satellite",
            zoom = zoom)


######## Get the shapefiles and load them
folder<- '/Users/davidpugh/Desktop/OSOpenGreenspaceESRIShapeFileST/data'
sites <-readOGR(dsn=folder, layer='ST_GreenspaceSite' )
access <-readOGR(dsn=folder, layer='ST_AccessPoint' )


######## Transform the cordinate system
# describes data’s current coordinate reference system
proj4string(sites) 

# to change to correct projection:
sites.trans <- spTransform(sites, CRS("+proj=longlat +datum=WGS84")) 
access.trans <- spTransform(access, CRS("+proj=longlat +datum=WGS84")) 

# Format to Dataframe so can be used by ggmap
sites.fort <- fortify(sites.trans)
access.df <- as.data.frame(access.trans)

# need to rename cols in the access points  
names(access.df)[names(access.df) == 'coords.x1'] <-"long"
names(access.df)[names(access.df) == 'coords.x2'] <-"lat"

######## Plot
#  Plot the shapefile only - first the sites as polygons
ggplot(data=sites.fort, aes(long, lat, group=group)) + 
    geom_polygon(colour='black', fill='white') +
    theme_bw()
    
#   The the access points    
ggplot(data= as.data.frame(access.df), aes(long, lat)) + 
    geom_point(colour='red', size = 1) +
    theme_bw()
    
#  Plot the map only
ggplot(mapImage)
 
#  Plot all - bae map with sites and points as layers
#  We trim the excess data using coord_map

p <- 	ggmap(mapImage, extent = "normal", maprange = FALSE) +
       	geom_polygon(data = sites.fort,
                  aes(long, lat, group = group),
                  fill = "green", colour = "black", alpha = 0.3) +	 
    	geom_point(data = access.df,
	 			aes(long, lat),
	 			colour='red', size = 0.9)+
     	theme_bw() +
     	coord_map(projection="mercator",
               xlim=c(attr(mapImage, "bb")$ll.lon, attr(mapImage, "bb")$ur.lon),
               ylim=c(attr(mapImage, "bb")$ll.lat, attr(mapImage, "bb")$ur.lat))

print(p)
