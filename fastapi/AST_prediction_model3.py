from transformers import AutoProcessor
import librosa
import torch
from transformers import ASTModel
import numpy as np
import torch.nn.functional as F
import torch.nn as nn

class CustomASTClassifier(nn.Module):
    def __init__(self, config_path, num_labels):
        super().__init__()
        self.ast = ASTModel.from_pretrained(config_path)

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
    def __init__(self, audio_file, model_file, config):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        self.audio_path = audio_file
        self.audio, self.sr = librosa.load(self.audio_path, sr = 16000)
        self.processor = AutoProcessor.from_pretrained(config)
        self.model = CustomASTClassifier(config, num_labels=4)
        self.model.load_state_dict(torch.load(model_file, map_location=self.device))
        self.model.to(self.device)
        self.model.eval()
    
    def preprocess(self):
        input = self.processor(self.audio, sampling_rate=self.sr, return_tensor='pt')
        input_arr = np.array(input['input_values'])
        input_tensor = torch.tensor(input_arr, dtype=torch.float32)
        squeezed_input = input_tensor.squeeze(1).to(self.device)

        return squeezed_input
    
    def inference(self, input_val):
        with torch.no_grad():
            logits = self.model(input_val)
            probabilities = F.softmax(logits, dim=1)
            predicted_class = torch.argmax(probabilities, dim=1)
            prediction_values = probabilities

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
    model_path = './ast_classifer_lr0001.pth'
    config_path_prep = './ast-finetuned-audioset-10-10-0.4593'
    
    inf_init = Prep_and_Modeling(input_0, model_path, config_path_prep)
    input_inf = inf_init.preprocess()
    inf_result = inf_init.inference(input_inf)
    
    return inf_result
            
#audio_path = r'C:\Users\YJKIM_PC\aiffelton\sample_data\test.wav'
#model_path = r'C:\Users\YJKIM_PC\aiffelton\ast_classifer_lr0001.pth'
#config_path_prep = r'C:\Users\YJKIM_PC\aiffelton\ast-finetuned-audioset-10-10-0.4593'

#inf_init = Prep_and_Modeling(audio_path, model_path, config_path_prep)

#input_inf = inf_init.preprocess()
#inf_result = inf_init.inference(input_inf)
#print(inf_result)

# Paths to your audio and model files
# audio_path = r"C:\Users\dave\aiffel\EUANGGG\maincode\data\dataset\audioonly\labeled\original_dataset\belly_pain\69BDA5D6-0276-4462-9BF7-951799563728-1436936185-1.1-m-26-bp.wav"
# model_path = r"C:\Users\dave\aiffel\EUANGGG\maincode\data\experiment\ast_classifer_lr0001.pth"
# config_path_prep = r"C:\Users\dave\aiffel\ast-finetuned-audioset-10-10-0.4593"

# # Create an instance of your class
# inf_init = Prep_and_Modeling(audio_path, model_path, config_path_prep)

# # Preprocess the audio and perform inference
# input_inf = inf_init.preprocess()
# inf_result = inf_init.inference(input_inf)
# print(inf_result)