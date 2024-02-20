from torch.utils.data import Dataset
import numpy as np
from transformers import AutoProcessor
import librosa

class AudioPipeline(Dataset):
    def __init__(self, audio_paths, audio_labels, sr=20000, transform=None):
        self.transform = transform
        self.sr = sr
        self.audio_labels = audio_labels
        self.audio_paths = audio_paths
        self.processor = AutoProcessor.from_pretrained("MIT/ast-finetuned-audioset-10-10-0.4593", sampling_rate=self.sr)
                
    def __len__(self):
        return len(self.audio_paths)

    def __getitem__(self, idx):
        audio_path = self.audio_paths[idx]
        label = self.audio_labels[idx]
        waveform, _ = librosa.load(audio_path, sr=self.sr, duration=6.0)
        if waveform.shape[0] < 120000:
            waveform = librosa.util.fix_length(waveform, size=120000)

        if self.transform != None:
            waveform = self.transform(waveform, sample_rate=self.sr)
            waveform = self.processor(waveform, sampling_rate=self.sr, return_tensor='pt')
            return waveform['input_values'][0], label
        elif self.transform == None:
            waveform = self.processor(waveform, sampling_rate=self.sr, return_tensor='pt')
            return waveform['input_values'][0], label