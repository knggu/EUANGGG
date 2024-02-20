import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'RecordingScreen.dart';
import 'hungry.dart';



class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  late AudioConverter converter;                      // Declare the AudioConverter variable
  String result = "";
  TextEditingController urlController = TextEditingController();  // URL을 입력 받는 컨트롤러


  @override
  void initState() {
    super.initState();
    converter = AudioConverter();         // Initialize the AudioConverter instance
    // ... other initializations ...
  }




// 아래의 코드는 #data가 hungry일 때, hungry.dart 페이지를 화면에 띄워주는 임시 Test 코드이다.

  Future<void> fetchData() async {
    try {
      final enteredUrl = urlController.text;
      final response = await http.get(
        Uri.parse(enteredUrl + "sample"),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '69420',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data == "hungry") {
            // If data is "hungry", navigate to HungryScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => hungry()),
            );
          } else {
            result = "predicted_label: $data";
          }
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




// Example method to convert an audio file
  void convertAudioFile(String filePath) async {
    try {
      String base64String = await converter.convertAudioFileToBase64String(filePath);
      // Use the base64String as needed
      print(base64String); // Example: print the Base64 string
    } catch (e) {
      print("Error during audio conversion: $e");
    }
  }





  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("아이와 소통의 시작", style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color:Colors.black26),
            ),

            SizedBox(height: 60),

            Image.asset('images/infantcryappicon2.png'),  // 이미지를 불러오는 확실한 코드

            SizedBox(height: 20),

            Text("분석을 통해", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color:Colors.black26),
            ),
            SizedBox(height: 20),

            Text("아기울음 소리를", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color:Colors.black26),
            ),
            SizedBox(height: 20),

            Text("이해할 수 있어요", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color:Colors.black26),
            ),
            SizedBox(height: 80),

            ElevatedButton(
              // child: Text("시작하기", style: TextStyle(fontSize: 40, color: Colors.white)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("시작하기", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                )
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecordingScreen()),
                  );
                },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF9CE796),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}


