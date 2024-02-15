import 'package:flutter/material.dart';
import 'Detail_Inconvenience.dart';
import 'Detailed_Hungry.dart';
import 'home.dart';
import 'Detailed_Tired.dart';



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
            // Text("피곤한 것 같아요", style: TextStyle(fontSize: 42),),
            RichText(
              text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                children: [
                  TextSpan(text: ' 피곤', style: TextStyle(fontSize: 39, fontWeight: FontWeight.bold)),
                  TextSpan(text: '한 것 같아요', style: TextStyle(fontSize: 39, fontWeight: FontWeight.normal)),
                ],
              ),
            ),

            SizedBox(height: 60),

            Image.asset('images/Dapino-Baby-Boy-Baby-sleeping 1.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.

            SizedBox(height: 70),

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
            SizedBox(height: 40),
            // Flutter에서 Text나 Button 등.. 암튼 두 개 사이에 간격을 넓히고 싶다? 그럼 SizedBox(width: 숫자)를 쓴다.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => detailed_tired()), // detailed_inconvenience,  detailed_tired
                );
              },
              child: Text("상세 페이지", style: TextStyle(fontSize: 42)),
            )
          ],
        ),
      ),
    );
  }
}
