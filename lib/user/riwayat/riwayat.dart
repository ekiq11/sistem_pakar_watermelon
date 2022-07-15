// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print, prefer_const_constructors, unnecessary_null_comparison, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sipakar_water_melon/user/riwayat/model_riwayat/model_riwayat.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../api/api.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
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

  Future<List<dynamic>?> _fetchRiwayat() async {
    var result = await http.get(Uri.parse(BaseURL.riwayat + "$nama"));
    var hasil = json.decode(result.body)['data'];
    print(hasil);
    return hasil;
  }

  String? jsonContent;

  //AlertDa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 251, 235),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("Data Riwayat",
              style: TextStyle(
                  fontSize: 12.sp, fontFamily: 'Poppin', color: Colors.white)),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: _fetchRiwayat(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Dismissible(
                    direction: DismissDirection.startToEnd,
                    key: Key(snapshot.data![index]['id_hasil']),
                    onDismissed: (direction) async {
                      // Removes that item the list on swipwe
                      final res = await http.get(Uri.parse(
                          BaseURL.hapus + snapshot.data![index]['id_hasil']));
                      if (res.statusCode == 200) {
                        // Shows the information on Snackbar
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.info(
                            message: "Data berhasil dihapus dari riwayat anda",
                          ),
                        );
                      } else {
                        showTopSnackBar(
                          context,
                          const CustomSnackBar.error(
                            message: "Gagal di hapus",
                          ),
                        );
                      }
                    },
                    background: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Row(
                            children: [
                              const Icon(Icons.delete_forever,
                                  color: Colors.white),
                              Text("Hapus Data",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Poppin',
                                      color: Colors.white))
                            ],
                          ),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 20.0),
                      child: InkWell(
                        onTap: () async {
                          final result = await http.get(
                            Uri.parse(BaseURL.detailRiwayat +
                                snapshot.data![index]['id_hasil']),
                          );
                          print(result);
                          final jsonData = json.decode(result.body);

                          ModelRiwayat riwayat =
                              ModelRiwayat.fromJson(jsonData);
                          setState(() {
                            jsonContent = riwayat.toString();
                          });
                          print(riwayat);
                          if (result.statusCode == 200) {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    insetPadding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        top: 5.0,
                                        bottom: 5.0),
                                    title: Text(
                                        riwayat.hasilDiagnosa.toString(),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Poppin')),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          for (int i = 0;
                                              i < riwayat.namaGejala!.length;
                                              i++)
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "G" +
                                                      riwayat.kodeGejala![i]
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: 'Poppin',
                                                      fontWeight:
                                                          FontWeight.w800),
                                                ),
                                                const SizedBox(width: 10.0),
                                                Expanded(
                                                  child: Container(
                                                    width: 20.0,
                                                    child: Text(
                                                      "" +
                                                          riwayat.namaGejala![i]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontFamily: 'Poppin'),
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
                                            riwayat.detailPenyakit.toString(),
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: 'Poppin'),
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
                                          Text(riwayat.pengendalian.toString(),
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Poppin')),
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
                                          for (int x = 0;
                                              x <
                                                  riwayat
                                                      .kemungkinanLain!.length;
                                              x++)
                                            Text(
                                                riwayat.kemungkinanLain!
                                                            .length !=
                                                        null
                                                    ? riwayat
                                                        .kemungkinanLain![x]
                                                        .toString()
                                                    : "Tidak ada kemungkinan lainnya",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontFamily: 'Poppin')),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      SizedBox(
                                        height: 50.0,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: const StadiumBorder(),
                                              primary:
                                                  Colors.green, // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.close),
                                                Center(
                                                  child: Text('Tutup',
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
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
                        },
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
                                  child: const Icon(Icons.history,
                                      color: Colors.white, size: 32.0),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          snapshot.data![index]
                                              ['nama_penyakit'],
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppin')),
                                      Text(snapshot.data![index]['tanggal'],
                                          style: const TextStyle(
                                              color: Colors.grey))
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 15.0),
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                    image: AssetImage("asset/icon/empty.webp"), width: 100.0),
                Text("Maaf, belum ada riwayat",
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppin')),
              ],
            ),
          );
        },
      ),
    );
  }
}
