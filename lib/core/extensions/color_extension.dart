import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  String get hex {
    final hex = (r.rgbValue << 16) | (g.rgbValue << 8) | (b.rgbValue);
    return '0x${hex.toRadixString(16).padLeft(8, 'F').toUpperCase()}';
  }

  Color opcty(double val) => val == 1 ? this : withValues(alpha: val);

  Color darken(int percent) => Color.fromRGBO(
        r.rgbValue - (r.rgbValue * percent.clamp(0, 100) / 100).toInt(),
        g.rgbValue - (g.rgbValue * percent.clamp(0, 100) / 100).toInt(),
        b.rgbValue - (b.rgbValue * percent.clamp(0, 100) / 100).toInt(),
        1,
      );

  Color lighten(int percent) => Color.fromRGBO(
        r.rgbValue + ((255 - r.rgbValue) * percent.clamp(0, 100) / 100).toInt(),
        g.rgbValue + ((255 - g.rgbValue) * percent.clamp(0, 100) / 100).toInt(),
        b.rgbValue + ((255 - b.rgbValue) * percent.clamp(0, 100) / 100).toInt(),
        1,
      );
}

extension on double {
  int get rgbValue => (this * 255).toInt();
}
