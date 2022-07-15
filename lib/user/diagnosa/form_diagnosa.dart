// ignore_for_file: prefer_interpolation_to_compose_strings, equal_keys_in_map, unnecessary_null_comparison, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipakar_water_melon/user/diagnosa/radio_button.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../api/api.dart';
import 'model_diagnosa/model_hasil_diagnosa.dart';

class FormDiagnosa extends StatefulWidget {
  const FormDiagnosa({Key? key}) : super(key: key);

  @override
  State<FormDiagnosa> createState() => _FormDiagnosaState();
}

class _FormDiagnosaState extends State<FormDiagnosa> {
  @override
  void initState() {
    getPref();

    super.initState();
  }

  int? count = 0;
  int? count2 = 0;
  int? count3 = 0;
  int? count4 = 0;
  int? count5 = 0;
  int? count6 = 0;
  int? count7 = 0;
  int? count8 = 0;
  int? count9 = 0;
  int? count10 = 0;
  int? count11 = 0;
  String? nama;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
    });
    print(nama);
  }

  String? val;
  List? id = [];

  Map<String, dynamic>? data;
  String? jsonContent;
  ambildata() async {
    id!.remove('null');
    id!.add(val);
    data = {"nama_user": "$nama"};
    for (int i = 0; i < id!.length; i++) {
      data!.addAll({"kondisi[$i]": id![i]});
    }

    print(data);
    final result = await http.post(
      Uri.parse(BaseURL.hasilDiagnosa),
      body: data,
    );
    final jsonData = json.decode(result.body);
    Diagnosa diagnosa = Diagnosa.fromJson(jsonData);

    setState(() {
      jsonContent = diagnosa.toString();
    });
    print(diagnosa);
    if (result.statusCode == 200) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              insetPadding: const EdgeInsets.only(
                  left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
              title: Text(diagnosa.hasilDiagnosa.toString(),
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppin')),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      backgroundColor: Colors.green,
                      label: Text('Gejala',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppin',
                              color: Colors.white)),
                    ),
                    for (int i = 0; i < diagnosa.nmGejala!.length; i++)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "G" + diagnosa.kdGejala![i].toString(),
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppin',
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: SizedBox(
                              width: 20.0,
                              child: Text(
                                "" + diagnosa.nmGejala![i].toString(),
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Chip(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Colors.amber,
                      label: Text('Detail Penyakit',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppin',
                              color: Colors.white)),
                    ),
                    Text(
                      diagnosa.detailPenyakit.toString(),
                      style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppin'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Chip(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Colors.redAccent,
                      label: Text('Pengendalian',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppin',
                              color: Colors.white)),
                    ),
                    Text(diagnosa.pengendalian.toString(),
                        style:
                            TextStyle(fontSize: 12.sp, fontFamily: 'Poppin')),
                    Chip(
                      padding: EdgeInsets.all(0),
                      backgroundColor: Colors.blue,
                      label: Text('Kemungkinan Lain',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppin',
                              color: Colors.white)),
                    ),
                    for (int x = 0; x < diagnosa.kemungkinanLain!.length; x++)
                      Text(
                          diagnosa.kemungkinanLain!.length != null
                              ? diagnosa.kemungkinanLain![x].toString()
                              : "Tidak ada kemungkinan lainnya",
                          style:
                              TextStyle(fontSize: 12.sp, fontFamily: 'Poppin')),
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
                        setState(() {
                          for (var z = 0; z < id!.length; z++) {
                            id!.removeAt(z);
                          }
                        });
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
  }

  //AlertDalog
  //Tips
  tips() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            insetPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            title: Text("Petunjuk",
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppin')),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "5",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Pasti Iya",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "4",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Hampir Pasti Iya",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "3",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Kemungkinan Besar Iya",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "2",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Mungkin Iya",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "1",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Hampir Mungkin",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 251, 235),
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Form Diagnosa',
                style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppin')),
            InkWell(
              onTap: tips,
              child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  child: Icon(Icons.tips_and_updates_outlined,
                      color: Colors.white)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Diagnosa Penyakit",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buah membusuk tetapi bagian yang membusuk tetap ke keras atau busuk kering",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count = value!;
                                              id!.add(val.toString());
                                              val = "1_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count = value!;
                                              id!.add(val.toString());
                                              val = "1_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count = value!;
                                              id!.add(val.toString());
                                              val = "1_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count = value!;
                                              id!.add(val.toString());
                                              val = "1_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count = value!;
                                              id!.add(val.toString());
                                              val = "1_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 2
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buah yang sudah tua akan retak atau pecah",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count2!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count2 = value!;
                                              id!.add(val.toString());
                                              val = "2_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count2!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count2 = value!;
                                              id!.add(val.toString());
                                              val = "2_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count2!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count2 = value!;
                                              id!.add(val.toString());
                                              val = "2_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count2!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count2 = value!;
                                              id!.add(val.toString());
                                              val = "2_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count2!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count2 = value!;
                                              id!.add(val.toString());
                                              val = "2_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 3
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buah berangsur-angsur membusuk",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count3!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count3 = value!;
                                              id!.add(val.toString());
                                              val = "3_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count3!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count3 = value!;
                                              id!.add(val.toString());
                                              val = "3_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count3!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count3 = value!;
                                              id!.add(val.toString());
                                              val = "3_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count3!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count3 = value!;
                                              id!.add(val.toString());
                                              val = "3_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count3!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count3 = value!;
                                              id!.add(val.toString());
                                              val = "3_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 4
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terdapar larva di dalam buah",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count4!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count4 = value!;
                                              id!.add(val.toString());
                                              val = "4_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count4!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count4 = value!;
                                              id!.add(val.toString());
                                              val = "4_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count4!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count4 = value!;
                                              id!.add(val.toString());
                                              val = "4_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count4!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count4 = value!;
                                              id!.add(val.toString());
                                              val = "4_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count4!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count4 = value!;
                                              id!.add(val.toString());
                                              val = "4_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 5
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rasa buah tidak enak sedikit masam",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count5!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count5 = value!;
                                              id!.add(val.toString());
                                              val = "5_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count5!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count5 = value!;
                                              id!.add(val.toString());
                                              val = "5_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count5!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count5 = value!;
                                              id!.add(val.toString());
                                              val = "5_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count5!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count5 = value!;
                                              id!.add(val.toString());
                                              val = "5_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count5!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count5 = value!;
                                              id!.add(val.toString());
                                              val = "5_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 6
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buah beraroma tidak enak berbau busuk",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count6!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count6 = value!;
                                              id!.add(val.toString());
                                              val = "6_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count6!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count6 = value!;
                                              id!.add(val.toString());
                                              val = "6_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count6!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count6 = value!;
                                              id!.add(val.toString());
                                              val = "6_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count6!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count6 = value!;
                                              id!.add(val.toString());
                                              val = "6_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count6!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count6 = value!;
                                              id!.add(val.toString());
                                              val = "6_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 7
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terdapat busuk basah dengan ukuran kecil diameter kurang dari 1 cm",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count7!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count7 = value!;
                                              id!.add(val.toString());
                                              val = "7_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count7!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count7 = value!;
                                              id!.add(val.toString());
                                              val = "7_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count7!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count7 = value!;
                                              id!.add(val.toString());
                                              val = "7_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count7!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count7 = value!;
                                              id!.add(val.toString());
                                              val = "7_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count7!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count7 = value!;
                                              id!.add(val.toString());
                                              val = "7_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 8
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buah yang tua terdapat kudis berwarna coklat bergabus",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count8!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count8 = value!;
                                              id!.add(val.toString());
                                              val = "8_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count8!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count8 = value!;
                                              id!.add(val.toString());
                                              val = "8_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count8!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count8 = value!;
                                              id!.add(val.toString());
                                              val = "8_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count8!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count8 = value!;
                                              id!.add(val.toString());
                                              val = "8_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count8!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count8 = value!;
                                              id!.add(val.toString());
                                              val = "8_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 9
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Buah mengeluarkan cairan",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count9!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count9 = value!;
                                              id!.add(val.toString());
                                              val = "9_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count9!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count9 = value!;
                                              id!.add(val.toString());
                                              val = "9_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count9!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count9 = value!;
                                              id!.add(val.toString());
                                              val = "9_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count9!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count9 = value!;
                                              id!.add(val.toString());
                                              val = "9_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count9!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count9 = value!;
                                              id!.add(val.toString());
                                              val = "9_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 10
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Permukaan buah menjadi busuk seluruhnya",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count10!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count10 = value!;
                                              id!.add(val.toString());
                                              val = "10_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count10!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count10 = value!;
                                              id!.add(val.toString());
                                              val = "10_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count10!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count10 = value!;
                                              id!.add(val.toString());
                                              val = "10_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count10!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count10 = value!;
                                              id!.add(val.toString());
                                              val = "10_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count10!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count10 = value!;
                                              id!.add(val.toString());
                                              val = "10_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 11
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.green,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/buah.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terdapat bintik hitam berwarna kehitaman pada kulit buah",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count11!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count11 = value!;
                                              id!.add(val.toString());
                                              val = "11_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count11!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count11 = value!;
                                              id!.add(val.toString());
                                              val = "11_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count11!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count11 = value!;
                                              id!.add(val.toString());
                                              val = "11_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count11!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count11 = value!;
                                              id!.add(val.toString());
                                              val = "11_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count11!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count11 = value!;
                                              id!.add(val.toString());
                                              val = "11_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 12
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terdapat bercak pada daun",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count12!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count12 = value!;
                                              id!.add(val.toString());
                                              val = "12_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count12!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count12 = value!;
                                              id!.add(val.toString());
                                              val = "12_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count12!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count12 = value!;
                                              id!.add(val.toString());
                                              val = "12_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count12!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count12 = value!;
                                              id!.add(val.toString());
                                              val = "12_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count12!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count12 = value!;
                                              id!.add(val.toString());
                                              val = "12_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 13
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bercak bagian luar berwarna coklat, sedangkan dalamnya berwarna coklat muda",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count13!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count13 = value!;
                                              id!.add(val.toString());
                                              val = "13_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count13!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count13 = value!;
                                              id!.add(val.toString());
                                              val = "13_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count13!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count13 = value!;
                                              id!.add(val.toString());
                                              val = "13_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count13!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count13 = value!;
                                              id!.add(val.toString());
                                              val = "13_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count13!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count13 = value!;
                                              id!.add(val.toString());
                                              val = "13_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 14
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bercak berbentuk bundar",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count14!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count14 = value!;
                                              id!.add(val.toString());
                                              val = "14_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count14!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count14 = value!;
                                              id!.add(val.toString());
                                              val = "14_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count14!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count14 = value!;
                                              id!.add(val.toString());
                                              val = "14_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count14!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count14 = value!;
                                              id!.add(val.toString());
                                              val = "14_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count14!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count14 = value!;
                                              id!.add(val.toString());
                                              val = "14_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 15
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bercak berwarna kuning bersudut",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count15!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count15 = value!;
                                              id!.add(val.toString());
                                              val = "15_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count15!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count15 = value!;
                                              id!.add(val.toString());
                                              val = "15_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count15!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count15 = value!;
                                              id!.add(val.toString());
                                              val = "15_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count15!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count15 = value!;
                                              id!.add(val.toString());
                                              val = "15_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count15!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count15 = value!;
                                              id!.add(val.toString());
                                              val = "15_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 16
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Daun mengering dan mudah hancur",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count16!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count16 = value!;
                                              id!.add(val.toString());
                                              val = "16_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count16!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count16 = value!;
                                              id!.add(val.toString());
                                              val = "16_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count16!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count16 = value!;
                                              id!.add(val.toString());
                                              val = "16_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count16!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count16 = value!;
                                              id!.add(val.toString());
                                              val = "16_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count16!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count16 = value!;
                                              id!.add(val.toString());
                                              val = "16_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 17
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Daun melepuh dan hancur",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count17!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count17 = value!;
                                              id!.add(val.toString());
                                              val = "17_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count17!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count17 = value!;
                                              id!.add(val.toString());
                                              val = "17_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count17!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count17 = value!;
                                              id!.add(val.toString());
                                              val = "17_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count17!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count17 = value!;
                                              id!.add(val.toString());
                                              val = "17_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count17!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count17 = value!;
                                              id!.add(val.toString());
                                              val = "17_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 18
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Daun belang-belang",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count18!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count18 = value!;
                                              id!.add(val.toString());
                                              val = "18_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count18!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count18 = value!;
                                              id!.add(val.toString());
                                              val = "18_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count18!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count18 = value!;
                                              id!.add(val.toString());
                                              val = "18_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count18!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count18 = value!;
                                              id!.add(val.toString());
                                              val = "18_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count18!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count18 = value!;
                                              id!.add(val.toString());
                                              val = "18_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 21
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bercak berwarna kuning, selanjutnya menjadi coklat",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count21!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count21 = value!;
                                              id!.add(val.toString());
                                              val = "21_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count21!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count21 = value!;
                                              id!.add(val.toString());
                                              val = "21_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count21!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count21 = value!;
                                              id!.add(val.toString());
                                              val = "21_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count21!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count21 = value!;
                                              id!.add(val.toString());
                                              val = "21_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count21!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count21 = value!;
                                              id!.add(val.toString());
                                              val = "21_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 22
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.redAccent,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                              Image(image: AssetImage('asset/icon/daun.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terdapat rumbai-rumbai halus berwarna abu-abu",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count22!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count22 = value!;
                                              id!.add(val.toString());
                                              val = "22_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count22!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count22 = value!;
                                              id!.add(val.toString());
                                              val = "22_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count22!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count22 = value!;
                                              id!.add(val.toString());
                                              val = "22_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count22!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count22 = value!;
                                              id!.add(val.toString());
                                              val = "22_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count22!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count22 = value!;
                                              id!.add(val.toString());
                                              val = "22_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 19
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Image(
                              image: AssetImage('asset/icon/ranting.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Terdapat rumbai-rumbai halus berwarna abu-abu",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count19!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count19 = value!;
                                              id!.add(val.toString());
                                              val = "19_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count19!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count19 = value!;
                                              id!.add(val.toString());
                                              val = "19_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count19!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count19 = value!;
                                              id!.add(val.toString());
                                              val = "19_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count19!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count19 = value!;
                                              id!.add(val.toString());
                                              val = "19_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count19!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count19 = value!;
                                              id!.add(val.toString());
                                              val = "19_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Pertanyaan ke 20
            Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                        color: Colors.blue,
                        width: MediaQuery.of(context).size.height * 0.1,
                        height: MediaQuery.of(context).size.height * 0.16,
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Image(
                              image: AssetImage('asset/icon/ranting.png')),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tanaman kerdil",
                                style: TextStyle(
                                    fontSize: 12.sp, fontFamily: 'Poppin'),
                              ),
                              const SizedBox(height: 5),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MyRadioListTile<int>(
                                          value: 5,
                                          groupValue: count20!,
                                          leading: '5',
                                          onChanged: (value) {
                                            setState(() {
                                              count20 = value!;
                                              id!.add(val.toString());
                                              val = "20_5";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 4,
                                          groupValue: count20!,
                                          leading: '4',
                                          onChanged: (value) {
                                            setState(() {
                                              count20 = value!;
                                              id!.add(val.toString());
                                              val = "20_4";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 3,
                                          groupValue: count20!,
                                          leading: '3',
                                          onChanged: (value) {
                                            setState(() {
                                              count20 = value!;
                                              id!.add(val.toString());
                                              val = "20_3";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 2,
                                          groupValue: count20!,
                                          leading: '2',
                                          onChanged: (value) {
                                            setState(() {
                                              count20 = value!;
                                              id!.add(val.toString());
                                              val = "20_2";
                                              print(val);
                                            });
                                          }),
                                      MyRadioListTile<int>(
                                          value: 1,
                                          groupValue: count20!,
                                          leading: '1',
                                          onChanged: (value) {
                                            setState(() {
                                              count20 = value!;
                                              id!.add(val.toString());
                                              val = "20_1";
                                              print(val);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70.0),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 1,
            elevation: 0,
            onPressed: ambildata,
            // onPressed: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => HasilDiagnosa(),
            //     ),
            //   );
            // },
            label: Text('Proses',
                style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppin')),
            icon: const Icon(Icons.analytics),
          ),
          FloatingActionButton.small(
            heroTag: 2,
            elevation: 0,
            backgroundColor: Colors.amber,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FormDiagnosa(),
                ),
              );
            },
            child: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  int? count12 = 0;
  int? count13 = 0;
  int? count14 = 0;
  int? count15 = 0;
  int? count16 = 0;
  int? count17 = 0;
  int? count18 = 0;
  int? count19 = 0;
  int? count20 = 0;
  int? count21 = 0;
  int? count22 = 0;
}
