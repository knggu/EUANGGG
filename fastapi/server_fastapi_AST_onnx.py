# server_fastapi_AST.py
import uvicorn   # pip install uvicorn 
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware # 추가된부분 cors 문제 해결을 위한
from pydantic import BaseModel
from typing import Union
import io
from io import BytesIO
import base64
import librosa

# 예측 모듈 가져오기
import AST_onnx_prediction_model4

class PredictionRequest(BaseModel):
    input_string: str
        
class PredictionResponse(BaseModel):
    prediction: str
    success: bool
    error_message: Union[str, None] = None

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
    return "AST모델을 사용하는 API를 만들업 봅시다."

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
        #audio_bytes = base64.b64decode(base64_encoded_string)
        #audio_file = BytesIO(audio_bytes)
        
        audio_file = BytesIO(audio_bytes)

        prediction = await AST_onnx_prediction_model4.prediction_model(audio_file)
        print(prediction)
        #return prediction
        return PredictionResponse(prediction=prediction, success=True)
    except Exception as e:
        print(f"Error during prediction: {e}")
        #import traceback
        #traceback.print_exc()  # This will print the full traceback
        #raise HTTPException(status_code=500, detail=str(e))
        return PredictionResponse(success=False, error_message=str(e))


# Run the server
if __name__ == "__main__":
    uvicorn.run("server_fastapi_AST_onnx:app",
            reload= True,   # Reload the server when code changes
            host="127.0.0.1",   # Listen on localhost 
            port=5000,   # Listen on port 5000 
            log_level="info"   # Log level
            )