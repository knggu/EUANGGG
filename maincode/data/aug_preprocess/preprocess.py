import numpy as np
import librosa
import tensorflow_hub as hub

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

# audio = AudioPreprocess(r"C:\Users\dave\aiffel\EUANGGG\maincode\data\dataset\audioonly\labeled\set 1\train\belly_pain\643D64AD-B711-469A-AF69-55C0D5D3E30F-1430138506-1.0-m-72-bp.wav")
# concat = audio.concat_arr()
# print(concat.shape)
