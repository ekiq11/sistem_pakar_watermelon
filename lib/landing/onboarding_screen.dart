import 'package:flutter/material.dart';

import 'botton_buttons.dart';
import 'explanation.dart';

final List<ExplanationData> data = [
  ExplanationData(
      description: "Sistem pakar penyakit pada tanaman semangka",
      title: "Sistem Pakar",
      subtitle: "Watermelon",
      localImageSrc: "asset/img/splas1.jpg"),
  ExplanationData(
      description: "Memudahkan analisis penyakit tanaman lebih cepat",
      title: "Sistem Pakar",
      subtitle: "Analisis Cepat",
      localImageSrc: "asset/img/splash2.jpg"),
  ExplanationData(
      description: "Predikisi sejak dini penyakit pada tanaman",
      title: "Sistem Pakar",
      subtitle: "Mudah dan Praktis",
      localImageSrc: "asset/img/splash3.jpg"),
];

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> /*with ChangeNotifier*/ {
  final _controller = PageController();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: mediaQueryHeight,
        width: mediaQueryWidth,
        color: Colors.white,
        child: Container(
          height: mediaQueryHeight,
          width: mediaQueryWidth,
          color: data[_currentIndex].backgroundColor,
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        height: mediaQueryHeight,
                        width: mediaQueryWidth,
                        alignment: Alignment.center,
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          controller: _controller,
                          onPageChanged: (value) {
                            // _painter.changeIndex(value);
                            setState(() {
                              _currentIndex = value;
                            });
                            // notifyListeners();
                          },
                          children: data
                              .map((e) => ExplanationPage(data: e))
                              .toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(data.length,
                                (index) => createCircle(index: index)),
                          ),
                          BottomButtons(
                            currentIndex: _currentIndex,
                            dataLength: data.length,
                            controller: _controller,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  createCircle({int? index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: const EdgeInsets.only(right: 4),
      height: 5,
      width: _currentIndex == index ? 15 : 5,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
