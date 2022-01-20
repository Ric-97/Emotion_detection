# SETUP REQUIREMENTS


want <- c("tools","httr","XML", "stringr", "ggplot2",
          "av","magick","image.libfacedetection","Rvision")  # list of required packages
have <- want %in% rownames(installed.packages())
if ( any(!have) ) { install.packages( want[!have] ) }
rm(have, want)

library(tools)
library("httr")
library("XML")
library("stringr")
library("ggplot2")
library(av)
library(magick)
library(image.libfacedetection)
library(Rvision)
