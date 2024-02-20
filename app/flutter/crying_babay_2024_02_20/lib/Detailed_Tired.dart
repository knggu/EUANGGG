import 'package:flutter/material.dart';
import 'Detail_Inconvenience.dart';
import 'home.dart';


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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text('상세 페이지', style: TextStyle(fontSize: 35)),

              SizedBox(height: 60),

              Container(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: Column(
                  children: [
                    Image.asset(
                      'images/tired.png',
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


                    TextSpan(text: '아기를 조용한 방으로 옮기세요 ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                  ],
                ),
              ),


              SizedBox(height: 30),

              RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(-13.0, 4.5),
                        // child: Padding(
                        //  padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.looks_two_rounded, color: Colors.lightGreenAccent, size: 32,),
                      ),
                    ),


                    TextSpan(text: '아기를 안거나 부드럽게 흔들어\n ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                    TextSpan(text: '    주세요 ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),

                  ],
                ),
              ),

              SizedBox(height: 30),

              RichText(
                text: TextSpan(style: TextStyle(color: Colors.black), //, fontSize: 42),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(-11.0, 4.5),
                        // child: Padding(
                        // padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.looks_3_rounded, color: Colors.lightGreenAccent, size: 32,),
                      ),
                    ),

                    TextSpan(text: '조용한 노래로 아기를 달래줘요', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color:Colors.black38)),
                  ],
                ),
              ),

               SizedBox(height: 60),


              ElevatedButton(
                // child: Text("시작하기", style: TextStyle(fontSize: 40, color: Colors.white)),
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
            ),
          ],
        ),
      ),
    );
  }
}