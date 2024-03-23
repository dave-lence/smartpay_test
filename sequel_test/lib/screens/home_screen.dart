import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sequel_test/config/customTheme.dart';
import 'package:sequel_test/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,  this.token = ''});
  final String token;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String secretString = '';
  bool secretLoading = false;
  void getSecret() async {
    setState(() {
      secretLoading = true;
    });
    final dio = Dio();
    final token = widget.token;

    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(
          'https://mobile-test-2d7e555a4f85.herokuapp.com/api/v1/dashboard',
          data: {'secret': 'string'});

      if (response.statusCode == 200) {
        // Parse the response data to extract the secret
        Map<String, dynamic> responseData = response.data;
        if (responseData.containsKey('data')) {
          Map<String, dynamic> data = responseData['data'];
          if (data.containsKey('secret')) {
            String secret = data['secret'];
            print('Secret: $secret');
            setState(() {
              secretString = secret;
            });
          } else {
            print('Secret not found in response data.');
          }
        } else {
          print('Data not found in response.');
        }
        setState(() {
          secretLoading = false;
        });
      } else {
        setState(() {
          secretLoading = false;
        });
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        secretLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSecret();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor().appWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Center(
                heightFactor: 7,
                child: Column(
                  children: [
                   secretLoading ? LoadingAnimationWidget.prograssiveDots(color: CustomColor().appBlack, size: 30) : Text(secretString),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  curve: Curves.easeIn,
                                  duration: const Duration(seconds: 1),
                                  child: const LoginScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(200, 40),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: CustomColor().appGrey900),
                        child: Text(
                          'Log out',
                          style: TextStyle(
                              color: CustomColor().appWhite,
                              fontWeight: FontWeight.w800),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
