# Creating Interactive Plots with Python and Folium

The static plots we created in R are good, but lets look at how we can create something more interactive. For this I use [Foilum](http://folium.readthedocs.io) - a library in Python. Folium builds on the data wrangling strengths of the Python ecosystem and the mapping strengths of the [Leaflet.js](http://leafletjs.com) library. So we can get and manipulate data in Python, then visualize it in on a html based Leaflet map via Folium.We can then start to play with the data sets and see if we can customise the information it shows. 

## Libaries
There are several libraries that will make our job easier in Python:

* [GeoPandas](http://geopandas.org) - makes working with geospatial data a breeze
* [Folium](http://folium.readthedocs.io)  - generate Leaflet.js maps in Python

## A note on environments
I used Conda to management my environments, but I did see an issue trying to load GeoPandas - this issue is seen by a [few people using OSX](https://github.com/ioos/conda-recipes/issues/623). To solve it I set a new environment with Python 3.4 and ensured it used GeoPandas from the the ioos (US Integrated Ocean Observing System) channel.

```conda create -n greenspace_env -c ioos geopandas python=3.4.```

This makes sure that GeoPandas gets installed with compatible dependencies. I could then install folium from [forge](https://conda-forge.org)

```conda install -c conda-forge folium```

This just makes sure that the packages all work nicely together on OSX.

## Loading the shapefile
Using GeoPandas 

```shape_data = gpd.read_file("ST_GreenspaceSite.shp")```

## Loading the base map tiles
Using Foilum, loading the base map tiles is straightforward and requires a single function call:

```Python
m = folium.Map(location=[51.52, -3.12],
        tiles='Stamen Toner',
        zoom_start=12)
```
I chose a zoom and centre so I could see both my house and work locations, and as a reminder of how close I am to thee green spaces and that I have no excuse to go out and explore more,  I added each as a marker.

```Python
folium.Marker([51.553989, -3.029008], popup='<i>My Work</i>', icon=work_icon).add_to(m)
```

## Transforming the Shapefile Coordinate Reference System
The Shapefile Cordinate Reference System (CRS) is [EPSG](http://www.epsg.org) 27700 -  (unsurprisingly) this is the [British National Grid](http://spatialreference.org/ref/epsg/27700/). To plot on the folium map we need to transform the CRS to WGS84 - also referred to as EPSG4326. This is easily achieved in GeoPandas:

```Python
# Let's take a copy of our layer
shape_data_proj = shape_data.copy()

# Reproject the geometries by replacing the values with projected ones
shape_data_proj['geometry'] = shape_data_proj['geometry'].to_crs(epsg=4326)
```

## Converting to GeoJSON
Folium can create layers on the map from GeoJSON - effectively JSON structure detailing the geograhical features. Translating from GeoPandas dataframe to GeoJSON is also straightforward:

```Python
shape_geojson = shape_data_proj.to_json()
```

and this is easily added as a layer:

```Python
folium.GeoJson(
    shape_geojson,
    style_function=lambda feature: {
        'fillColor': 'green',
        'color' : 'green'
        },
    name='GreenSpaces'
    ).add_to(m)
```
The ```style_function``` parameter allows the polygons defined in the GeoJSON to be styled. 

## Dealing with the Access Points Shapefile
If we just convert the Access Points shapefile to GeoJSON and apply as a layer to the map, we will get a screenfull of default markers. This is not particularly useful and looks a complete mess. Instead we can add a layer of smaller markers. To achieve this we can create a feature layer that consists of a list of circular markers. We can generate these from the GeoPandas dataframe directly, and use the other columns to color and add information to each point. For example, you can add a pop up for each point showing the accessType text and colour code the circles based on whether they are for pedestrians or vehicle access.

```Python
access_feature_group = folium.FeatureGroup("Access Locations")

for idx,row in access_data_proj.iterrows():
    access_feature_group.add_child(
                folium.features.CircleMarker(location=[row['geometry'].y, row['geometry'].x],
                                radius = 2,
                                fillColor='darkgray',
                                color=access_type(row['accessType'])
                                ,popup=row['accessType']
                                )
    )
    
m.add_child(access_feature_group)
```

Unfortunately this loop takes a while with so many datapoints and the file can get quite big; Ill be investigating quicker and more efficient ways to add this layer in the future. In leaflet.js itself you can convert/style the points in GeoJSON itself - im hoping to find a way this can be done through Folium.

![Greenspaces near Cardiff Centre as viewed by Folium](/img/Greenspace_folium.png?raw=true "Foilum")
