# Emotion_detection

### SCOPE
The aim of this project is to investigate the gender stereotypes present in the communication styles made by the main Italian politicians.

### ANALYSIS
The analysis will be conducted by exploiting the potential of facial recognition and emotional recognition algorithms by analyzing video interviews and television appearances of Italian politicians.
A sample of photos will be extracted from each video and the frequency of emotions will be counted considering for each photo the two emotions with the greatest confidence and, in this way, the presence or absence of gender stereotypes in the communicative style will be verified.

### INSTRUCTIONS

- Install **python 3.6**
- install virtual env --> **python -m pip install --user virtualenv**
- create new environment --> **python -m venv name_of_env**
- activate new env --> **.\name_of_env\Scripts\activate**
- install all the packages needed for the project --> **pip3 install -r requirements.txt**
- Ignore warnings for **pip updates**
- set the path where is stored your video in **location_videofile** inside FER.py (line 9)
- run --> **python FER.py**
