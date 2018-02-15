package.name <- "roadHotspots"
package.dir <- paste0("~/DADOS/BRUNO/MyPackges/", package.name)
setwd(package.dir)
### --- Use Roxygenise to generate .RD files from my comments
library(roxygen2)
roxygenise(package.dir = package.dir)
system(command = paste("R CMD INSTALL '", package.dir, "'", sep=""))
