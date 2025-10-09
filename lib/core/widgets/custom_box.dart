import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class CustomBox extends StatelessWidget {
  const CustomBox({
    super.key,
    required this.child,
    this.color,
    this.padding,
  });

  final Color? color;
  final EdgeInsets? padding;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: padding ?? AppUtils.kPaddingAll6,
        decoration: BoxDecoration(
          color: color ?? context.cardColor,
          borderRadius: AppUtils.kBorderRadius12,
          boxShadow: [BoxShadow(color: context.theme.dividerColor, blurRadius: 3)],
        ),
        child: child,
      );
}
