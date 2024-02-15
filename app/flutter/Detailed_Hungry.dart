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
      home: detailed_hungry(),
    );
  }
}



class detailed_hungry extends StatelessWidget {
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

              Image.asset('images/Detailed_Hungry.png'),

              SizedBox(height: 20),

              Text(style: TextStyle(fontSize: 18),
                  '배고픔 \n칭얼거리는 우는 울음소리 \n아기가 손가락이나 주먹을 입으로 가져가는 행동을 합니다. \n수유 시간 되어가면 수유하시고 아니면 팔, 다리 등을 주물러 달래어 봅니다. \n자주 수유를 하시면 배 앓이를 할 수도 있습니다.\n'
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