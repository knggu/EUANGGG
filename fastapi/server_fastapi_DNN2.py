# server_fastapi_DNN.py
import uvicorn   # pip install uvicorn 
from fastapi import FastAPI   # pip install fastapi 
from fastapi.middleware.cors import CORSMiddleware # 추가된부분 cors 문제 해결을 위한
from pydantic import BaseModel
from typing import Union
from fastapi import HTTPException
import io
from io import BytesIO
import base64
import librosa
from fastapi import Request
import json

# 예측 모듈 가져오기
import DNN_prediction_model2

class PredictionRequest(BaseModel):
    input_string: str

# Create the FastAPI application
app = FastAPI()

# cors 이슈
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# A simple example of a GET request
@app.get("/")
async def read_root():
    print("url was requested")
    return "DNN모델을 사용하는 API를 만들업 봅시다."

@app.post("/predict")
async def predict(request: Request):
    try:
        base64_audio = await request.body()
        base64_audio = base64_audio.decode("utf-8")
        audio_bytes = base64.b64decode(base64_audio)
        
        #raw_json = await request.body()
        #json_string = raw_json.decode("utf-8")
        #data = json.loads(json_string)
        #raw_base = data['input_string']
        #audio_bytes = base64.b64decode(raw_base)
        
        #wav_file_path = './sample_data/test.wav'
        #with open(wav_file_path, 'rb') as wav_file:
        #    wav_data = wav_file.read()
        #base64_encoded_string = base64.b64encode(wav_data)#.decode('utf-8')
        #print(base64_encoded_string)
        #audio_bytes = base64.b64decode(base64_encoded_string)
        #audio_file = BytesIO(audio_bytes)
        
        audio_file = BytesIO(audio_bytes)
        
        #아래 코드는 조금 더 봐야할 것 같음
        #with open("temp.wav", "wb") as wav_file:
        #    wav_file.write(audio_file.getvalue())

        prediction = await DNN_prediction_model2.prediction_model(audio_file)
        print(prediction)
        return {"prediction": prediction}
    except Exception as e:
        print(f"Error during prediction: {e}")
        import traceback
        traceback.print_exc()  # This will print the full traceback
        raise HTTPException(status_code=500, detail=str(e))


# Run the server
if __name__ == "__main__":
    uvicorn.run("server_fastapi_DNN2:app",
            reload= True,   # Reload the server when code changes
            host="127.0.0.1",   # Listen on localhost 
            port=5000,   # Listen on port 5000 
            log_level="info"   # Log level
            )