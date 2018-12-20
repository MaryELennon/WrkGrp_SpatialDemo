#-------------------------------------------------------------
# ML/AI Working Group: Introduction to 'R' & 'R' as a GIS
# Thursday 20 December 2018
# Mary Lennon & Matt Harris
#-------------------------------------------------------------

#-------------------------------------------------------------
# This workshop covers the basics of R and RStudio environment
# as well as how to use R as a GIS.

# Some of the Introduction to R material is recycled from
# Ben Markwick and Matt Harris's workshop presented at the
# Society for American Archaeology (SAA) Conference in 2018

# https://github.com/mrecos/SAA_R_workshop_2017
#-------------------------------------------------------------

#  ---------------------------------------------------
## What is an object oriented programming language?

# In object oriented programming, the data is important
# An object is a thing or idea that you want manipulate
# analyze in your program, An object can be anything,
# example, employee, bank account, car etc.
#  ---------------------------------------------------

## Interacting with R & RStudio

# - quick tour of console, script editor, plots, environment
# - using console as calculator, assigning values to objects, using objects

2 + 3
x <- 2
y <- 3
x + y
z <- x + y

# - commenting code
# - using functions

x <- c(4, 7, 12) # length measurements of three artefacts
# this is a vector! a sequence of elements of same type
x

y <- mean(x)     # compute the mean length
? mean            # get help on a specific function
?  ? median         # search help docs


#  ---------------------------------------------------
## Preparing the Enviroment

# The environment is the how and where of the data and
# tools used in R.
#  ---------------------------------------------------

# Packages extend the functionality of R.

# Install packages
# This step only needs to be done if you have never
# installed the package before.
# Ctrl+Shft+C to un-comment

# install.packages("sp")
# install.packages("rgdal")
# install.packages("rgeos")
# install.packages("backports") # So tidyverse will work
# install.packages ("fansi") # So some basic functionality will work
# install.packages("tidyverse")
# install.packages("raster")
# install.packages("tmap")
# install.packages("tmaptools")
# install.packages("leaflet")
# install.packages("RColorBrewer")
# install.packages("openxlsx")

# Load packages into the environment
# I tend to comment next to my packages to remind
# myself what they are for.

library(sp) # Classes and methods for spatial data
library(rgdal) # Access to projection/transformation operations
library(rgeos) # Manipulation and querying of spatial geometries
library(tidyverse) # For basic data manipulation
library(raster) # Works with spatial data primarily raster but also vector
library(tmap) # For mapping spatial data
library(tmaptools) # Additional tools for the tmap package
library(leaflet) # Open-source JavaScript libraries for interactive maps
library(RColorBrewer)  # Pre-packaged color pallettes
library(openxlsx) # Working with Excel documentation

#  ---------------------------------------------------
## Reading Tabular Data into R

# Quick note: I have provided the data and shapefiles
# that will be needed to follow this demo. Often, in our
# line of work we create our own data. This workshop will
# use pre-existing census as part of a hypothetical
# planning exercise.

# Data come from the 2018 American Community Survey
# https://www.census.gov/programs-surveys/acs/
#  ---------------------------------------------------

## Read the data
#- working directory
#-- important concept for getting, and staying, organised with your files.
setwd("C:/R_Local/WrkGrp_SpatialDemo")

# Read in the dataset
acs_data <- readxl::read_excel("./Data/acs_data.xlsx")
# output is data frame

#- tables in word docs and PDFs are possible but they require more work.

## Inspecting & cleaning data

# - basic functions for seeing what we have

# show structure
str(y) # vector
str(acs_data) # data frame - this is the table format most are used to

# look at the first and last parts
head(acs_data)
tail(acs_data)

# get column names
names(acs_data)

# see as table in RStudio, can sort (by EU) and filter (for CC) easily
View(acs_data)

# Extract a singular column (aka attribute) - use $ to access columns within a table (data frame)
MedianIncomeEst <- acs_data$Median_Income_estimate

# Create new column (aka attribute)
acs_data$MedIncQuart <-
  ntile(x = acs_data$Median_Income_estimate, n = 4)

# Filter the data
acs_data %>%
  subset(select = c("NAME", "Median_Income_estimate")) %>%
  filter(Median_Income_estimate > 50000)

# Quick visualization
barplot(as.numeric(acs_data$Median_Income_estimate), na.rm = TRUE)

#  ---------------------------------------------------
## Reading Spatial Data into R
# Spatial data comes in many shapes and sizes: GPX, Shapefile,
# GeoJSON, and more. The most common format is the shapefile.
# In this code a shapefile from file as well as from a
# geodatabase for comprehensiveness.

#  ---------------------------------------------------

# Census boundaries from a file geodatabase

# Set location of file geodatabase for ease
fgdb <- "./Data/Census_Tracts_GDB/Census_GDB.gdb"

# List all feature classes in a file geodatabase
subset(rgdal::ogrDrivers(), grepl("GDB", name))
fc_list <- rgdal::ogrListLayers(fgdb)
print(fc_list)

# Read the feature class
census_bound <-
  rgdal::readOGR(dsn = fgdb, layer = "Census_Boundaries_PA")

# View the feature class
tmap::qtm(census_bound)

# Philadelphia County boundary from a file geodatabase
phila_county <- rgdal::readOGR(dsn = fgdb, layer = "PhilaCounty")

# View the feature class
tmap::qtm(phila_county)

# Check the data that came in with the feature classes
# Slots contain all of the pertinent information for a shapefile.
# Ctrl+Shft+C to un-comment
#head(phila_county@)
#head(census_bound@)

#  ---------------------------------------------------
## Spatial & Tabular Joins

# Join the ACS data to the shapefile based on their
# common identifier. Also do a spatial selection of
# polygon-in-polygon.

#  ---------------------------------------------------
library(sp)

# Join the tabular ACS data
acs_spatial <-
  sp::merge(x = census_bound, y = acs_data, by = "GEOID")

# Coordinate reference systems, also known as projections,
# are really important when working with spatial data.
# "The Coordinate Reference System (CRS) of spatial objects
# defines where they are placed on the Earth's surface"
# (Lovelace, Cheshire, & Oldroyd, 2017). There are many
# different projections. Working with data in two different
# CRS, in one project, causes a compatibility issue. To
# fix this re-projection of the CRS is necessary.

# The ACS spatial data
acs_spatial@proj4string

# The Philadelphia county boundary
phila_county@proj4string

# Set the CRS as a variable for easy use
WGS84 <- "+init=epsg:4326"

# Re-project the data
phila_county <- sp::spTransform(x = phila_county, CRSobj = WGS84)
acs_spatial <- sp::spTransform(x = acs_spatial, CRSobj = WGS84)

## Please Note: Transforming/ Re-projecting the data is more than
# just changing the CRS. Please ALWAYS make sure you are transforming/
# re-projecting the data and not just changing the name of the CRS.

# Check the CRS
sp::proj4string(Philphila_countya_County)
sp::proj4string(acs_spatial)

# Subset census tracts only to Philadelphia County
acs_philly <-
  raster::intersect(phila_county,
                    acs_spatial)

# Quick plot to check
tmap::qtm(acs_philly)


#  ---------------------------------------------------
## Data Visualization

# Data visualization  is an important part of any
# analysts jobs. Maps can send particularly powerful
# messages. A range of useful visuals for reports
# through interactive maps to embed on a client facing
# portal can be made in R.

#  ---------------------------------------------------
library(tmap)
library(tmaptools)
library(RColorBrewer)

# Quick review structure of the data
str(acs_philly@data) # Note the data types

# Convert data types
acs_philly@data$Median_Income_estimate <- as.numeric(acs_philly@data$Median_Income_estimate)
acs_philly@data$MedIncQuart <- as.factor(acs_philly@data$MedIncQuart)

# Qucik map to show the variable of interest
tmap::qtm(acs_philly,
          fill = "MedIncQuart",
          fill.breaks = c(0, 1, 2, 3, 4, 5))

# ColorBrewer is a common go-to color palette choices

# To see all possible ColorBrewer options use the following function:
RColorBrewer::display.brewer.all()

# For more information on ColorBrewer: http://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3

# A map using a ColorBrewer pallette:
tm_shape(acs_philly) + 
  tm_fill("MedIncQuart", palette = "Blues")

tm_shape(acs_philly) + 
  tm_fill("MedIncQuart", palette = "-Blues") # Reversed

# Play with further maps details and repesentations of the data (Jenks breaks)
SEPTA_Map <-
  tm_shape(acs_philly) + 
  tm_fill(
  "Median_Income_estimate",
  style = "jenks",
  n = 5,
  palette = "Reds",
  legend.hist = TRUE
) +
  tm_layout(
    "ACS 2017 - Median Income",
    legend.title.size = 1,
    legend.text.size = 0.6,
    legend.width = 1.0,
    legend.outside = TRUE,
    legend.bg.color = "white",
    legend.bg.alpha = 0,
    frame = FALSE
  )

# Save map as a deliverable (or part of a deliverable to SEPTA)
tmap_save(SEPTA_Map, "./SEPTA_Deliverables/SEPTA_Map.jpg")

#  ---------------------------------------------------
## Layering Data & Interactive Maps

# For our planning project with SEPTA we need to
# include their data, locations of RR Stations and
# lines. The goal is to create an interactive web map 
# that could be embedded on a client dashboard.

#  ---------------------------------------------------
library(sp)
library(rgdal)
library(tmap)
library(tmaptools)
library(leaflet)

# Regional Rail shapefile
# Note: This is from file and not the geo-database
SEPTA_RR <-
  readOGR(dsn = "./Data/SEPTA_RegionalRail",
          layer = "SEPTAGISRegionalRailLines_201207")

# SEPTA Stations shapefile
SEPTA_Staions <-
  readOGR(dsn = "./Data/SEPTA_RegionalRail",
          layer = "SEPTAGISRegionalRailStations_2016")

# Make sure it is in the correct CRs
SEPTA_RR <- sp::spTransform(x = SEPTA_RR, CRSobj = WGS84)
SEPTA_Staions <- sp::spTransform(x = SEPTA_Staions, CRSobj = WGS84)

# Interactive webmap
# Other basemap options here: http://leaflet-extras.github.io/leaflet-providers/preview/
tmap_mode("view") # View for interactive

tm_basemap(providers$Esri.WorldTopoMap) +
  tm_shape(acs_philly) + 
  tm_fill(
    "Median_Income_estimate",
    style = "jenks",
    n = 5,
    palette = "Reds",
    legend.hist = TRUE
  ) +
  tm_shape(SEPTA_RR) +
  tm_lines(col = "black", scale = 1, alpha = 0.25) +
  tm_shape(SEPTA_Staions) +
  tm_dots(
    col = "black",
    scale = 1.5,
    alpha = 0.7,
    shape = 16
  ) +
  tm_layout(
    "ACS 2017 - Median Income",
    legend.title.size = 1,
    legend.text.size = 0.6,
    legend.width = 1.0,
    legend.outside = TRUE,
    legend.bg.color = "white",
    legend.bg.alpha = 0,
    frame = FALSE
  )

#  ---------------------------------------------------
## Buffers & Further Analysis

# SEPTA wants to know which census tracts fall within
# 100 ft. of their staions and what the median income
# for each of those census tracts is.

# The buffering function uses the units that the
# coordinate system is in.
#  ---------------------------------------------------

# Buffer the data
SEPTA_Buffer <- raster::buffer(SEPTA_Staions, width = 30) # meters

# Quick map
tm_shape(acs_philly) + 
  tm_fill(
    "Median_Income_estimate",
    style = "jenks",
    n = 5,
    palette = "Greys",
    legend.hist = TRUE
  ) +
  tm_shape(SEPTA_RR) +
  tm_lines(col = "black", scale = 1, alpha = 0.25) +
  tm_shape(SEPTA_Buffer) +
  tm_polygons(col = "red", alpha = 0.7) +
  tm_shape(SEPTA_Staions) +
  tm_dots(
    col = "black",
    scale = 0.5,
    alpha = 0,
    shape = 16
  )

# Spatial selection - census tracts overlap buffers
SEPTABuff_Census <-
  raster::intersect(SEPTA_Buffer,
                    acs_philly)

# Note that the raster package made a different data type (subtle)
poly_df <- as.data.frame(SEPTABuff_Census)
# do some staff with "poly_df" that doesn't support SpatialPolygonsDataFrame
# then convert it to SPDF back again
s_poly <- SpatialPolygonsDataFrame(SEPTABuff_Census, poly_df)


# Extract the tabular component of the SEPTA Buffer
SEPTA_CensusTbl <- SEPTABuff_Census@data

# View the results
glimpse(SEPTA_CensusTbl)

# Subset to the fields required
# Due to the joins we have a lot of additional fields and weird names
# we did not clean those up earlier in this code but we subset the data 
# here and rename the fields so they look nice in our final spreadsheet.
SEPTA_CensusTbl <- SEPTA_CensusTbl %>% 
  subset(select = c("GEOID.2", "NAME.y", "Median_Income_estimate"))

colnames(SEPTA_CensusTbl) <- c("GEOID", "Census_Tract_Name", "Median_Income")

# Export the data table
write.xlsx(SEPTA_CensusTbl, 
           "./SEPTA_Deliverables/SEPTA_Census_Table.xlsx")
