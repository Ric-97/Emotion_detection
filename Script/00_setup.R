# SETUP REQUIREMENTS


want <- c("tools","httr","XML", "stringr", "ggplot2","jpeg",
          "av","magick","image.libfacedetection","Rvision","imager","igraph")  # list of required packages
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
library(jpeg)
library(imager)

source("script\\tokens.R")
