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
# install.packages("tidyverse") 
# install.packages("raster") 
# install.packages("tmap") 
# install.packages("tmaptools") 
# install.packages("leaflet") 
# install.packages("RColorBrewer") 

# Load packages into the environment
# I tend to comment next to my packages to remind
# myself what they are for.

library(sp) # Classes and methods for spatial data
library(rgdal) # Access to projection/transformation operations
library(rgeos) # Manipulation and querying of spatial geometries
library(tidyverse) # For basic data manipulation
library(raster) # Works with spatial data primarily raster but also vector
library(tmap) # For mapping spatial data
library(tmaptools) #Additional tools for the tmap package
library(leaflet) #Open-source JavaScript libraries for interactive maps
library(RColorBrewer)  #Pre-packaged color pallettes

#  ---------------------------------------------------
## Reading Tabular Data into R


#  ---------------------------------------------------

#- working directory
#-- important concept for getting, and staying, organised with your files. 