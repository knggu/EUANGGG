import 'package:flutter/material.dart';
import 'Detailed_Colic.dart';
import 'Detailed_Hungry.dart';
import 'home.dart';
import 'Detail_Inconvenience.dart';
import 'Detailed_Tired.dart';



class inconvenience extends StatelessWidget {
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
                      TextSpan(text: ' 어디가 ', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color:Colors.black38)),
                      TextSpan(text: '불편', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color:Colors.black38)),
                      TextSpan(text: '한 것 같아요 ', style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color:Colors.black38)),
                    ],
                ),
            ),
            SizedBox(height: 60),

            Image.asset('images/Dapino-Baby-Girl-Baby-crying 1.png'), // 이미지 경로를 실제 이미지 파일로 변경하세요.

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
                 MaterialPageRoute(builder: (context) => detailed_inconvenience()), // detailed_inconvenience,  detailed_tired
               );
             },
             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF9CE796),)
               // child: Text("도움말", style: TextStyle(fontSize: 42)),
             ),
           ),
         ],
         ),
      ),
    );
  }
}
