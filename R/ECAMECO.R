# Header ------------------------------------------------------------------
#
# Title: R code for downloading the European Commission AMECO Database
#
# Author: Graeme Walsh <graeme.walsh@hotmail.co.uk>
# Date: 18/08/2018


# Package Info ------------------------------------------------------------

#' A package for downloading the European Commission's AMECO Database.
#'
#' The workhorse function of the package is \code{getECAMECO()}. This function returns a
#' list containing the AMECO database. The list contains a list for each topic in the database.
#' The code behind this package also serves as a backend to an EViews add-in created by the author.
#'
#'
#' @section ECAMECO functions:
#' \code{getECAMECO()}
#'
#' @docType package
#' @name ECAMECO
NULL


# Important variables -----------------------------------------------------

# New environment
ECAMECO.env <- new.env()

# European Commission AMECO database URL
ECAMECO.env$base_url <- "https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/download-annual-data-set-macro-economic-database-ameco_en"

# All zipped text files URL
ECAMECO.env$ameco0_url <- "http://ec.europa.eu/economy_finance/db_indicators/ameco/documents/ameco0.zip"

# European Commission AMECO vintages URL
ECAMECO.env$vintages_url <- "http://ec.europa.eu/economy_finance/db_indicators/ameco/archive_en.htm"

# # European Commission AMECO vintages Base URL
ECAMECO.env$vintages_base_url <- "http://ec.europa.eu/economy_finance/db_indicators/ameco/"

# File extensions
ECAMECO.env$filext <- c(".html", ".txt", ".zip")


# Webpage functions -------------------------------------------------------

#' @title Get the AMECO database homepage (.html file)
#' @description Reads the AMECO database html page into R
#' @export
#' @importFrom utils download.file
#' @author Graeme Walsh
#' @details The homepage is (https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/download-annual-data-set-macro-economic-database-ameco_en)
getHomepage <- function(){

  # Create .html temp file
  temp <- tempfile(fileext = ECAMECO.env$filext[1])

  # Download the file
  download.file(url = ECAMECO.env$base_url, destfile = temp)

  # Read the AMECO webpage
  home_page <- readLines(temp)

  return(home_page)
}

#' @title Get the AMECO database vintages page (.html file)
#' @description Reads the AMECO database vintages html page into R
#' @export
#' @importFrom utils download.file
#' @author Graeme Walsh
#' @details The vintages page is (http://ec.europa.eu/economy_finance/db_indicators/ameco/archive_en.htm)
getVintagespage <- function(){

  # Create .html temp file
  temp <- tempfile(fileext = ECAMECO.env$filext[1])

  # Download the file
  download.file(url = ECAMECO.env$vintages_url, destfile = temp)

  # Read the AMECO webpage
  vintages_page <- readLines(temp)

  return(vintages_page)
}


# Extract from HTML functions ---------------------------------------------

#' @title Get the last update of the database
#' @description Extracts the last update value from the AMECO database html page
#' @export
#' @author Graeme Walsh
#' @details The homepage is (https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/download-annual-data-set-macro-economic-database-ameco_en)
getLastUpdate <- function(){

  # Get the home page .html file
  home_page <- getHomepage()

  # Find Last update in the .html file
  last_update_html <- grep("Last update:", home_page, value = TRUE)

  # Get inside the <p> tags / remove the html content
  last_update <- gsub(".*<p>|</p>.*", "", last_update_html)

  return(last_update)
}

#' @title Get the zipped files URLs
#' @description Extracts the zipped files URLs from the AMECO database html page
#' @export
#' @author Graeme Walsh
#' @details The homepage is (https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/download-annual-data-set-macro-economic-database-ameco_en)
getZipURLs <- function(){

  # Get the home page .html file
  home_page <- getHomepage()

  # Find .zip files in the .html file
  zip_files_html <- grep(".zip", home_page, fixed = TRUE, value = TRUE)

  # Get inside the href tags / remove the html content
  zip_files_urls <- gsub(".*href=\"|\".*", "", zip_files_html)

  return(zip_files_urls)
}

#' @title Get the URL for the latest .zip file
#' @description Extracts the latest .zip file URL from the AMECO database html page
#' @export
#' @author Graeme Walsh
#' @details The homepage is (https://ec.europa.eu/info/business-economy-euro/indicators-statistics/economic-databases/macro-economic-database-ameco/download-annual-data-set-macro-economic-database-ameco_en)
getURL <- function(){

  # Get the .zip file URLs
  zip_files_urls <- getZipURLs()

  # Check if existing URL is in the current set of URLs
  if(any(zip_files_urls == ECAMECO.env$ameco0_url)){
    print("URL is OK!")
    print(paste0("All of the zipped text files are located here: ", ECAMECO.env$ameco0_url))
    url <- ECAMECO.env$ameco0_url
  }else{
    print("URL has changed.")
    print("The zipped text files are now located here: ")
    print(zip_files_urls)
    url <- grep("ameco0", zip_files_urls, value = TRUE)
  }
  return(url)
}

#' @title Get the URL for the vintage .zip files
#' @description Extracts the .zip file URLs from the AMECO database vintage page
#' @export
#' @author Graeme Walsh
#' @details The homepage is (http://ec.europa.eu/economy_finance/db_indicators/ameco/archive_en.htm)
getVitageURLs <- function(){

  # Get the home page .html file
  vintages_page <- getVintagespage()

  # Find .zip files in the .html file
  zip_files_html <- grep(".zip", vintages_page, fixed = TRUE, value = TRUE)

  # Get inside the href tags / remove the html content
  zip_files_urls <- gsub(".*href=\"|\".*", "", zip_files_html)

  # Append base url
  zip_files_urls <- paste0(ECAMECO.env$vintages_base_url, zip_files_urls)

  return(zip_files_urls)
}


# Read data functions -----------------------------------------------------

#' @title Get European Commission AMECO Database
#' @description Downloads the AMECO Database into R
#' @param url The URL pointing to the .zip file
#' @importFrom utils download.file unzip read.csv
#' @export
#' @author Graeme Walsh
#' @details The url parameter is set by default to the latest version of the AMECO database. This function can also downloand the vintage files. The vintage URLs can be found using the \code{getVintagesURLs()} function.
getECAMECO <- function(url=ECAMECO.env$ameco0_url){

  # Create .zip temp file
  temp <- tempfile(fileext = ECAMECO.env$filext[3])

  # Download the file
  download.file(url = url, destfile = temp)

  # Get the names of the zip files
  zipped_files <- unzip(temp, list=TRUE)

  # Read the text files into a list of lists
  AMECO_dataset_raw <- lapply(zipped_files$Name, function(x){
    read.csv(unz(temp, x), header=TRUE, sep=";", stringsAsFactors = FALSE, check.names = FALSE, na.strings = "NA", strip.white = TRUE)
  })
  names(AMECO_dataset_raw) <- zipped_files$Name

  # Flatten the list of lists to a list object
  AMECO_dataset <- do.call("rbind", AMECO_dataset_raw)
  # rownames(AMECO_dataset) <- NULL
  AMECO_dataset <- AMECO_dataset[,-ncol(AMECO_dataset)]

  return(AMECO_dataset)
}
