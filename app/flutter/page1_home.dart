import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '아기울음 분석',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
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
            ElevatedButton(
              onPressed: () {
                // 분석 시작
              },
              child: Text("분석 시작", style: TextStyle(fontSize: 48)),
            ),

          ],
        ),
      ),
    );
  }
}
