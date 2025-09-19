import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

class ProductText extends StatelessWidget {
  final String text;
  final bool? alignEnd;

  const ProductText({super.key, required this.text, this.alignEnd = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Text(text,
            maxLines: 1,
            style: AppTextStyles.mType14,
            textAlign: alignEnd ?? false ? TextAlign.end : TextAlign.center));
  }
}
