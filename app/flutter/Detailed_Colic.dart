import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: detailed_colic(),
    );
  }
}


class detailed_colic extends StatelessWidget {
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
              Text('상세 페이지', style: TextStyle(fontSize: 35)),

              SizedBox(height: 40),

              Image.asset('images/Detailed_Colic.png'),

              SizedBox(height: 20),

              Text(style: TextStyle(fontSize: 18),
                  '이불이나 담요로 아이를 따뜻하게 감싸주고 토닥여 주세요\n 따뜻한 물로 목욕을 해보는 건 어떨까요?\n 혹시 너무 아프다 싶으면 병원을 방문해 보세요!.'
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => home()),
                  );
                },
                child: Text("홈으로", style:TextStyle(fontSize: 42)),
              )
            ]
        ),
      ),
    );
  }
}
