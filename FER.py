# Python at least 3.6 required

import streamlit as st
from fer import Video
from fer import FER
import cv2
#import sys
import pandas as pd
import tempfile
import time


# set the layout to wide
st.set_page_config(layout="wide")

# set the title for the app
col1, mid, col2 = st.columns([1,3,15])
with col1:
    st.image('logos/logo.png', width=200)
with col2:
    st.title("Video sentiment analysis")

st.write("Upload your .mp4 file then click on **START THE ANALYSIS**, please note that the time for analysis is about 1.5 times the length of the video")
uploaded_video = st.file_uploader("",type=['mp4'])

#vf = cv2.VideoCapture(tfile.name)

if uploaded_video is not None:
    #path = st.text_input('Path to your video', 'path\where\is\your\\video.mp4')
    bytes_data = uploaded_video.getvalue()
    tfile = tempfile.NamedTemporaryFile(delete=False)
    tfile.write(uploaded_video.read())
    video = st.video(uploaded_video, format="video/mp4", start_time=0)

# Put in the location of the video file that has to be processed
#location_videofile = "video/meloni_trim.mp4"

    button = st.button('START THE ANALYSIS')
    with st.spinner('Please wait till FER made the magic...'):
        if button:
            # Build the Face detector
            face_detector = FER(mtcnn=False) # mtcnn = True to use the more accurate MTCNN network (default  OpenCV's Haar Cascade classifier)

            # Input the video
            input_video = Video(tfile.name)

            # Use the Analyze() function: analysis made on every frame of the video. 
            # If display = True you can see the results of the analysis live
            processing_data = input_video.analyze(face_detector, display=False)

            # Extract the information 
            my_df = input_video.to_pandas(processing_data)
            vid_df = input_video.to_pandas(processing_data)
            vid_df = input_video.get_first_face(vid_df)
            vid_df = input_video.get_emotions(vid_df)

            # Plotting the emotions against time in the video
            st.write("**Plotting the emotions against time in the video**")
            pltfig = vid_df.plot(figsize=(20, 8), fontsize=16).get_figure()
            pltfig

            # Sum the emotions detected in the video
            angry = sum(vid_df.angry)
            disgust = sum(vid_df.disgust)
            fear = sum(vid_df.fear)
            happy = sum(vid_df.happy)
            sad = sum(vid_df.sad)
            surprise = sum(vid_df.surprise)
            neutral = sum(vid_df.neutral)

            emotions = ['Angry', 'Disgust', 'Fear', 'Happy', 'Sad', 'Surprise', 'Neutral']
            emotions_values = [angry, disgust, fear, happy, sad, surprise, neutral]

            score_comparisons = pd.DataFrame(emotions, columns = ['Emotions'])
            score_comparisons['Emotion Sum from all the frames'] = emotions_values
            score_comparisons
            
            #DOWNLOAD BUTTON FOR DATASET
            @st.cache
            def convert_df(df):
                # IMPORTANT: Cache the conversion to prevent computation on every rerun
                return df.to_csv().encode('utf-8')

            csv = convert_df(my_df)

            st.write("**ATTENTION YOU CAN DOWNLOAD THE DATA ONLY ONCE, AFTER THE CLICK YOU MUST RERUN THE ANALYSIS**")
            st.download_button(
                label="Download the entire dataset as CSV",
                data=csv,
                file_name='sentiment_data.csv',
                mime='text/csv',
            )
            end = "end"
            if end == "end":
                st.balloons()

    st.success("Done!")
