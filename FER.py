# Python at least 3.6 required

import streamlit as st
from fer import Video
from fer import FER
#import sys
import pandas as pd

# set the layout to wide
st.set_page_config(layout="wide")

# set the title for the app
col1, mid, col2 = st.columns([1,3,20])
with col1:
    st.image('logos/logo.png', width=200)
#with col2:
    #st.title("iDry")

uploaded_video = st.file_uploader("")
if uploaded_video is not None:
     bytes_video = uploaded_video.getvalue()

st.video(uploaded_video, format="video/mp4", start_time=0)

# Put in the location of the video file that has to be processed
#location_videofile = "video/meloni_trim.mp4"

button = st.button('Start analysis')
if button:
    # Build the Face detection detector
    face_detector = FER(mtcnn=True) # mtcnn = True to use the more accurate MTCNN network (default  OpenCV's Haar Cascade classifier)
    # Input the video for processing
    input_video = Video(bytes_video)

    # The Analyze() function will run analysis on every frame of the input video. 
    # It will create a rectangular box around every image and show the emotion values next to that.
    # Finally, the method will publish a new video that will have a box around the face of the human with live emotion values.
    processing_data = input_video.analyze(face_detector, display=False)

    # We will now convert the analysed information into a dataframe.
    # This will help us import the data as a .CSV file to perform analysis over it later
    vid_df = input_video.to_pandas(processing_data)
    vid_df = input_video.get_first_face(vid_df)
    vid_df = input_video.get_emotions(vid_df)

    # Plotting the emotions against time in the video
    pltfig = vid_df.plot(figsize=(20, 8), fontsize=16).get_figure()

    # We will now work on the dataframe to extract which emotion was prominent in the video
    angry = sum(vid_df.angry)
    disgust = sum(vid_df.disgust)
    fear = sum(vid_df.fear)
    happy = sum(vid_df.happy)
    sad = sum(vid_df.sad)
    surprise = sum(vid_df.surprise)
    neutral = sum(vid_df.neutral)

    emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Sad', 'Surprise', 'Neutral']
    emotions_values = [angry, disgust, fear, happy, sad, surprise, neutral]

    score_comparisons = pd.DataFrame(emotions, columns = ['Human Emotions'])
    score_comparisons['Emotion Value from the Video'] = emotions_values
    score_comparisons
