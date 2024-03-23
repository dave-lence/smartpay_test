import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sequel_test/config/customTheme.dart';
import 'package:sequel_test/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent, // set the status bar color if needed
    ));
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
              duration: 4000,
              splash: Image.asset(
                "asset/logo (1).png",
                width: 375,
                height: 420,
              ),
              nextScreen: 
                   OnBoardingScreen()
                  ,
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.rightToLeft,
              backgroundColor: CustomColor().appWhite),
    );
  }
}

