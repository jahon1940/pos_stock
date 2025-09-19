import 'package:flutter/cupertino.dart';

class BottomZigzagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var smallLineLength = size.width / 30;
    const smallLineHeight = 10.0;
    var path = Path();

    for (int i = 1; i <= 30; i++) {
      if (i % 2 == 0) {
        path.lineTo(smallLineLength * i, 0);
      } else {
        path.lineTo(smallLineLength * i, smallLineHeight);
      }
    }

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}