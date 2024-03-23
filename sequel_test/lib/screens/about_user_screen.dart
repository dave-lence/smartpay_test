import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sequel_test/components/custom_back_btn.dart';
import 'package:sequel_test/components/custom_text_field.dart';
import 'package:sequel_test/config/customTheme.dart';
import 'package:sequel_test/screens/home_screen.dart';

class AboutUserScreen extends StatefulWidget {
  const AboutUserScreen({super.key, required this.emailAddress});

  final String emailAddress;

  @override
  State<AboutUserScreen> createState() => _AboutUserScreenState();
}

class _AboutUserScreenState extends State<AboutUserScreen> {
  final fullNamecontroller = TextEditingController();
  final userNamecontroller = TextEditingController();
  final passwordController = TextEditingController();
  bool btnLoading = false;
  bool visibility = false;
  String selectedCountry = 'Country';
  String? deviceId;

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // For iOS devices
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceId = iosInfo.identifierForVendor;
        });
      } else if (Theme.of(context).platform == TargetPlatform.android) {
        // For Android devices
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceId = androidInfo.brand;
        });
        print(deviceId);
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
  }

  Future registerUser() async {
    if (passwordController.text.isNotEmpty) {
      setState(() {
        btnLoading = true;
      });
      Dio dio = Dio();

      // Define the data to be sent in the POST request
      Map<String, dynamic> postData = {
        "full_name": fullNamecontroller.text.trim(),
        "username": userNamecontroller.text.trim(),
        "email": widget.emailAddress,
        "country": selectedCountry.substring(0, 2),
        "password": passwordController.text.trim(),
        "device_name": 'mobile'
      };

      // Convert the data to JSON format
      print(postData);
      String jsonData = jsonEncode(postData);
      try {
        // Send the POST request
        Response response = await dio.post(
          'https://mobile-test-2d7e555a4f85.herokuapp.com/api/v1/auth/register', // Replace with your API endpoint
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
                      child: const HomeScreen()));
            },
          );

          setState(() {
            btnLoading = false;
            fullNamecontroller.clear();
            userNamecontroller.clear();
            passwordController.clear();
          });
          Map<String, dynamic> responseData = response.data;

          // Extract the message from the response
          String message = responseData['message'];

          showFlushbar(
              context,
              'Registration successful',
              CustomColor().appWhite,
              '$message, you\'ve been registered 🥳.',
              Icon(Icons.check_circle, color: CustomColor().appGreen),
              CustomColor().appWhite,
              CustomColor().appBlack);
        } else {
          setState(() {
            btnLoading = false;
          });
          Map<String, dynamic> responseData = response.data;

          // Extract the message from the response
          if (responseData != null && responseData.containsKey('errors')) {
            Map<String, dynamic> errors = responseData['errors'];
            if (errors.containsKey('email')) {
              List<String> emailErrors = errors['email'];
              String emailErrorMessage = emailErrors.join(
                  ', '); // Combine all error messages into a single string
              showFlushbar(
                  context,
                  'Registration error',
                  CustomColor().appWhite,
                  emailErrorMessage,
                  Icon(Icons.error, color: CustomColor().appRed),
                  CustomColor().appWhite,
                  CustomColor().appBlack);
            }
          }
        }
      } catch (e) {
        setState(() {
          btnLoading = false;
        });
        if (e is DioException && e.response?.statusCode == 422) {
          print('Error 422: Unprocessable Entity');
          print('Response body: ${e.response?.data}');

          Map<String, dynamic> responseData = e.response?.data;
          if (responseData != null && responseData.containsKey('errors')) {
            Map<String, dynamic> errors = responseData['errors'];
            if (errors.containsKey('email')) {
              dynamic emailErrorData = errors.containsKey('email') ? errors['email'] :  errors.containsKey('full_name') ? errors['full_name'] : errors.containsKey('username') ? errors['username'] : errors.containsKey('country') ? errors['country'] : errors.containsKey('password') ? errors['password'] : '' ;
              String emailErrorMessage = emailErrorData is List
                  ? emailErrorData.join(', ')
                  : emailErrorData.toString();

              showFlushbar(
                  context,
                  'Registration error',
                  CustomColor().appWhite,
                  emailErrorMessage,
                  Icon(Icons.error, color: CustomColor().appRed),
                  CustomColor().appWhite,
                  CustomColor().appBlack);
            }
          }
        } else {
          showFlushbar(
              context,
              'Sign up error',
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
          'Sign up error',
          CustomColor().appWhite,
          'Enter your valid email',
          Icon(Icons.error, color: CustomColor().appRed),
          CustomColor().appWhite,
          CustomColor().appBlack);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceId();
  }

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
                          child: Center()));
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
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
                        text: 'Hey there! tell us a bit about ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: CustomColor().appBlack,
                        ),
                      ),
                      TextSpan(
                        text: 'Yourself.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: CustomColor().lightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              CustomTextField(
                  onChanged: (value) {
                    fullNamecontroller.text = value;
                  },
                  controller: fullNamecontroller,
                  hintText: 'Full Name'),
              SizedBox(
                height: 15,
              ),
              CustomTextField(
                  onChanged: (value) {
                    userNamecontroller.text = value;
                  },
                  controller: userNamecontroller,
                  hintText: 'Username'),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,

                      favorite: <String>['NG'],
                      //Optional. Shows phone code before the country name.
                      showPhoneCode: false,

                      onSelect: (Country country) {
                        setState(() {
                          selectedCountry = country.countryCode;
                        });
                      },
                      // Optional. Sets the theme for the country list picker.
                      countryListTheme: CountryListThemeData(
                        bottomSheetHeight: 600,
                        // Optional. Sets the border radius for the bottomsheet.
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                        // Optional. Styles the search field.
                        inputDecoration: InputDecoration(
                            labelText: 'Search',
                            hintText: 'Start typing to search',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            border: InputBorder.none,
                            fillColor: CustomColor().appGrey100),
                        // Optional. Styles the text in the search field
                        searchTextStyle: TextStyle(
                          color: CustomColor().appBlack,
                          fontSize: 18,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 56,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: CustomColor().appGrey100,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedCountry != 'Country'
                            ? selectedCountry.substring(0, 2)
                            : selectedCountry),
                        Icon(Icons.arrow_drop_down_sharp)
                      ],
                    )),
                  )),
              SizedBox(
                height: 15,
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
                height: 30,
              ),
              ElevatedButton(
                  onPressed:
                      passwordController.text.isEmpty ? null : registerUser,
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
