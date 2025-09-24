import 'package:flutter/cupertino.dart';

extension CopyWithExtension on EdgeInsets {
  /// updating
  EdgeInsets withLeft(double val) => copyWith(left: val);

  EdgeInsets withTop(double val) => copyWith(top: val);

  EdgeInsets withRight(double val) => copyWith(right: val);

  EdgeInsets withBottom(double val) => copyWith(bottom: val);

  EdgeInsets get withT0 => copyWith(top: 0);

  EdgeInsets get withB0 => copyWith(bottom: 0);

  /// adding
  EdgeInsets addToLeft(double val) => copyWith(left: left + val);

  EdgeInsets addToTop(double val) => copyWith(top: top + val);

  EdgeInsets addToRight(double val) => copyWith(right: right + val);

  EdgeInsets addToBottom(double val) => copyWith(bottom: bottom + val);
}
