import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/styles/colors.dart';

class CustomSquareIconBtn extends StatelessWidget {
  const CustomSquareIconBtn(
    this.iconData, {
    super.key,
    this.size = 40,
    this.backgrounColor,
    this.iconColor,
    this.onTap,
    this.darkenColors = false,
  });

  final IconData iconData;
  final double size;
  final Color? backgrounColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  static const _radius = AppUtils.kBorderRadius12;
  final bool darkenColors;

  @override
  Widget build(
    BuildContext context,
  ) {
    final color = backgrounColor ?? AppColors.primary500;
    return SizedBox(
      height: size,
      width: size,
      child: Material(
        borderRadius: _radius,
        elevation: 3,
        color: color,
        child: InkWell(
          onTap: onTap,
          hoverColor: darkenColors ? color.darken(10) : color.lighten(20),
          highlightColor: darkenColors ? color.darken(20) : color.lighten(50),
          splashColor: darkenColors ? color.darken(30) : color.lighten(50),
          borderRadius: _radius,
          child: Icon(
            iconData,
            color: iconColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
