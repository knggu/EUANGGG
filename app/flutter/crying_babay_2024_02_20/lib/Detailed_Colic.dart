import 'package:flutter/material.dart';
import 'home.dart';




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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(height: 40),


              Container(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Column(
                  children: [
                    Image.asset(
                      'images/Detailed_Colic.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      ),

              SizedBox(height: 20),


              RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                  children: [
                    TextSpan(text: '아래 방법을 시도해 보세요 ', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color:Colors.black38)),
                  ],
                ),
              ),

              SizedBox(height: 40),

              RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(-10.0, 4.5),
                        // child: Padding(
                        //  padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.looks_one_rounded, color: Colors.lightGreenAccent, size: 32,),
                      ),
                    ),


                    TextSpan(text: '이불로 아이를 감싸주세요', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                  ],
                ),
              ),


              SizedBox(height: 30),

              RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(-8.0, 4.5),
                        // child: Padding(
                        //  padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.looks_two_rounded, color: Colors.lightGreenAccent, size: 32,),
                      ),
                    ),


                    TextSpan(text: '따뜻한 물로 목욕을 해보는\n', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                    TextSpan(text: '     어떨까요? ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                  ],
                ),
              ),

              SizedBox(height: 30),

              RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(-10.0, 4.5),
                        // child: Padding(
                        // padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.looks_3_rounded, color: Colors.lightGreenAccent, size: 32,),
                      ),
                    ),


                    TextSpan(text: '혹시 너무 아프다 싶으면   \n ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                    TextSpan(text: '    병원을 방문해 보세요.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                  ],
                ),
              ),

              SizedBox(height: 40),


              ElevatedButton(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("홈으로", style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                    )
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => home()),
                  );
                },
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF9CE796),)
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}