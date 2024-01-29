from transformers import AutoProcessor
import librosa
import torch
from tqdm import tqdm
from transformers import ASTModel
import numpy as np
import torch.nn.functional as F
import torch.nn as nn

class CustomASTClassifier(nn.Module):
    def __init__(self, ast_model_name, num_labels):
        super().__init__()
        self.ast = ASTModel.from_pretrained(ast_model_name)

        for param in self.ast.parameters():
            param.requires_grad = False

        self.classifier = nn.Linear(self.ast.config.hidden_size, num_labels)
        self.num_labels = num_labels

    def forward(self, input_values, labels=None):
        outputs = self.ast(input_values)
        embeddings = outputs.last_hidden_state
        logits = self.classifier(embeddings.mean(dim=1))
        
        if labels is not None:
            loss_fct = nn.CrossEntropyLoss()
            loss = loss_fct(logits.view(-1, self.num_labels), labels.view(-1))
            return loss, logits
        return logits

class Prep_and_Modeling():
    def __init__(self, audio_file, model_file):
        self.audio_path = audio_file
        self.audio, self.sr = librosa.load(self.audio_path, sr = 16000)
        self.processor = AutoProcessor.from_pretrained("MIT/ast-finetuned-audioset-10-10-0.4593")
        self.model = CustomASTClassifier(ast_model_name="MIT/ast-finetuned-audioset-10-10-0.4593", num_labels=4)
        self.model.load_state_dict(torch.load(model_file, map_location=torch.device('cpu')))
        self.model.eval()
    
    def preprocess(self):
        input = self.processor(self.audio, sampling_rate=self.sr, return_tensor='pt')
        input_arr = np.array(input['input_values'])
        input_tensor = torch.tensor(input_arr, dtype=torch.float32)
        squeezed_input = input_tensor.squeeze(1)

        return squeezed_input
    
    def inference(self, input_val):
        with torch.no_grad():
            logits = self.model(input_val)
            probabilities = F.softmax(logits, dim=1)
            predicted_class = torch.argmax(probabilities, dim=1)
            prediction_values = probabilities

            if predicted_class == torch.tensor([0]):
                return '복통'
            elif predicted_class == torch.tensor([1]):
                return '불편함'
            elif predicted_class == torch.tensor([2]):
                return '배고픔'
            else:
                return '피곤함'

# Paths to your audio and model files
# audio_path = r"C:\Users\dave\aiffel\EUANGGG\maincode\data\dataset\audioonly\labeled\original_dataset\belly_pain\69BDA5D6-0276-4462-9BF7-951799563728-1436936185-1.1-m-26-bp.wav"
# model_path = r"C:\Users\dave\aiffel\EUANGGG\maincode\data\experiment\ast_classifer_lr0001.pth"

# # Create an instance of your class
# inf_init = Prep_and_Modeling(audio_path, model_path)

# # Preprocess the audio and perform inference
# input_inf = inf_init.preprocess()
# inf_result = inf_init.inference(input_inf)
# print(inf_result)
