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
?mean            # get help on a specific function
??median         # search help docs


#  ---------------------------------------------------
## Preparing the Enviroment

# The environment is the how and where of the data and
# tools used in R.
#  ---------------------------------------------------

# Packages extend the functionality of R. 

# Install packages
# This step only needs to be done if you have never
# installed the package before.

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
# install.packages("readxl")

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

#  ---------------------------------------------------
## Reading Tabular Data into R

# Quick note: I have provided the data and shapefiles 
# that will be needed to follow this demo. Often, in our
# line of work we create our own data. This workshop will 
# use pre-existing census as part of a hypothetical
# planning exercise.
#  ---------------------------------------------------

## Read the data

#- working directory
#-- important concept for getting, and staying, organised with your files. 
setwd("C:/R_Local/WrkGrp_SpatialDemo")

# Read in the dataset
acs_data <- read_excel("./Data/acs_data.xlsx")
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
acs_data$MedIncQuart <- ntile(x = acs_data$Median_Income_estimate, n = 4)

# Filter the data
acs_data %>% 
  subset(select = c("NAME", "Median_Income_estimate")) %>%
  filter(Median_Income_estimate > 50000)

# Quick visualization
barplot(as.numeric(acs_data$Median_Income_estimate), na.rm=TRUE)


