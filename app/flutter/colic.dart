import 'package:flutter/material.dart';

import 'home.dart';

/*
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '아기울음 분석',
      home: ColicPage(),
    );
  }
}
*/

class colic extends StatelessWidget {
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
            Text(
              "복통이 있는 것 같아요",
              style: TextStyle(fontSize: 42),
            ),
            SizedBox(height: 20),
            Image.asset('images/Dapino-Baby-Boy-Baby-crying 2.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                );
                // 홈으로 이동하는 기능을 구현하세요.
                // 예를 들면 Navigator를 사용하여 홈 화면으로 이동할 수 있습니다.
              },
              child: Text("홈으로", style: TextStyle(fontSize: 42)),
            ),
          ],
        ),
      ),
    );
  }
}
