import 'package:flutter/cupertino.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class CustomBox extends StatelessWidget {
  const CustomBox({super.key, required this.child, this.color, this.padding});

  final Color? color;
  final EdgeInsets? padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? context.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: context.theme.dividerColor, blurRadius: 3)
          ],
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(6),
          child: child,
        ));
  }
}
