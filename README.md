The ECAMECO package
==========

This R package can be used to retrieve the European Commission [AMECO database](https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco_en). 

The code behind this package also serves as a backend to an EViews add-in created by the author.

The package can retrieve the:

1. Current version of the AMECO database
2. Vintage versions of the AMECO database

To cite the ECAMECO package in publications, use:

>  Graeme Walsh (2018). _ECAMECO_ R package version **0.1.0**.

Installation - Method 1
-----------

To install the package, use the [devtools package](http://cran.r-project.org/web/packages/devtools/index.html) as follows:

```r
install.packages("devtools")
library(devtools)
install_github(repo="xprimexinverse/ECAMECO")
```

Installation - Method 2
-----------

If you have trouble installing the package using devtools, here is a second method.

1. Go to [GitHub](https://github.com/xprimexinverse/ECAMECO)
2. Download the zip file (click on Clone or Download)
3. Unzip the file
4. In the unzipped file, open the R Project (.rproj) file
5. In RStudio, click Build (top right corner) then Build & Reload (this step may require installing Rtools)

Installation - Method 3
-----------

If you're really stuck, you can load the functions in the package as follows:

```r
source("https://raw.githubusercontent.com/xprimexinverse/ECAMECO/master/R/ECAMECO.R")
```

Quick Start
-----------

Begin by loading the package and reading some of the man pages:

```r
library(ECAMECO)
?ECAMECO
?getECAMECO
```

Examples
-----------

To quickly get a feel for how the package works, run the following examples.

The first example shows how to retrieve the latest version of the AMECO database. The database is returned as a dataframe object.

```r
# Example 1
AMECO <- getECAMECO()
class(AMECO)
names(AMECO)
```

The second example demonstrates how to get the URLs to the vintages of the database.

```r
# Example 2
Vintage_URLs <- getVitageURLs()
```

The third example shows how to retrieve one of the vintage databases.

```r
# Example 3
AMECO_vintage <- getECAMECO(url = Vintage_URLs[1])
class(AMECO_vintage)
names(AMECO_vintage)
```

Feedback, Bugs, Suggestions
-----------

Please contact me at <graeme.walsh@centralbank.ie> or <graeme.walsh@hotmail.co.uk>


News (2018 - August)
-----------
This is the first release of the package. Future plans include adding helper functions for extracting variables from the dataset.

Disclaimer
-----------

I have no affiliation with the European Commission. This package is not official software of the European Commission nor is the package endorsed by the European Commission.
