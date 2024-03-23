import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sequel_test/components/custom_text_field.dart';
import 'package:sequel_test/config/customTheme.dart';
import 'package:sequel_test/screens/home_screen.dart';
import 'package:sequel_test/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool btnLoading = false;
  final passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool visibility = false;

  Future loginUser() async {
    if (emailController.text.isNotEmpty) {
      setState(() {
        btnLoading = true;
      });
      Dio dio = Dio();

      // Define the data to be sent in the POST request
      Map<String, dynamic> postData = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "device_name": 'mobile'
      };

      // Convert the data to JSON format
      String jsonData = jsonEncode(postData);
      try {
        // Send the POST request
        Response response = await dio.post(
          'https://mobile-test-2d7e555a4f85.herokuapp.com/api/v1/auth/login', // Replace with your API endpoint
          data: jsonData,
        );

        // Handle the response
        if (response.statusCode == 200) {
           Map<String, dynamic> responseData = response.data;

          // Extract the message from the response
          String message = responseData['message'];
          String token = responseData['data']['token'];

          await Future.delayed(
            Duration(seconds: 3),
            () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 5),
                      child: HomeScreen(token: token)));
            },
          );

          setState(() {
            btnLoading = false;
            emailController.clear();
            passwordController.clear();
          });
         

          showFlushbar(
              context,
              'Sign in success',
              CustomColor().appWhite,
              '$message, welcome back!',
              Icon(Icons.check_circle, color: CustomColor().appGreen),
              CustomColor().appWhite,
              CustomColor().appBlack);
        } else {
          setState(() {
            btnLoading = false;
          });
          Map<String, dynamic> responseData = response.data;

          // Extract the message from the response
          String message = responseData['message'];
          print(message);
          showFlushbar(
              context,
              'Sign In error',
              CustomColor().appWhite,
              message,
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appGrey900);
        }
      } catch (e) {
        print(e);
        showFlushbar(
            context,
            'Sign In error',
            CustomColor().appWhite,
            'Confirm your credentials',
            Icon(Icons.error, color: CustomColor().appRed),
            CustomColor().appWhite,
            CustomColor().appGrey900);
      }
      setState(() {
        btnLoading = false;
      });
    } else {
      setState(() {
        btnLoading = false;
      });

      showFlushbar(
          context,
          'Sign In error',
          CustomColor().appWhite,
          'Enter your valid email',
          Icon(Icons.error, color: CustomColor().appRed),
          CustomColor().appWhite,
          CustomColor().appBlack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor().appWhite,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text.rich(
                  TextSpan(
                    text: '',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'Welcome back to your ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: CustomColor().appBlack,
                        ),
                      ),
                      TextSpan(
                        text: 'Smartpay ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: CustomColor().lightBlue,
                        ),
                      ),
                      TextSpan(
                        text: 'account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: CustomColor().appBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                hintText: 'Email',
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    emailController.text = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  obscureText: visibility ? false : true,
                  suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          visibility = !visibility;
                        });
                      },
                      child: visibility
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                  onChanged: (p0) {
                    passwordController.text = p0;
                  },
                  controller: passwordController,
                  hintText: 'Password'),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: emailController.text.isEmpty ? null : loginUser,
                  style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: CustomColor().appGrey400,
                      backgroundColor: CustomColor().appGrey900,
                      fixedSize: Size(MediaQuery.of(context).size.width, 56),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: !btnLoading
                      ? Text('Sign in',
                          style: TextStyle(
                              color: CustomColor().appWhite,
                              fontWeight: FontWeight.w700))
                      : LoadingAnimationWidget.prograssiveDots(
                          color: CustomColor().appWhite,
                          size: 30,
                        )),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 155,
                    height: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.fromBorderSide(BorderSide(
                            width: 1, color: CustomColor().appGrey300))),
                    child: Center(
                      child: Image.asset(
                        'asset/search 1.png',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  ),
                  Container(
                    width: 155,
                    height: 56,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.fromBorderSide(BorderSide(
                            width: 1, color: CustomColor().appGrey300))),
                    child: Center(
                      child: Image.asset(
                        'asset/Apple_logo_black 1.png',
                        width: 23,
                        height: 23,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 200,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.bottomToTop,
                            curve: Curves.easeIn,
                            duration: const Duration(seconds: 1),
                            child: const SignUpScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text.rich(
                      TextSpan(
                        text: '',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              fontSize: 16,
                              color: CustomColor().appGrey600,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CustomColor().lightBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void showFlushbar(BuildContext context, String title, Color titleColor,
      String message, Icon icon, Color messageColor, Color backgroundColor) {
    Flushbar(
      title: title,
      titleColor: titleColor,
      message: message,
      icon: icon,
      isDismissible: true,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(minutes: 2),
      animationDuration: Duration(seconds: 1),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.bounceInOut,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(5),
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      messageColor: messageColor,
      boxShadows: [
        BoxShadow(
            color: CustomColor().appGrey900,
            offset: Offset(2, 4),
            blurRadius: 10)
      ],
    )..show(context);
  }
}
