import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class WeatherPictureWidget extends StatelessWidget {
  String pictureName;
  WeatherPictureWidget({super.key, required this.pictureName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: Container(
                width: 110,
                height: 110,
                color: const Color(0xff976be0),
              ),
            ),
          ),
        ),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/images/3d/$pictureName.png')),
          ),
        ),
      ],
    );
  }
}
