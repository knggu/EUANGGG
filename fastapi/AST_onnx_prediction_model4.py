from transformers import AutoProcessor
import librosa
import torch
from transformers import ASTModel
import numpy as np
import torch.nn.functional as F
import torch.nn as nn
import onnx
import onnxruntime as ort

class Prep_and_Onnx():
    def __init__(self, audio_file, model_path, config):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.audio_path = audio_file
        self.audio, self.sr = librosa.load(self.audio_path, sr = 20000)
        self.processor = AutoProcessor.from_pretrained(config)
        self.ort_session = ort.InferenceSession(model_path)

    def preprocess(self):
        input_audio = self.processor(self.audio, sampling_rate=self.sr, return_tensor='pt')
        input_arr = np.array(input_audio['input_values'])
    
        return input_arr

    def inference(self, input_val):
        with torch.no_grad():
            outputs = self.ort_session.run(None, {"modelInput":input_val})
            probabilities = F.softmax(torch.tensor(outputs[0][0]), dim=0)
            predicted_class = torch.argmax(probabilities)

        if predicted_class == torch.tensor([0]).to(self.device):
            return 'bellypain'
        elif predicted_class == torch.tensor([1]).to(self.device):
            return 'discomfort'
        elif predicted_class == torch.tensor([2]).to(self.device):
            return 'hungry'
        else:
            return 'tired'

async def prediction_model(input_0):
    #model = tf.keras.models.load_model('./ast_classifer_lr0001.pth')
    model_path = './ASTClassifier_fin.onnx'
    config_path_prep = './ast-finetuned-audioset-10-10-0.4593'
    
    inf_init = Prep_and_Onnx(input_0, model_path, config_path_prep)
    input_inf = inf_init.preprocess()
    inf_result = inf_init.inference(input_inf)
    
    return inf_result

