import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';  // by 24-01-22
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';  // by 24-01-22

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
  bool playing=false;


  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        // Get the directory where you want to save the recording
        final directory = await getApplicationDocumentsDirectory();
        String downloadPath = '/storage/emulated/0/Download';
        String customPath = '${downloadPath}/myrecording${DateTime.now().millisecondsSinceEpoch}.wav';

        // Start recording
        await audioRecord.start(path: customPath); // Specify the path
        setState(() {
          isRecording = true;
          audioPath = customPath; // Update audioPath with the new path
        });
      }
    } catch (e, stackTrace) {
      print("Error starting recording: $e, stackTrace: $stackTrace");
    }
  }


/*
  Future<void> stopRecording() async {
    try {
      print("STOP RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
      String? path = await audioRecord.stop();
      setState(() {
        recoding_now=false;
        isRecording = false;
        audioPath = path!;
      });

      // 추가한 부분: 출력 코드, 녹음한 음성 파일이 구체적으로 어디에 저장되는지를 알려주는 print문임
      print("audioPath: $audioPath");

    } catch (e) {
      print("STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
    }
  }

 */

// 아래 코드는 위의 stopRecording 함수를 대체하여 녹음을 멈춘 후에 AudioConverter 클래스를 사용하여 스트림 변환을 추가함 by added 24-01-23
  Future<void> stopRecording() async {
    try {
      print("STOP RECODING+++++++++++++++++++++++++++++++++++++++++++++++++");
      String? path = await audioRecord.stop();
      setState(() {
        recoding_now=false;
        isRecording = false;
        audioPath = path!;
      });

      // 추가된 부분: 녹음된 음성 파일이 정확히 어디에 저장되었는지 알려주는 출력 코드  // added by 24-01-26
      print("audioPath: $audioPath");

      // print(Uri.base);  // added by 24-01-26

      /*
      // Windows 11에서 전체 경로를 출력하도록 수정
      if (Platform.isWindows) {
       // String packageName = "{앱 패키지 이름}"; // 실제 패키지 이름으로 대체
        String fullPath = audioPath.replaceAll("/storage/emulated/0/", "C:\\Users\\asus\\AppData\\Local\\Packages\\$packageName\\LocalState\\");
        print("Full Windows Path: $fullPath");
      }
      */

      // 추가한 부분: 출력 코드, 녹음한 음성 파일이 구체적으로 어디에 저장되는지를 알려주는 print문임
      print("audioPath: $audioPath");

      // 오디오 파일을 변환하여 Base64 문자열로 가져오기
      String base64String = await AudioConverter().convertAudioFileToBase64String(audioPath); // 실제 변환된 base64 문자열을 파일로 저장하지는 않음

      // 변환된 Base64 문자열 사용 예시
      print("Base64 문자열: $base64String");

    } catch (e) {
      print("STOP RECODING+++++++++++++++++++++${e}+++++++++++++++++++++++++++");
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


          print("AUDIO PLAYING ENDED+++++++++++++++++++++++++++++++++++++++++++++++++");
          setState(() {});
        }
      });

    } catch (e) {
      print("AUDIO PLAYING++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
    }
  }

  Future<void> pauseRecording() async {
    try {
      playing=false;

      print("AUDIO PAUSED+++++++++++++++++++++++++++++++++++++++++++++++++");

      await audioPlayer.pause();
      setState(() {

      });
      //print('Hive Playing Recording ${voiceRecordingsBox.values.cast<String>().toList().toString()}');
    } catch (e) {
      print("AUDIO PAUSED++++++++++++++++++++++++${e}+++++++++++++++++++++++++");
    }
  }

/*
  Future<void> uploadAndDeleteRecording() async {
    try {
      final url = Uri.parse('YOUR_UPLOAD_URL'); // Replace with your server's upload URL

      final file = File(audioPath);
      if (!file.existsSync()) {
        print("UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
        return;
      }
      print("UPLOADING FILE ++++++++++++++++${audioPath}+++++++++++++++++++++++++++++++++");
      final request = http.MultipartRequest('POST', url)
        ..files.add(
          http.MultipartFile(
            'audio',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: 'audio.mp3', // You may need to adjust the file extension
          ),
        );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // Upload successful, you can delete the recording if needed
        // Show a snackbar or any other UI feedback for a successful upload
        const snackBar = SnackBar(
          content: Text('Audio uploaded.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Refresh the UI
        setState(() {
          audioPath = "";
        });
      } else {
        // Handle the error or show an error message
        print('Failed to upload audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading audio: $e');
    }
  }

*/


// 아래의 upload 코드에서는 'header' 매개변수를 사용하여 요청의 헤더에 'Content-Type: text/plain'을 추가하여 base64 형식으로
// 데이터를 전송한다. 필요에 따라 서버 측에서도 base64 형식을 처리할 수 있도록 구현이 필요하다.
// 또한 서버로부터 응답에 대한 결과를 받아서 터미널에 출력한다.

/*
  Future<void> uploadAndDeleteRecording() async {       // added by 24-01-24
    try {
      // final url = Uri.parse('YOUR_SERVER_UPLOAD_URL');  // 실제 서버의 업로드 URL로 바꿔주세요
      // final url = Uri.parse('http://localhost:5000');    //  localhost로 TEST
      // final url = Uri.parse('http://127.0.0.1:5000');    //  localhost로 TEST
      // final url = Uri.parse('http://10.0.2.2:6000');    //  localhost로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      // final url = Uri.parse('http://192.168.0.104:6000');    // 실제 핸드폰에서 서버로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      final url = Uri.parse('https://f248-222-106-39-138.ngrok-free.app/predict');    //  영진님것 ngrox 테스트 url, 일회성 주소이기 떄문에 계속해서 url이 바뀐다.

      final file = File(audioPath);
      if (!file.existsSync()) {
        print("UPLOADING FILE NOT EXIST+++++++++++++++++++++++++++++++++++++++++++++++++");
        return;
      }

      // AudioConverter를 사용하여 오디오 파일을 Base64 문자열로 변환
      String base64String = await AudioConverter().convertAudioFileToBase64String(audioPath);

      // 데이터를 JSON 형식으로 변환
      // String jsonData = jsonEncode({'audioBase64': base64String});

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

  Future<void> uploadAndDeleteRecording() async {           // added by 24-01-24
    try {
      // final url = Uri.parse('YOUR_SERVER_UPLOAD_URL');   // 실제 서버의 업로드 URL로 바꿔주세요
      // final url = Uri.parse('http://localhost:8080');    //  localhost로 TEST
      // final url = Uri.parse('http://127.0.0.1:8080');    //  localhost로 TEST
      // final url = Uri.parse('http://10.0.2.2:5000');     //  localhost로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      // final url = Uri.parse('http://192.168.0.103:5000');    // 실제 핸드폰에서 서버로 TEST, 다른 플러터 앱의 main.dart로 데이터 전송 성공함
      final url = Uri.parse('https://f98e-222-106-39-138.ngrok-free.app/predict');    //  영진님것 ngrox 테스트 url, 일회성 주소이기 떄문에 계속해서 url이 바뀐다.

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
        //mainAxisAlignment: MainAxisAlignment.end, // 아이콘을 맨 아래에 정렬
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

// 아래는 실제 저장된 오디오 파일을 스트림(Byte)으로 변환하는지 확인하는 코드임 by 24-01-22

/*
void main() async {
  AudioConverter converter = AudioConverter();
// String filePath = '/path/to/your/audiofile.mp3'; // Replace with your actual file path

  String base64String = await converter.convertAudioFileToBase64String(filePath);
  print(base64String); // This will print the Base64 encoded string of your file
}
*/

