import numpy as np
import librosa
import tensorflow_hub as hub
import tensorflow as tf

class AudioPreprocess:
    def __init__(self, wav_file):
        try:
            self.audio, self.sr = librosa.load(wav_file, sr=16000, mono=True, duration=5.2)
        except Exception as e:
            print(f"Error loading audio file: {e}")
            self.audio, self.sr = None, None
            return

        self.model = hub.load('https://tfhub.dev/google/yamnet/1')
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
        return np.concatenate(temp)


class PredictProcess:
    
    def __init__(self, prep_data):
        try:
            
            input_data = prep_data

            model = tf.keras.models.load_model('DNN_ver_epo50_dr35.h5')

            predicted = model.predict(prep_data)

            index_pred = np.argmax(predicted)
            
            return 
        
        except Exception as e:

            print(f"Can't Predict Result: {e}")
            
            index_pred = None
            
            return
        
    def labeling(self, index_num):

        class_labels = ['belly_pain', 'discomfort', 'hungry', 'tired']

        predicted_class_labels = class_labels[index_num]

        return predicted_class_labels
    
# audio = AudioPreprocess(r"C:/Users/Desk_Kang/Desktop/Aiffel/workplace/lib/Aiffelthon/data3/train\belly_pain\belly_pain (1).wav")
# concat = audio.concat_arr()
# print(concat.shape)
    
# pred_audio = PredictProcess(concat)
