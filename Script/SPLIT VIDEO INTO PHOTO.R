##########################
# SPLIT VIDEO INTO PHOTO #
##########################


# HELP: https://www.r-bloggers.com/2019/03/human-face-detection-with-r/
# HELP: http://thinktostart.com/analyze-face-emotions-r/
# HELP: https://docs.ropensci.org/magick/articles/intro.html

# installare Cmake --> fatto
# installare Rtools --> fatto
# installare ROpenCVLite --> fatto
# installare OpenCV --> Fatto
# installare Rvision --> da fare
# devtools::install_github("swarm-lab/Rvision")
# install.packages("av")
# install.packages("magick")
# install.packages("image.libfacedetection")#, repos = "https://bnosac.github.io/drat")
# install.packages("XML")
# install.packages("ggplot2")
 
 #setwd("C:/Users/Riccardo/Desktop/Emotion detection/Emotion_detection")
here::here("")

# SETUP
# Load relevant packages
library(tools)
library("httr")
library("XML")
library("stringr")
library("ggplot2")
library(av)
library(magick)
library(image.libfacedetection)
library(Rvision)
#help(image_reAD)

#---------------------------------------

mainDir <- file.path(here::here(""),"/foto")
video_path <- "video/meloni_Trim.mp4"
subDir <- file_path_sans_ext(basename(video_path))

if (file.exists(subDir)){
  destdir = file.path(mainDir, subDir)
} else {
  dir.create(file.path(mainDir, subDir))
  destdir = file.path(mainDir, subDir)
}

#--------------------

# CONVERT THE VIDEO INTO SINGLE PHOTO-FRAME

fotos <- av_video_images(video_path,
                         destdir = destdir,
                         format = "jpg",
                         fps = 0.5)
fotos

#-------------------------------------------------


# DETECT THE FACES FROM THE PHOTOS

foto <- fotos[1:50] # TRY WITH LESS PHOTOS
foto

#image <- image_read(foto[1])
#faces <- image_detect_faces(image)
#faces
#plot(faces, image, border = "red", lwd = 7, col = "white")

# TRY LOOPING THE EXTRACTION OF A FACE FROM MULTIPLE PHOTOS
for (i in fotos) {
  image <- image_read(i)
  faces <- image_detect_faces(image)
  plot(faces, image, border = "red", lwd = 7, col = "white")
}



# CROP MULTIPLE FACES FROM AN IMAGE
allfaces <- Map(
  x      = faces$detections$x,
  y      = faces$detections$y,
  width  = faces$detections$width,
  height = faces$detections$height,
  f = function(x, y, width, height){
    image_crop(image, geometry_area(x = x, y = y, width = width, height = height))
  })
allfaces <- do.call(c, allfaces)
allfaces

