# new test from http://thinktostart.com/analyze-face-emotions-r/

#####################################################################
# Load relevant packages
source(here::here("script","00_setup.R"))

# Define image source
#img.url   = 'https://www.dropbox.com/s/6jarb0t7dht47dd/image_000001.jpeg?dl=0'
#img.url <- "https://dangelodario.it/wp-content/uploads/2020/03/meloni-conte.jpg"
#img.url <- "https://drive.google.com/file/d/1iZ7wmcQvggYabFMiuj1qY3_bcVxdbkwv/view?usp=sharing"
#img.url <- "https://www.youtube.com/watch?v=T7_GJVbxGwM"
img.url <- "https://static.blitzquotidiano.it/wp/wp-content/uploads/2020/03/giorgia_meloni_ansa.jpg"

# Define Microsoft API URL to request data
#URL.emoface = 'https://api.projectoxford.ai/emotion/v1.0/recognize'
URL.emoface = file.path(endpoint,"face/v1.0/detect?detectionModel=detection_01&returnFaceId=true&returnFaceLandmarks=false&returnFaceAttributes=age,gender,headPose,smile,facialHair,glasses,emotion,hair,makeup,occlusion,accessories,blur,exposure,noise")

# Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/emotion-api)
emotionKEY = CHIAVE1

# Define image
mybody = list(url = img.url)

# Request data from Microsoft
faceEMO = POST(
  url = URL.emoface,
  content_type('application/json'),
  add_headers(.headers = c('Ocp-Apim-Subscription-Key' = emotionKEY)),
  body = mybody,
  encode = 'json'
)

# Show request results (if Status=200, request is okay)
faceEMO

# Reuqest results from face analysis
meloni = httr::content(faceEMO)[[1]]
meloni
meloni$faceAttributes$emotion
meloni$faceAttributes$hair
# Define results in data frame
o <- as.data.frame(as.matrix(meloni$faceAttributes$emotion))

# Make some transformation
o$V1 <- lapply(strsplit(as.character(o$V1 ), "e"), "[", 1)
o$V1<-as.numeric(o$V1)
colnames(o)[1] <- "Level"

# Define names
o$Emotion<- rownames(o)

o
# Make plot
ggplot(data=o, aes(x=Emotion, y=Level)) + geom_bar(stat="identity")

