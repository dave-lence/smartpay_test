import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sequel_test/config/customTheme.dart';
import 'package:sequel_test/screens/signup_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "title": "Finance app the safest and the most trusted",
      "subtitle":
          "Your finance work starts here, We are here to help you track and deal with speeding up your transaction",
      "image": "asset/device.png",
      'imageTwo': "asset/Group 18301.png",
      'imageThree': "asset/Group 18302.png"
    },
    {
      "title": "The fasted transaction process only here",
      "subtitle":
          "Go easy to pay all your bills with just a few steps.Paying your bills become fast and efficient.",
      "image": "asset/image.png",
      'imageTwo': "asset/contact.png",
      'imageThree': "asset/Group 18303.png"
    },
    
  ];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: _currentPage == index
            ? Colors.grey.shade900
            : Color.fromRGBO(211, 211, 211, 1),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 7,
      curve: Curves.easeIn,
      width: _currentPage == index ? 45 : 9,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: PageView.builder(
                controller: _controller,
                itemCount: splashData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: (){
                            Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      duration: const Duration(seconds: 1),
                                      child: const SignUpScreen()));
                          }, child: Text('Skip', style: TextStyle(color: CustomColor().lightBlue, fontWeight: FontWeight.w600),))
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 8 / 6,
                            child: Image.asset(
                              splashData[index]['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 20,
                            child: Image.asset(
                              splashData[index]['imageTwo']!,
                              width: 180,
                              height: 100,
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: 20,
                            child: Image.asset(
                              splashData[index]['imageThree']!,
                              width: 160,
                              height: 80,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 15.0, left: 30.0, right: 30.0),
                        child: Text(
                          splashData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Sofia",
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          splashData[index]['subtitle']!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Sofia",
                            fontSize: 15,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ),
                    
                    ],
                  );
                },
                onPageChanged: (value) => setState(() => _currentPage = value),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (int index) => _buildDots(index: index),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          _currentPage + 1 == splashData.length
                              ? Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(seconds: 1),
                                      child: const SignUpScreen()))
                              : _controller.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                );
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(287, 55),
                            backgroundColor: CustomColor().appGrey900,
                            elevation: 6,
                            animationDuration: const Duration(seconds: 3)),
                        child: Text(
                          _currentPage + 1 == splashData.length
                              ? 'Get Started'
                              : 'Next',
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Sofia",
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
