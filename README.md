# roadHotspots: A Shiny app to visualize hotspots over linear features (eg. roads) for a set of observations (eg. animal crossings, roadkills)

Currently two methods are available: Gaussian Kernel and Malo et al.'s method (2004). Please be advised that this package is under development and it's not fully tested. You can use the issues tab to report any "bug", commentary or suggestion.

You can install the roadHotspots package from github with:
``` r
# install.packages("devtools")
library(devtools)
devtools::install_github("bmsasilva/roadHotspots")
```
To start the app run:
``` r
library(roadHotspots)
run_app()
```
