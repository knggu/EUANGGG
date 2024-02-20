import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';  // by 24-01-22
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';  // by 24-01-22
import 'package:flutter/material.dart';         // by 24-01-30
import 'hungry.dart';
import 'dart:async';
import 'colic.dart';
import 'inconvenience.dart';
import 'tired.dart';



class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = "";

  // var recording_now;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioRecord = Record();
  }

  @override
  void dispose() {
    super.dispose();
    audioRecord.dispose();
    audioPlayer.dispose();
  }

  bool playing = false;




  Future<void> startRecording() async {

    try {
      if (await audioRecord.hasPermission()) {
        // Get the directory where you want to save the recording
        final directory = await getApplicationDocumentsDirectory();
        String downloadPath = '/storage/emulated/0/Download';
        String customPath = '${downloadPath}/myrecording${DateTime
            .now()
            .millisecondsSinceEpoch}.wav';

        // Start recording
        // await audioRecord.start(path: customPath); // Specify the path
        await audioRecord.start(
            path: customPath, encoder: AudioEncoder.wav); // added by 24-01-29
        setState(() {
          isRecording = true;
          audioPath = customPath; // Update audioPath with the new path
        });
      }
    } catch (e, stackTrace) {
      print("Error starting recording: $e, stackTrace: $stackTrace");
    }
  }


// 아래 코드는 위의 stopRecording 함수를 대체하여 녹음을 멈춘 후에 AudioConverter 클래스를 사용하여 스트림 변환을 추가함 by added 24-01-23
  Future<void> stopRecording() async {
    try {
      print("STOP RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
      String? path = await audioRecord.stop();
      setState(() {
        recoding_now  = false;
        isRecording = false;
        audioPath = path!;
      });

      // 추가된 부분: 녹음된 음성 파일이 정확히 어디에 저장되었는지 알려주는 출력 코드  // added by 24-01-26
      print("audioPath: $audioPath");

      // print(Uri.base);  // added by 24-01-26

      // 추가한 부분: 출력 코드, 녹음한 음성 파일이 구체적으로 어디에 저장되는지를 알려주는 print문임
      print("audioPath: $audioPath");

      // 오디오 파일을 변환하여 Base64 문자열로 가져오기
      String base64String = await AudioConverter()
          .convertAudioFileToBase64String(
          audioPath); // 실제 변환된 base64 문자열을 파일로 저장하지는 않음

      // 변환된 Base64 문자열 사용 예시
      print("Base64 문자열: $base64String");
    } catch (e) {
      print(
          "STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
    }
  }


  Future<void> playRecording() async {
    try {
      playing = true;
      setState(() {});

      print("AUDIO PLAYING+++++++++++++++++++++++++++++++++++++++++++++++++");
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
      // Add an event listener to be notified when the audio playback completes
      audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        if (state == PlayerState.completed) {
          playing = false;


          print(
              "AUDIO PLAYING ENDED+++++++++++++++++++++++++++++++++++++++++++++++++");
          setState(() {});
        }
      });
    } catch (e) {
      print(
          "AUDIO PLAYING++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
    }
  }

  Future<void> pauseRecording() async {
    try {
      playing = false;

      print("AUDIO PAUSED+++++++++++++++++++++++++++++++++++++++++++++++++");

      await audioPlayer.pause();
      setState(() {

      });
      //print('Hive Playing Recording ${voiceRecordingsBox.values.cast<String>().toList().toString()}');
    } catch (e) {
      print(
          "AUDIO PAUSED++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
    }
  }


  Future<void> uploadAndDeleteRecording() async {

    try {
      // 서버 업로드 URL로 변경하십시오.
      final url = Uri.parse(
          'https://fa52-115-88-5-94.ngrok-free.app/predict'); // 영진의 ngrox 테스트 URL입니다. 주소가 계속 변경되기 때문에 일회성 주소입니다.
      final file = File(audioPath);
      if (!file.existsSync()) {
        print(
            "UPLOADING FILE NOT EXIST++++++++++++++++++++++++++++++++++++++++++++++++++");
        return;
      }

      // AudioConverter를 사용하여 오디오 파일을 Base64 문자열로 변환합니다.
      String base64String = await AudioConverter()
          .convertAudioFileToBase64String(audioPath);

      // 데이터를 JSON 형식으로 변환
      // String jsonData = jsonEncode({'audioBase64': base64String});

      // 데이터를 서버로 보낸 후, 로딩 화면으로 이동합니다. 24-10-30에 추가
      displayLoadingScreen(context); // 변경된 부분

      // HTTP POST 요청을 사용하여 base64 데이터를 서버로 보냅니다.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'text/plain'},
        body: base64String,
      );

      print('Server Response: ${response.body}'); // 서버 응답 내용 확인 24-01-25에 추가

      // 로딩 화면 이동 후 서버 응답에 상관없이 항상 실행되는 코드
      setState(() {
        audioPath = "";
      });

      // 아래의 코드는 상태 코드가 200인지 확인 후에 디코드한 JSON의 문자열이 "hungry"인지 확인 후에 조건이 참인 경우 hungry.dart 페이지를 표시한다.
      final data = jsonDecode(
          response.body); // else if 문이 data 변수를 참조할 수 있게 if 문 밖으로 이동시킴.

      if (response.statusCode == 200) {
        print('Prediction: ${data['prediction']}');
        print('Sucess: ${data['success']}');
        print('Error Message: ${data['error_message']}');

        //Check if the decoded JSON data is the string "hungry"
        if (data['prediction'] == 'hungry') {
          print('The prediction is hungry');
          // }
          // else <-- 왜 있는지? 있어도 아래의 Navigator이 실행된다. 왜?
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => hungry()), // 변경된 부분
          );
        } else if (data['prediction'] == 'bellypain') {
          print('The prediction is bellypain');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => colic()), // 변경된 부분
          );
        } else if (data['prediction'] == 'discomfort') {
          print('The prediction is discomfort');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => inconvenience()), // 변경된 부분
          );
        } else if (data['prediction'] == 'tired') {
          print('The prediction is tired');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => tired()), // 변경된 부분
          );
          /*
          else {
          // 예외 처리
          print('Failed to upload audio. Status code: ${response.statusCode}');
        }
        */
        }
      }
    } catch (e) { // 예외 처리
      print('Error uploading audio: $e');
    }
  }


  void displayLoadingScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );
  }

// "hungry.dart" 페이지를 표시하는 함수
  void displayHungryPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => hungry()),
    );
  }


  Future<void> deleteRecording() async {
    if (audioPath.isNotEmpty) {
      try {
        recoding_now = true;
        File file = File(audioPath);
        if (file.existsSync()) {
          file.deleteSync();
          const snackBar = SnackBar(
            content: Text('Recoding deleted'),);
          print(
              "FILE DELETED+++++++++++++++++++++++++++++++++++++++++++++++++");
        }
      } catch (e) {
        print(
            "FILE NOT DELETED++++++++++++++++${e}+++++++++++++++++++++++++++++++++");
      }

      setState(() {
        audioPath = "";
      });
    }
  }




// Below code represents normal picture, white blank, customized text also function Elevated button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // const Text('Voice Recorder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: Column(
              children: [
                Image.asset(
                  'images/Mic.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 100), // 그림 파일 표시
                Text(
                  "아이 울음 소리를",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black26),
                ), // 텍스트 표시
                Text(
                  "담아주세요",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black26),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              recoding_now
                  ? IconButton(
                icon: !isRecording
                    ? const Icon(Icons.mic_none, color: Colors.red, size: 100)
                    : const Icon(Icons.fiber_manual_record, color: Colors.red, size: 100),
                onPressed: isRecording ? stopRecording : startRecording,
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: !playing
                        ? Icon(Icons.play_circle, color: Colors.green, size: 100)
                        : Icon(Icons.pause_circle, color: Colors.green, size: 100),
                    onPressed: !playing ? playRecording : pauseRecording,
                  ),
                  // IconButton(
                  // icon: const Icon(Icons.delete, color: Colors.red, size: 100),
                  // onPressed: deleteRecording,
                  // ),
                  IconButton(
                    icon: const Icon(Icons.trending_up, color: Colors.green, size: 100),
                    onPressed: uploadAndDeleteRecording,
                  ),
                ],
              ),
            ],
          ),
        ], // children 속성에 중괄호 안에 위젯 목록을 전달합니다.
      ),
    );
  }
  bool recoding_now = true;
}




// 아래 코드는 오디오 파일을 스트림으로 바꾸고 다시 bas64로 포맷으로 변환하는 코드임
class AudioConverter {
  String recordingPath = '/storage/emulated/0/Download';  // 녹음 파일이 저장될  저장될 결로를 저장하는 변수 add by 24-01-23
  
  AudioConverter(); // 기본 생성자 added by 23-01-23

  void set RecordingPath(String newPath) {
    recordingPath = newPath;
  }
  
  Future<String> convertAudioFileToBase64String(String filePath) async {
    // Read the file
    File audioFile = File(filePath);

    // Convert it to bytes
    List<int> fileBytes = await audioFile.readAsBytes();

    // Encode the bytes to Base64 string
    String base64String = base64Encode(fileBytes);

    return base64String;
  }
}



/*
아래의 코드는 업로드 함수를 실행시킨 후 서버에 데이터를 보낸 후에 바로 로딩중 페이지를 표시하는 코드이다
 */

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox.shrink(), // 타이틀 숨기기
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 외부 Container에 테두리를 그리고, 내부의 CircularProgressIndicator는 테두리를 비워두고 회전
            SizedBox(
              width: 100,  // 원의 크기 조절
              height: 100, // 원의 크기 조절
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent, // 로딩 원의 내부를 비우기
                  border: Border.all(
                    color: Colors.lightGreenAccent, // 외부 Container의 테두리 색상 변경
                    width: 8.0,  // 외부 Container의 테두리 두께 조절
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 80,  // CircularProgressIndicator의 크기를 조절
                    height: 80, // CircularProgressIndicator의 크기를 조절
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,  // CircularProgressIndicator의 테두리 두께 조절
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent), // CircularProgressIndicator의 테두리 색상 변경
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),  // 로딩 원과 텍스트 사이 간격 조절
            Text('분석 중입니다',  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color:Colors.black26),
            ),
          ],
        ),
      ),
    );
  }
}



