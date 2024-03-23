import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sequel_test/components/custom_back_btn.dart';
import 'package:sequel_test/config/customTheme.dart';
import 'package:sequel_test/screens/about_user_screen.dart';
import 'package:sequel_test/screens/signup_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.emailAddress});

  final String emailAddress;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final otpController = TextEditingController();
  bool btnLoading = false;

  Future verifyUser() async {
    if (otpController.text.isNotEmpty) {
      setState(() {
        btnLoading = true;
      });
      Dio dio = Dio();

      // Define the data to be sent in the POST request
      Map<String, dynamic> postData = {
        'email': widget.emailAddress,
        "token": otpController.text.trim()
      };

      // Convert the data to JSON format
      String jsonData = jsonEncode(postData);
      try {
        // Send the POST request
        Response response = await dio.post(
          'https://mobile-test-2d7e555a4f85.herokuapp.com/api/v1/auth/email/verify', // Replace with your API endpoint
          data: jsonData,
        );

        // Handle the response
        if (response.statusCode == 200) {
          await Future.delayed(
            Duration(seconds: 3),
            () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 5),
                      child: AboutUserScreen(
                        emailAddress: widget.emailAddress,
                      )));
            },
          );

          setState(() {
            btnLoading = false;
            otpController.clear();
          });
          Map<String, dynamic> responseData = response.data;

          // Extract the message from the response
          String message = responseData['message'];

          showFlushbar(
              context,
              'Verification successful ✅',
              CustomColor().appWhite,
              '$message, email verified',
              Icon(Icons.check_circle, color: CustomColor().appGreen),
              CustomColor().appWhite,
              CustomColor().appBlack);
        } else {
          setState(() {
            btnLoading = false;
          });
          Map<String, dynamic> responseData = response.data;

          // Extract the message from the response
          String message = responseData['errors']['token'];
          showFlushbar(
              context,
              'Verification error',
              CustomColor().appWhite,
              message,
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        }
      } catch (e) {
        if (e is DioException && e.response?.statusCode == 422) {
          print('Error 422: Unprocessable Entity');
          print('Response body: ${e.response?.data}');
          Map<String, dynamic> responseData = e.response?.data;
          String message = responseData['message'];
          showFlushbar(
              context,
              'Verification error',
              CustomColor().appWhite,
              message,
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        } else {
          showFlushbar(
              context,
              'Verification error',
              CustomColor().appWhite,
              e.toString(),
              Icon(Icons.error, color: CustomColor().appRed),
              CustomColor().appWhite,
              CustomColor().appBlack);
        }
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
          'Verification error',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              customBackButton(
                onTap: () {
                  Navigator.pop(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 5),
                          child: const SignUpScreen()));
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Verify it\'s you',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'We sent a code to (******@gmail.com). Enter it here to verify your identity.',
                style: TextStyle(fontSize: 16, color: CustomColor().appGrey600),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  
                  child: PinCodeTextField(
                  
                    controller: otpController,
                    highlight: true,
                    highlightColor: CustomColor().lightBlue  ,
                    defaultBorderColor: CustomColor().appGrey100,
                    hasTextBorderColor: CustomColor().lightBlue,
                    highlightPinBoxColor: CustomColor().appGrey100,
                    pinBoxOuterPadding: EdgeInsets.symmetric(horizontal: 5),
                    maxLength: 5,
                    hasError: false,
                    pinBoxWidth: 56,
                    pinBoxHeight: 56,
                    wrapAlignment: WrapAlignment.end,
                    pinBoxDecoration:
                        ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                    pinBoxRadius: 15,
                    pinTextStyle: TextStyle(
                        fontSize: 20.0,
                        color: CustomColor().appBlack,
                        fontWeight: FontWeight.w800),
                    pinTextAnimatedSwitcherDuration:
                        const Duration(milliseconds: 300),
                    highlightAnimation: true,
                    highlightAnimationBeginColor: CustomColor().lightBlue,
                    highlightAnimationEndColor: CustomColor().lightBlue,
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  'Resend Code in 30 seconds',
                  style: TextStyle(
                      fontSize: 16,
                      color: CustomColor().appGrey600,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: otpController.text.length != 5 ? null : verifyUser,
                  style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: CustomColor().appGrey400,
                      backgroundColor: CustomColor().appGrey900,
                      fixedSize: Size(MediaQuery.of(context).size.width, 56),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: !btnLoading
                      ? Text('Confirm',
                          style: TextStyle(
                              color: CustomColor().appWhite,
                              fontWeight: FontWeight.w700))
                      : LoadingAnimationWidget.prograssiveDots(
                          color: CustomColor().appWhite,
                          size: 30,
                        )),
              SizedBox(
                height: 30,
              ),
              // NumPad(
              //   arabicDigits: false,
              //   onType: (value) {
              //     setState(() {
              //       otpController.text += value;
              //     });
              //   },
              //   rightWidget: IconButton(
              //     icon: const Icon(Icons.backspace),
              //     onPressed: () {
              //       if (otpController.text.isNotEmpty) {
              //         setState(() {
              //           otpController.text = otpController.text
              //               .substring(0, otpController.text.length - 1);
              //         });
              //         print(otpController.text);
              //       }
              //     },
              //   ),
              // ),
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
