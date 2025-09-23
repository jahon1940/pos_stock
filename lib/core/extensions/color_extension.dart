import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color opcty(double val) => val == 1 ? this : withValues(alpha: val);
}
