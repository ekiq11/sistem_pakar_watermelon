// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipakar_water_melon/user/profile.dart/edit_profile.dart';
import 'package:sizer/sizer.dart';

import '../../login/login.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? username = "", nama = "", email = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  ambildata() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            insetPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            title: Text("Tentang Aplikasi",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppin')),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Sistem Pakar ini merupakan hasil penelitian dosen Universitas Teknologi Mataram yang didanai oleh dana hibah Penelitian Dosen Pemula - Kemdikbudristek tahun 2022.",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppin',
                          color: Colors.black87)),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: Colors.green, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close),
                        Center(
                          child: Text('Tutup',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Poppin',
                                  color: Colors.white)),
                        ),
                      ],
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('asset/img/user.webp'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("$nama",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.teal,
                    fontFamily: 'Poppin')),
            const SizedBox(
              height: 2,
            ),
            Text("$email",
                style: TextStyle(
                    fontSize: 12.sp, color: Colors.teal, fontFamily: 'Poppin')),
            const SizedBox(
              height: 40.0,
              width: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ))),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return UpdateProfile();
                      },
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text('Edit Profile',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontFamily: 'Poppin')),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: ListTile(
            //       leading: Icon(
            //         Icons.book,
            //         color: Colors.white,
            //       ),
            //       title: Text('Tentang Aplikasi',
            //           style:
            //               TextStyle(color: Colors.white, fontSize: (20.0))),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ))),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('username');
                  prefs.remove('email');
                  prefs.remove('nama');
                  prefs.remove('password');

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => LoginPage()));
                },
                child: const ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text('Keluar',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppin'))),
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
                onPressed: ambildata,
                child: Text("Sipakar Watermelon Versi 1.0 ",
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.teal,
                        fontFamily: 'Poppin')))
          ],
        ),
      ),
    );
  }
}
