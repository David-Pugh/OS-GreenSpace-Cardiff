Creating Interactive Plots with Folium

The static plots we created in R are good, but lets look at how we can create something more interactive. For this I use Foilum - a library in Python.

Loading the base map tiles


```Python
m = folium.Map(location=[51.52, -3.12],
        tiles='Stamen Toner',
        zoom_start=12)
```

