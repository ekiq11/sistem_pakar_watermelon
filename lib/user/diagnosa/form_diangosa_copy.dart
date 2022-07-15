// ignore_for_file: prefer_interpolation_to_compose_strings, equal_keys_in_map, unnecessary_null_comparison, avoid_print, prefer_const_constructors

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
  Future<List<dynamic>?> _fetchDiagnosa() async {
    var result = await http.get(Uri.parse(BaseURL.diagnosaGejala));
    return json.decode(result.body)['data'];
  }

  @override
  void initState() {
    getPref();

    super.initState();
  }

  int? count = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 251, 235),
      appBar: AppBar(
        elevation: 0,
        title: Text('Form Diagnosa',
            style: TextStyle(fontSize: 12.sp, fontFamily: 'Poppin')),
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
            FutureBuilder<List<dynamic>?>(
              future: _fetchDiagnosa(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, index) {
                      return Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.16,
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        color: snapshot.data![index]
                                                    ['kategori'] ==
                                                'BUAH'
                                            ? Colors.green
                                            : snapshot.data![index]
                                                        ['kategori'] ==
                                                    'DAUN'
                                                ? Colors.blue
                                                : Colors.amber,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.16,
                                        child: snapshot.data![index]
                                                    ['kategori'] ==
                                                'BUAH'
                                            ? const Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Image(
                                                    image: AssetImage(
                                                        'asset/icon/buah.png')),
                                              )
                                            : snapshot.data![index]
                                                        ['kategori'] ==
                                                    'DAUN'
                                                ? const Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Image(
                                                        image: AssetImage(
                                                            'asset/icon/daun.png')),
                                                  )
                                                : const Padding(
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Image(
                                                        image: AssetImage(
                                                            'asset/icon/ranting.png')),
                                                  ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, bottom: 15.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data![index]
                                                        ['nama_gejala']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Poppin'),
                                              ),
                                              const SizedBox(height: 5),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      MyRadioListTile<int>(
                                                          value: 5,
                                                          groupValue: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          leading: '5',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              value = int.parse(
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'kode_gejala']);
                                                              id!.add(val
                                                                  .toString());
                                                              val =
                                                                  "${snapshot.data![index]['kode_gejala']}_5";
                                                              print(val);
                                                            });
                                                          }),
                                                      MyRadioListTile<int>(
                                                          value: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          groupValue: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          leading: '4',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              value = int.parse(
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'kode_gejala']);
                                                              id!.add(val
                                                                  .toString());
                                                              val =
                                                                  "${snapshot.data![index]['kode_gejala']}_4";
                                                              print(val);
                                                            });
                                                          }),
                                                      MyRadioListTile<int>(
                                                          value: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          groupValue: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          leading: '3',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              value = int.parse(
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'kode_gejala']);
                                                              id!.add(val
                                                                  .toString());
                                                              val =
                                                                  "${snapshot.data![index]['kode_gejala']}_3";
                                                              print(val);
                                                            });
                                                          }),
                                                      MyRadioListTile<int>(
                                                          value: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          groupValue: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          leading: '2',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              value = int.parse(
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'kode_gejala']);
                                                              id!.add(val
                                                                  .toString());
                                                              val =
                                                                  "${snapshot.data![index]['kode_gejala']}_2";
                                                              print(val);
                                                            });
                                                          }),
                                                      MyRadioListTile<int>(
                                                          value: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          groupValue: int.parse(
                                                              snapshot.data![
                                                                      index][
                                                                  'kode_gejala']),
                                                          leading: '1',
                                                          onChanged: (value) {
                                                            setState(() {
                                                              value = int.parse(
                                                                  snapshot.data![
                                                                          index]
                                                                      [
                                                                      'kode_gejala']);

                                                              id!.add(val
                                                                  .toString());
                                                              val =
                                                                  "${snapshot.data![index]['kode_gejala']}_1";
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
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            const SizedBox(height: 70.0)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
