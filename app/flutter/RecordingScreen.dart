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
        recoding_now = false;
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



/*
아래의 upload 코드에서는 'header' 매개변수를 사용하여 요청의 헤더에 'Content-Type: text/plain'을 추가하여 base64 형식으로
데이터를 전송한다. 필요에 따라 서버 측에서도 base64 형식을 처리할 수 있도록 구현이 필요하다.
또한 서버로부터 응답에 대한 결과를 받아서 터미널에 출력한다.


  Future<void> uploadAndDeleteRecording() async {       // added by 24-01-24
    try {
      // final url = Uri.parse('YOUR_SERVER_UPLOAD_URL');  // 실제 서버의 업로드 URL로 바꿔주세요
      // final url = Uri.parse('http://localhost:5000');    //  localhost로 TEST
      // final url = Uri.parse('http://127.0.0.1:5000');    //  localhost로 TEST
      // final url = Uri.parse('http://10.0.2.2:6000');    //  localhost로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      // final url = Uri.parse('http://192.168.0.104:6000');    // 실제 핸드폰에서 서버로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      final url = Uri.parse('https://bb26-222-106-39-138.ngrok-free.app/predict');    //  영진님것 ngrox 테스트 url, 일회성 주소이기 떄문에 계속해서 url이 바뀐다.

      final file = File(audioPath);
      if (!file.existsSync()) {
        print("UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
        return;
      }

      // AudioConverter를 사용하여 오디오 파일을 Base64 문자열로 변환
      String base64String = await AudioConverter().convertAudioFileToBase64String(audioPath);

      // 데이터를 JSON 형식으로 변환
      // String jsonData = jsonEncode({'audioBase64': base64String});

      // App에서 서버로 Data 송신 후에 이 부분에서 로딩 화면으로 이동 by 24-10-30
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => LoadingScreen()),
       );

      // HTTP POST 요청을 사용하여 base64 데이터를 서버로 전송
      final response = await http.post(
        url,
        headers: {'Content-Type': 'text/plain'},
        body: base64String,
      );

      print('Server Response: ${response.body}');  // 서버 응답 내용 확인 added by 24-01-25


      if (response.statusCode == 200) {
        // 업로드 성공 시 녹음 파일 삭제 및 UI 갱신
        const snackBar = SnackBar(
          content: Text('Audio uploaded.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          audioPath = "";
        });
      } else {
        // 업로드 실패 시 에러 처리
        print('Failed to upload audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error uploading audio: $e');
    }
  }

 */

// 아래의 upload 코드에서는 'header' 매개변수를 사용하여 요청의 헤더에 'Content-Type: application/json'을 추가하여 JSON 형식으로
// 데이터를 전송한다. 필요에 따라 서버 측에서도 JSON 형식을 처리할 수 있도록 구현이 필요하다.
// 또한 서버로부터 응답에 대한 결과를 받아서 터미널에 출력한다.

/*
  Future<void> uploadAndDeleteRecording() async {           // added by 24-01-24
    try {
      // final url = Uri.parse('YOUR_SERVER_UPLOAD_URL');   // 실제 서버의 업로드 URL로 바꿔주세요
      // final url = Uri.parse('http://localhost:8080');    //  localhost로 TEST
      // final url = Uri.parse('http://127.0.0.1:8080');    //  localhost로 TEST
      // final url = Uri.parse('http://10.0.2.2:5000');     //  localhost로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      // final url = Uri.parse('http://192.168.0.103:5000');    // 실제 핸드폰에서 서버로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      final url = Uri.parse('https://52e0-222-106-39-138.ngrok-free.app/predict');    //  영진님것 ngrox 테스트 url, 일회성 주소이기 떄문에 계속해서 url이 바뀐다.

      final file = File(audioPath);
      if (!file.existsSync()) {
        print("UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
        return;
      }

      // AudioConverter를 사용하여 오디오 파일을 Base64 문자열로 변환
      String base64String = await AudioConverter().convertAudioFileToBase64String(audioPath);

      // 데이터를 JSON 형식으로 변환
      // String jsonData = jsonEncode({'audioBase64': base64String});
      String jsonData = jsonEncode({'input_string': base64String});    // 영진님이 요청한 key값을 변경 TEST

      // HTTP POST 요청을 사용하여 JSON 데이터를 서버로 전송
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );

      print('Server Response: ${response.body}');  // 서버 응답 내용 확인


      if (response.statusCode == 200) {
        // 업로드 성공 시 녹음 파일 삭제 및 UI 갱신
        const snackBar = SnackBar(
          content: Text('Audio uploaded.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          audioPath = "";
        });
      } else {
        // 업로드 실패 시 에러 처리
        print('Failed to upload audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('Error uploading audio: $e');
    }
  }


import 'package:flutter/material.dart'; // 추가

Future<void> uploadAndDeleteRecording() async { // 24-01-24에 추가됨
  try {
    // 서버 업로드 URL로 변경하십시오.
    final url = Uri.parse('https://bb26-222-106-39-138.ngrok-free.app/predict'); // 영진의 ngrox 테스트 URL입니다. 주소가 계속 변경되기 때문에 일회성 주소입니다.

    final file = File(audioPath);
    if (!file.existsSync()) {
      print("UPLOADING FILE NOT EXIST++++++++++++++++++++++++++++++++++++++++++++++++++");
      return;
    }

    // AudioConverter를 사용하여 오디오 파일을 Base64 문자열로 변환합니다.
    String base64String = await AudioConverter().convertAudioFileToBase64String(audioPath);

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

    // 서버 응답이 "hungry"일 경우 HungryPage를 표시하는 함수 호출
    if (response.statusCode == 200 && response.body == 'hungry') {
      displayHungryPage(context); // 변경된 부분
    } else {
      // 업로드 실패 시 오류 처리
      print('Failed to upload audio. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // 예외 처리
    print('Error uploading audio: $e');
  }
}

// 로딩 화면을 표시하는 함수
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
    MaterialPageRoute(builder: (context) => HungryPage()),
  );
}

 */


/*
아래 upload코드에서 displayLoadingScreen 함수는 데이터를 서버로 전송하는 동안에 항상 호출되며,
서버 응답에 관계없이 항상 로딩 화면이 표시됩니다. 그 후 서버 응답을 확인하고,
응답이 "hungry"이면 displayHungryPage 함수가 호출되어 "hungry" 페이지를 표시합니다.
이렇게 변경하면 데이터를 서버에 전성후 항상 로딩 화면이 표시되고, 서버 응답에 따라 적절한 페이지가 표시된다  by 24-01-31

 */
  Future<void> uploadAndDeleteRecording() async {
    // 24-01-24에 추가됨
    try {
      // 서버 업로드 URL로 변경하십시오.
      final url = Uri.parse(
          'https://d4e1-222-106-39-138.ngrok-free.app/predict'); // 영진의 ngrox 테스트 URL입니다. 주소가 계속 변경되기 때문에 일회성 주소입니다.

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
    // else {
    // 예외 처리
    //print('Failed to upload audio. Status code: ${response.statusCode}');
  // }
// }







// 로딩 화면을 표시하는 함수
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
        recoding_now=true;
        File file = File(audioPath);
        if (file.existsSync()) {
          file.deleteSync();
          const snackBar = SnackBar(
            content: Text('Recoding deleted'),);
          print("FILE DELETED+++++++++++++++++++++++++++++++++++++++++++++++++");
        }
      } catch (e) {
        print("FILE NOT DELETED++++++++++++++++${e}+++++++++++++++++++++++++++++++++");
      }

      setState(() {
        audioPath = "";
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spacer(),
          SizedBox(height: 550),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              recoding_now            // record_now의 변수값이 true이면 IconButton(icon: const Icon(Icons.mic none))을 반환
                                      // record_now의 변수값이 false이면 IconButton(icon: const Icon(Icons.fiber_manual_record))을 반환
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
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 100),
                    onPressed: deleteRecording,
                  ),
                  IconButton(
                    icon: const Icon(Icons.trending_up, color: Colors.green, size: 100),
                    onPressed: uploadAndDeleteRecording,
                  ),
                ],
              ),
            ],
          ),
        ],
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
아래의 코드는 업로드 함수를 실행시킨 후 서버에 데이터를 보낸 후에 바로 로딩중 페이지를 표시하는 코드이다 by 24-01-30
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
                    color: Colors.lightGreen, // 외부 Container의 테두리 색상 변경
                    width: 8.0,  // 외부 Container의 테두리 두께 조절
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 80,  // CircularProgressIndicator의 크기를 조절
                    height: 80, // CircularProgressIndicator의 크기를 조절
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,  // CircularProgressIndicator의 테두리 두께 조절
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen), // CircularProgressIndicator의 테두리 색상 변경
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),  // 로딩 원과 텍스트 사이 간격 조절
            Text(
              '분석 중입니다',  // "Analyzing" 텍스트 표시
              style: TextStyle(fontSize: 48),  // 텍스트 크기 조절
            ),
          ],
        ),
      ),
    );
  }
}



