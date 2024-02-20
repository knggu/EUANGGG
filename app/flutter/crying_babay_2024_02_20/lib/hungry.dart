import 'package:flutter/material.dart';
import 'home.dart';
import 'Detailed_Hungry.dart';



class hungry extends StatelessWidget {
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
                  TextSpan(text: ' 배가 고픈 것 ', style: TextStyle(fontSize: 39, fontWeight: FontWeight.bold, color:Colors.black38)),
                  TextSpan(text: '같아요', style: TextStyle(fontSize: 39, fontWeight: FontWeight.bold, color:Colors.black38)),
                ],
              ),
            ),

            SizedBox(height: 60),

            Image.asset('images/Dapino-Baby-Boy-Baby-drinking 2.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.

            SizedBox(height: 70),

            SizedBox(height: 40),

            ElevatedButton(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text("도움말", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  )
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => detailed_hungry()), // detailed_inconvenience,  detailed_tired
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