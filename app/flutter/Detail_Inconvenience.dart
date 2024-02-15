import 'package:flutter/material.dart';
import 'home.dart';


void main() {
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: detailed_inconvenience(),
    );
  }
}

class detailed_inconvenience extends StatelessWidget {
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

          Image.asset('images/Detailed_Inconvenience.png'),

          SizedBox(height: 20),

          Text(style: TextStyle(fontSize: 18),
              '아기는 엄마와 떨어져 있을때 불안함을 항상 느낍니다.\n왜냐면 아기와 엄마는 하나이니깐요\n아기는 엄마와 떨어져 있을때 분리불안 증상이 나타나요, 아기가 불안함으로 인해 울지 않도록 아기와 함께 옆에서 계속 있어주세요 엄마 품에 있는 아기는 항상 편안해 질거에요 아기가 낯선 곳에 있거나 처음 보는 사람이 있다면 그 곳을 벗어나 주세요. 아기를 사랑스러운 미소로 안아주고 말로서 달래보세요("까꿍~" 등의 말로요) 항상 아기를 보살펴 주세요!'
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