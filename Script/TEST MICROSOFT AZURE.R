# TEST MICROSOFT AZURE
library(httr)

# Load httr package
loadNamespace("httr")

# Set an endpoint for Emotion in Video API with 'perFrame' output
apiUrl <- "https://emo-viso.cognitiveservices.azure.com/"
#apiURL <- "https://api.projectoxford.ai/emotion/v1.0/recognizeInVideo?outputStyle=perFrame"

# Set your API key for Emotion API
key <- CHIAVE1

# Set URL for accessing to the video.
urlVideo <- 'https://www.dropbox.com/s/49udzcgxph0mnzj/meloni_Trim.mp4?dl=0'
mybody <- list(url = urlVideo)
mybody

# Request data from Microsoft AI
faceEMO <- httr::POST(
  url = apiUrl,
  httr::content_type('application/json'),
  httr::add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)),
  body = mybody,
  encode = 'json'
)

# Get the location where the result is stored.
operationLocation <- httr::headers(faceEMO)[["operation-location"]]

operationLocation

# Getting the emotion scored data from Microsoft AI

while(TRUE) {
  ret <- httr::GET(operationLocation,
                   httr::add_headers(.headers = c('Ocp-Apim-Subscription-Key' = key)))
  con <- httr::content(ret)
  
  if(is.null(con$status)){
    warning("Connection Error, retry after 1 minute")
    Sys.sleep(60)
  } else if (con$status == "Running" | con$status == "Uploading"){
    cat(paste0("status ", con$status, "\n"))
    cat(paste0("progress ", con$progress, "\n"))
    Sys.sleep(60)
  } else {
    cat(paste0("status ", con$status, "\n"))
    break()
  }
}

data <- (con$processingResult %>% jsonlite::fromJSON())$fragments

# data$events is list of events that has data.frame column,
# so it has to be flatten in this loop
data$events <- purrr::map(data$events, function(events){
  events %>% purrr::map(function(event){
    jsonlite::flatten(event)
  }) %>% bind_rows()
})

data
