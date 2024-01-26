import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'RecordingScreen.dart';
// import 'VoiceRecorderPage.dart';
// import 'AudioConverter.dart'; // added by 24-01-22




class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  late AudioConverter converter; // Declare the AudioConverter variable, added by 24-01-22
  String result = "";
  TextEditingController urlController = TextEditingController(); // URL을 입력 받는 컨트롤러


  @override                   // added by 24-01-22
  void initState() {          // added by 24-01-22
    super.initState();        // added by 24-01-22
    converter = AudioConverter(); // Initialize the AudioConverter instance   // added by 24-01-22
    // ... other initializations ...
  }                           // added by 24-01-22







  Future<void> fetchData() async {
    try {
      final enteredUrl = urlController.text; // 입력된 URL 가져오기
      final response = await http.get(
        Uri.parse(enteredUrl + "sample"), // 입력된 URL 사용
        headers: {

          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          result =
          "predicted_label: $data";
        });
      } else {
        setState(() {
          result = "Failed to fetch data. Status Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }



// Example method to convert an audio file, added by 24-01-22
  void convertAudioFile(String filePath) async {
    try {
      String base64String = await converter.convertAudioFileToBase64String(filePath);
      // Use the base64String as needed
      print(base64String); // Example: print the Base64 string
    } catch (e) {
      print("Error during audio conversion: $e");
    }
  }      // added by 24-01-22









  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Image.asset('images/infantcryappicon2.png'),  // 이미지를 불러오는 확실한 코드
            // SizedBox(height: 20),
            Text(
              "아이와 소통의 시작",
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),

            Image.asset('images/infantcryappicon2.png'),  // 이미지를 불러오는 확실한 코드
            SizedBox(height: 20),

            Text(
              "분석을 통해",

              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              "아기울음 소리를",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              "이해할 수 있어요",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 60),
           /*
            ElevatedButton(
              onPressed: () {
                // 분석 시작
              },
              child: Text("분석 시작", style: TextStyle(fontSize: 48)),
            ),
            */
            ElevatedButton(
              child: Text("울음소리  녹음시작", style: TextStyle(fontSize: 40)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordingScreen()),
                );
              },
            ),
            /*
            TextField(
              controller: urlController, // URL 입력을 위한 TextField
              decoration: InputDecoration(labelText: "URL 입력"), // 입력 필드의 라벨
            ),
            ElevatedButton(
              onPressed: fetchData,
              child: Text("데이터 가져오기"),
            ),
            SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(fontSize: 18),
            )
            */
          ],
        ),
      ),
    );
  }
}


