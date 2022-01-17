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
 
 setwd("C:/Users/Riccardo/Desktop/Emotion detection")

# SETUP
# Load relevant packages
library("httr")
library("XML")
library("stringr")
library("ggplot2")
library(av)
library(magick)
library(image.libfacedetection)
library(Rvision)
#help(image_reAD)

# CONVERT THE VIDEO INTO SINGLE PHOTO-FRAME
video.path <- "C:/Users/Riccardo/Desktop/Emotion detection/test2-Draghi.mp4"
fotos <- av_video_images(video.path,
                destdir = "C:/Users/Riccardo/Desktop/Emotion detection/foto",
                format = "jpg",
                fps = NULL)
fotos

#foto.folder <- ("C:/Users/Riccardo/Desktop/Emotion detection/foto")

# DETECT THE FACES FROM THE PHOTOS

foto <- fotos[1:50] # TRY WITH LESS PHOTOS
foto

#image <- image_read(foto[1])
#faces <- image_detect_faces(image)
#faces
#plot(faces, image, border = "red", lwd = 7, col = "white")

# TRY LOOPING THE EXTRACTION OF A FACE FROM MULTIPLE PHOTOS
for (i in foto) {
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


#------------------
#EMOTION DETECTION


# Define image source
# img.url     = 'https://www.whitehouse.gov/sites/whitehouse.gov/files/images/first-family/44_barack_obama[1].jpg'
img.url     = foto[25]
# Define Microsoft API URL to request data
URL.emoface = 'https://api.projectoxford.ai/emotion/v1.0/recognize'

# Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/emotion-api)
emotionKEY = 'XXXX'

# Define image
mybody = list(url = img.url)

# Request data from Microsoft
faceEMO = POST(
  url = URL.emoface,
  content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = emotionKEY)),
  body = mybody,
  encode = 'json'
)

# Show request results (if Status=200, request is okay)
faceEMO

# Reuqest results from face analysis
Obama = httr::content(faceEMO)[[1]]
Obama
# Define results in data frame
o <- as.data.frame(as.matrix(Obama$scores))

# Make some transformation
o$V1 <- lapply(strsplit(as.character(o$V1 ), "e"), "[", 1)
o$V1<-as.numeric(o$V1)
colnames(o)[1] <- "Level"

# Define names
o$Emotion<- rownames(o)

# Make plot
ggplot(data=o, aes(x=Emotion, y=Level)) +
  geom_bar(stat="identity")

#####################################################################
# Define image source
img.url = 'https://www.whitehouse.gov/sites/whitehouse.gov/files/images/first-family/44_barack_obama[1].jpg'

# Define Microsoft API URL to request data
faceURL = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=true&returnFaceAttributes=age"

# Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/face-api)
faceKEY = 'XXXXX'

# Define image
mybody = list(url = img.url)

# Request data from Microsoft
faceResponse = POST(
  url = faceURL, 
  content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = faceKEY)),
  body = mybody,
  encode = 'json'
)

# Show request results (if Status=200, request is okay)
faceResponse

# Reuqest results from face analysis
ObamaR = httr::content(faceResponse)[[1]]

# Define results in data frame
OR<-as.data.frame(as.matrix(ObamaR$faceLandmarks))

# Make some transformation to data frame
OR$V2 <- lapply(strsplit(as.character(OR$V1), "\\="), "[", 2)
OR$V2 <- lapply(strsplit(as.character(OR$V2), "\\,"), "[", 1)
colnames(OR)[2] <- "X"
OR$X<-as.numeric(OR$X)

OR$V3 <- lapply(strsplit(as.character(OR$V1), "\\y = "), "[", 2)
OR$V3 <- lapply(strsplit(as.character(OR$V3), "\\)"), "[", 1)
colnames(OR)[3] <- "Y"
OR$Y<-as.numeric(OR$Y)

OR$V1<-NULL