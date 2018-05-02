# roadHotspots: A Shiny app to visualize hotspots over linear features (eg. roads) for a set of observations (eg. animal crossings, roadkills)

Currently two methods are available: gaussian kernel density estimation and Malo et al.'s method (2004). Please be advised that this package is still under development and it was only tested on Linux. You can use the issues tab to report any "bug", commentary or suggestion.

You can install the roadHotspots package from github with:
``` r
# install.packages("devtools")
library(devtools)
devtools::install_github("bmsasilva/roadHotspots")
```

A sample roads shapefile (roads.shp) and a sample file with observations (counts.csv) are available to test the shiny app. To find the location of these files in the system run (in the R console):
``` r
system.file("extdata", package = "roadHotspots")
```

To start the app run:
``` r
library(roadHotspots)
run_app()
```
