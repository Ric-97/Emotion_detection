##########################
# SPLIT VIDEO INTO PHOTO #
##########################

here::here("")

# SETUP
# Load  packages
source(here::here("script","00_setup.R"))
#---------------------------------------

mainDir <- file.path(here::here(""),"/foto")
video_path <- "video/test2-Draghi.mp4"
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
                         fps = 0.8)
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

