import 'package:flutter/material.dart';
import 'Detailed_Colic.dart';
import 'home.dart';



class colic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(height: 60),

            RichText(
              text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                children: [
                  TextSpan(text: ' 복통', style: TextStyle(fontSize: 39, fontWeight: FontWeight.bold, color:Colors.black38)),
                  TextSpan(text: '이 있는 것 같아요', style: TextStyle(fontSize: 39, fontWeight: FontWeight.bold, color:Colors.black38)),
                ],
              ),
            ),

            SizedBox(height: 60),

            Image.asset('images/Dapino-Baby-Boy-Baby-crying 2.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.

            SizedBox(height: 70),

            SizedBox(height: 40),
            // Flutter에서 Text나 Button 등.. 암튼 두 개 사이에 간격을 넓히고 싶다? 그럼 SizedBox(width: 숫자)를 쓴다.

            ElevatedButton(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text("도움말", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  )
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => detailed_colic()), // detailed_inconvenience,  detailed_tired
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
