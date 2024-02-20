import 'package:flutter/material.dart';
import 'Detail_Inconvenience.dart';
import 'home.dart';


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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text('상세 페이지', style: TextStyle(fontSize: 35)),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Column(
                children: [
                  Image.asset(
                    'images/Detailed_Hungry.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),


                  SizedBox(height: 20),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black), //, fontSize: 42),
                      children: [
                        TextSpan(text: '아래 방법을 시도해 보세요 ',
                            style: TextStyle(fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38)),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black), //, fontSize: 42),
                      children: [
                        WidgetSpan(
                          child: Transform.translate(
                            offset: Offset(-10.0, 4.5),
                            // child: Padding(
                            //  padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.looks_one_rounded,
                              color: Colors.lightGreenAccent, size: 32,),
                          ),
                        ),


                        TextSpan(text: '아기가 손을 입으로 가져가요',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38)),
                      ],
                    ),
                  ),


                  SizedBox(height: 30),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black), //, fontSize: 42),
                      children: [
                        WidgetSpan(
                          child: Transform.translate(
                            offset: Offset(-10.0, 4.5),
                            // child: Padding(
                            //  padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.looks_two_rounded,
                              color: Colors.lightGreenAccent, size: 32,),
                          ),
                        ),


                        TextSpan(text: '수유 시간되면 수유해 주세요\n',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38)),
                        TextSpan(text: '     팔,다리 등을 주물러 주세요',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38)),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black), //, fontSize: 42),
                      children: [
                        WidgetSpan(
                          child: Transform.translate(
                            offset: Offset(-6.0, 4.5),
                            // child: Padding(
                            // padding: const EdgeInsets.only(right: 12.0),
                            child: Icon(Icons.looks_3_rounded,
                              color: Colors.lightGreenAccent, size: 32,),
                          ),
                        ),


                        TextSpan(text: '자주 수유를 하시면 배 앓이를\n ',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38)),
                        TextSpan(text: '    할 수도 있어요',
                            style: TextStyle(fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black38)),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),


                  ElevatedButton(
                    // child: Text("시작하기", style: TextStyle(fontSize: 40, color: Colors.white)),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text("홈으로", style: TextStyle(fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        )
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => home()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF9CE796),)
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