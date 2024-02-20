import 'package:flutter/material.dart';



class analyzed extends StatelessWidget {
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
            Image.asset('images/analyzing.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.
            Text(
              "분석중",
              style: TextStyle(fontSize: 42),
            ),
            SizedBox(height: 20),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
