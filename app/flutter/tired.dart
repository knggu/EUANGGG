import 'package:flutter/material.dart';
import 'home.dart';



class tired extends StatelessWidget {
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
              "피곤한 것 같아요",
              style: TextStyle(fontSize: 42),
            ),
            SizedBox(height: 20),
            Image.asset('images/Dapino-Baby-Boy-Baby-sleeping 1.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.
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
