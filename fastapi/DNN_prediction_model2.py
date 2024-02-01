# DNN_prediction_model.py

# 예측에 필요한 라이브러리
import numpy as np
import librosa
import tensorflow_hub as hub
import tensorflow as tf
from io import BytesIO

class AudioPreprocess:
    def __init__(self, wav_file):
        try:
            # Check if wav_file is a BytesIO object or a file path
            if isinstance(wav_file, BytesIO):
                # If it's a BytesIO object, use it directly
                wav_file.seek(0)  # Reset file pointer to the start
                self.audio, self.sr = librosa.load(wav_file, sr=16000, mono=True, duration=5.2)
            else:
                # Otherwise, assume it's a file path
                self.audio, self.sr = librosa.load(wav_file, sr=16000, mono=True, duration=5.2)
        except Exception as e:
            print(f"Error loading audio file: {e}")
            self.audio, self.sr = None, None
            return
        
        self.model = hub.load('https://www.kaggle.com/models/google/yamnet/frameworks/TensorFlow2/variations/yamnet/versions/1')
        self.score, self.embeddings, self.spectrograms = self.model(self.audio)

        self.score_arr = np.array(self.score)
        self.embed_arr = np.array(self.embeddings)
        self.spectrogram_arr = np.array(self.spectrograms)

        self.arr_lst = [self.score_arr, self.embed_arr, self.spectrogram_arr]

    def reshape_arr(self, arr):
        score_size = self.score_arr.size
        embed_size = self.embed_arr.size
        spectrogram_size = self.spectrogram_arr.size

        avg_size = (score_size + embed_size + spectrogram_size) // 3
        flat_arr = arr.flatten()

        if arr.size < avg_size:
            padded_arr = np.pad(flat_arr, pad_width=(0, avg_size - arr.size), mode='constant', constant_values=0)
            return padded_arr
        else:
            truncated_arr = flat_arr[:avg_size]
            return truncated_arr
    
    def concat_arr(self):
        temp = [self.reshape_arr(arr) for arr in self.arr_lst]
        return np.expand_dims(np.concatenate(temp), axis=0)

class PredictProcess:
    
    def __init__(self, prep_data):
        try:
            
            self.input_data = prep_data

            self.model = tf.keras.models.load_model('DNN_ver_epo50_dr35.h5')

            self.predicted = self.model.predict(prep_data)

            self.index_pred = np.argmax(self.predicted)
            
             
        
        except Exception as e:

            print(f"Can't Predict Result: {e}")
            
            self.index_pred = None
            
        
    def labeling(self):

        class_labels = ['belly_pain', 'discomfort', 'hungry', 'tired']

        predicted_class_labels = class_labels[self.index_pred]

        return predicted_class_labels

async def prediction_model(input):
    model = tf.keras.models.load_model('./DNN_ver_epo50_dr35.h5')
    
    audio = AudioPreprocess(input)
    concat = audio.concat_arr()
    
    pred_audio = PredictProcess(concat)
    label_audio = pred_audio.labeling()
    
    return label_audio