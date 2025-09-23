import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';

extension CopyWith on TextStyle {
  /// copy with color
  TextStyle withOpacity(double? val) => copyWith(color: color?.opcty(val ?? 1));

  TextStyle withColor(Color? color) => copyWith(color: color);

  TextStyle get withColorWhite => copyWith(color: Colors.white);

  TextStyle get withColorBlack => copyWith(color: Colors.black);

  /// copy with size
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// copy with Weight
  TextStyle withW(FontWeight weight) => copyWith(fontWeight: weight);

  TextStyle get withWRegular => copyWith(fontWeight: FontWeight.w400);

  TextStyle get withWMedium => copyWith(fontWeight: FontWeight.w500);

  TextStyle get withWSemibold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get withWBold => copyWith(fontWeight: FontWeight.w700);

  TextStyle get withW100 => copyWith(fontWeight: FontWeight.w100);

  TextStyle get withW200 => copyWith(fontWeight: FontWeight.w200);

  TextStyle get withW300 => copyWith(fontWeight: FontWeight.w300);

  TextStyle get withW400 => copyWith(fontWeight: FontWeight.w400);

  TextStyle get withW500 => copyWith(fontWeight: FontWeight.w500);

  TextStyle get withW600 => copyWith(fontWeight: FontWeight.w600);

  TextStyle get withW700 => copyWith(fontWeight: FontWeight.w700);

  TextStyle get withW800 => copyWith(fontWeight: FontWeight.w800);

  TextStyle get withW900 => copyWith(fontWeight: FontWeight.w900);

  /// copy with height

  TextStyle withHeight(double height) => copyWith(height: height);

  TextStyle get withHeight1 => copyWith(height: 1);

  TextStyle get withHeight11 => copyWith(height: 1.1);

  TextStyle get withHeight12 => copyWith(height: 1.2);

  TextStyle get withHeight14 => copyWith(height: 1.4);

  TextStyle get withHeight2 => copyWith(height: 2);

  /// copy with overflow
  TextStyle get withOverflowEllipsis => copyWith(overflow: TextOverflow.ellipsis);
}
