// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, unused_local_variable, empty_catches, avoid_print, duplicate_ignore, avoid_unnecessary_containers, prefer_const_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import '../api/api.dart';
import 'login.dart';

class LupaPass extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  LupaPass({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<LupaPass> createState() => _LupaPassState();
}

class _LupaPassState extends State<LupaPass> {
  ScrollController scrollController = ScrollController();

  final TextEditingController emailController = TextEditingController();

  bool visible = false;

  _cekLogin() async {
    setState(() {
      visible = true;
    });

    // print(params);
    if (emailController.text.isNotEmpty) {
      try {
        final res = await http.post(Uri.parse(BaseURL.lupaPass), body: {
          "email": emailController.text,
        });
        if (res.statusCode == 200) {
          var response = json.decode(res.body);
          if (response['value'] != 1) {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white70,
                          child: Icon(
                            Icons.password_rounded,
                            size: 60,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.redAccent,
                          child: SizedBox.expand(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email belum terdaftar",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50), // <-- Radius
                                      ),
                                      primary: Colors.white,
                                    ),
                                    child: Text('Ok',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black87)),
                                    onPressed: () => {
                                      setState(() {
                                        visible = false;
                                      }),
                                      Navigator.of(context).pop()
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (response['value'] == 1) {
            setState(
              () {
                visible = false;
              },
            );
            //alertdialog
            showDialog(
              context: context,
              builder: (_) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.white70,
                          child: Icon(
                            Icons.password_rounded,
                            size: 60,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.green,
                          child: SizedBox.expand(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Password berhasil di kirim ke email anda",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50), // <-- Radius
                                      ),
                                      primary: Colors.white,
                                    ),
                                    child: Text('Ok',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black87)),
                                    onPressed: () => {
                                      setState(() {
                                        visible = false;
                                      }),
                                      Navigator.of(context).pop()
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
      } catch (e) {}
    } else {
      setState(
        () {
          visible = false;
        },
      );
      //alertdialog
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white70,
                    child: Icon(
                      Icons.password_rounded,
                      size: 60,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.redAccent,
                    child: SizedBox.expand(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Email tidak boleh kosong !",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(50), // <-- Radius
                                ),
                                primary: Colors.white,
                              ),
                              child: Text('Ok',
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black87)),
                              onPressed: () => {
                                setState(() {
                                  visible = false;
                                }),
                                Navigator.of(context).pop()
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bodyHeight = mediaQueryHeight - MediaQuery.of(context).padding.top;
    final paddingTop = MediaQuery.of(context).padding.top;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
    ));
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Sistem Pakar",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppin',
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                            Text("Watermelon",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppin',
                                )),
                            Center(
                              child: Image.asset(
                                "asset/img/lupa.jpg",
                                height: mediaQueryHeight * 0.3,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child:
                                Container(child: CircularProgressIndicator())),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppin',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                  controller: emailController,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppin',
                                  ),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(2, 4),
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: const [
                                      Colors.green,
                                      Color.fromARGB(255, 35, 208, 125),
                                    ])),
                            child: Text(
                              'Kirim Email',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontFamily: 'Poppin',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: _cekLogin,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sudah punya akun ?",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: 'Poppin',
                                    color: Colors.black87)),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text("Login",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: 'Poppin',
                                        color: Colors.green)))
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))));
  }
}
