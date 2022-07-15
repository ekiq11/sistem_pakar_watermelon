import 'package:flutter/material.dart';

class ExplanationData {
  final String? subtitle;
  final String? title;
  final String? description;
  final String? localImageSrc;
  final Color? backgroundColor;

  ExplanationData(
      {this.title,
      this.description,
      this.localImageSrc,
      this.backgroundColor,
      this.subtitle});
}

class ExplanationPage extends StatelessWidget {
  final ExplanationData? data;

  // ignore: use_key_in_widget_constructors
  const ExplanationPage({this.data});

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
            width: mediaQueryWidth * 0.8,
            margin: const EdgeInsets.only(top: 40.0),
            child: Image.asset(data!.localImageSrc.toString(),
                height: mediaQueryHeight * 0.5, alignment: Alignment.center)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data!.title.toString(),
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data!.subtitle.toString(),
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: mediaQueryWidth * 0.5,
                child: Text(
                  data!.description.toString(),
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
