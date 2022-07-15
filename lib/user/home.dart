// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipakar_water_melon/user/profile.dart/profile.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../../api/api.dart';
// import 'profile/profile.dart';

final List<String> imgList = [
  'https://assets.promediateknologi.com/crop/0x0:0x0/x/photo/2022/02/20/3031254084.jpg',
  'https://i0.wp.com/fredikurniawan.com/wp-content/uploads/2015/08/142.png',
  'https://img.sipindo.id/post/431/1-_Hama_Liriomyza-melon.jpg'
];

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? nama, username;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      nama = preferences.getString("nama");
    });
    print(nama);
  }

  @override
  void initState() {
    getPref();

    super.initState();
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ))
      .toList();

//List Data
  Future<List<dynamic>> _fetchGejala() async {
    var result = await http.get(Uri.parse(BaseURL.gejala));
    return json.decode(result.body);
  }

  Future<List<dynamic>> _fetchPenyakit() async {
    var result = await http.get(Uri.parse(BaseURL.penyakit));
    return json.decode(result.body);
  }

  Future<List<dynamic>> _fetchPengetahuan() async {
    var result = await http.get(Uri.parse(BaseURL.pengetahuan));
    return json.decode(result.body);
  }

  Future<List<dynamic>> _fetchPengguna() async {
    var result = await http.get(Uri.parse(BaseURL.user));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 251, 235),
      //appBar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sistem Pakar",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppin')),
                Text("Watermelon",
                    style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppin')),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ));
              },
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Text("$username",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Poppin',
                            color: Colors.white)),
                  ),
                  Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 50,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: const [
                                Color.fromARGB(255, 206, 246, 204),
                                Color.fromARGB(255, 206, 246, 204)
                              ])),
                      child: Icon(Icons.person, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 59, 183, 2),
                Color.fromARGB(255, 16, 182, 116)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15.0, bottom: 15.0),
              child: Text("Penyakit Tanaman",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppin')),
            ),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 15.0, bottom: 15.0),
              child: Text("Data Penyakit",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppin')),
            ),

            FutureBuilder<List<dynamic>?>(
              future: _fetchGejala(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.green,
                                  width: 70,
                                  height: 70,
                                  child: Icon(Icons.health_and_safety,
                                      color: Colors.white, size: 32.0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Gejala',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppin')),
                                      Text('Data Gejala',
                                          style: TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                      snapshot.data![index]['total'].toString(),
                                      style: TextStyle(fontSize: 18.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            //END List Tile
            SizedBox(height: 20),

            FutureBuilder<List<dynamic>?>(
              future: _fetchPenyakit(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.blue,
                                  width: 70,
                                  height: 70,
                                  child: Icon(Icons.sick,
                                      color: Colors.white, size: 32.0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Penyakit',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppin')),
                                      Text('Data penyakit',
                                          style: TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(
                                      snapshot.data![index]['total'].toString(),
                                      style: TextStyle(fontSize: 18.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            //END List Tile
            SizedBox(height: 20),

            FutureBuilder<List<dynamic>?>(
              future: _fetchPengetahuan(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.red,
                                  width: 70,
                                  height: 70,
                                  child: Icon(Icons.school,
                                      color: Colors.white, size: 32.0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Pengetahuan',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppin')),
                                      Text('Data pengetahuan',
                                          style: TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(snapshot.data![index]['total'],
                                      style: TextStyle(fontSize: 18.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            //END List Tile
            SizedBox(height: 20),

            FutureBuilder<List<dynamic>?>(
              future: _fetchPengguna(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (BuildContext context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 70,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Colors.amber,
                                  width: 70,
                                  height: 70,
                                  child: Icon(Icons.people,
                                      color: Colors.white, size: 32.0),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Total Pengguna',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppin')),
                                      Text('Data pengguna',
                                          style: TextStyle(color: Colors.grey))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Text(snapshot.data![index]['total'],
                                      style: TextStyle(fontSize: 18.sp)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            //END List Tile
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
