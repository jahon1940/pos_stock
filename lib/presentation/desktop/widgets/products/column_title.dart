import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

class ColumnTitle extends StatelessWidget {
  final String title;

  const ColumnTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
          padding: EdgeInsets.only(top: 11, left: 20),
          child: Text(
            title,
            style: AppTextStyles.boldType14,
          )),
    );
  }
}