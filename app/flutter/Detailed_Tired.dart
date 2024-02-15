import 'package:flutter/material.dart';
import 'Detail_Inconvenience.dart';
import 'home.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: detailed_tired(),
    );
  }
}



class detailed_tired extends StatelessWidget {
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

              Image.asset('images/tired_75.png'),

              SizedBox(height: 20),

              Text(style: TextStyle(fontSize: 18),
                  '차분한 환경을 조성하세요: 아기를 조용한 방으로 옮기세요. \n편안한 신체 접촉: 아기를 안거나 부드럽게 흔들어 주세요. \n신체적 접촉은 유아에게 매우 안정감을 주며 안정을 취하는 데 도움이 될 수 있습니다.\n자장가를 불러주세요: 부드럽고 부드러운 목소리나 조용한 노래는 아기를 매우 진정시킬 수 있습니다.!\n'
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