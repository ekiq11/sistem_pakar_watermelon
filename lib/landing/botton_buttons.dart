// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../login/login.dart';

class BottomButtons extends StatelessWidget {
  final int? currentIndex;
  final int? dataLength;
  final PageController? controller;

  const BottomButtons(
      {Key? key, this.currentIndex, this.dataLength, this.controller})
      : super(key: key);

  _storeOnboardInfo() async {
    //print("Shared pref called");
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    // print(prefs.getInt('onBoard'));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: currentIndex == dataLength! - 1
          ? [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 50.0,
                    ),
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: const Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.green,
                                  Color.fromARGB(255, 35, 208, 125),
                                ])),
                        child: Text(
                          'G e t   S t a r t e d',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppin'),
                        ),
                      ),
                      onTap: () {
                        _storeOnboardInfo();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ),
                ),
              )
            ]
          : [
              TextButton(
                onPressed: () {
                  _storeOnboardInfo();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  "Skip",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      controller!.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      "Next",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
    );
  }
}
