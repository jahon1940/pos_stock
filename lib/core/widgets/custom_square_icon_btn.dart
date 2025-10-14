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
    required this.onTap,
  });

  final IconData iconData;
  final double size;
  final Color? backgrounColor;
  final Color? iconColor;
  final VoidCallback onTap;
  static const _radius = AppUtils.kBorderRadius12;

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
          hoverColor: color.lighten(20),
          splashColor: color.lighten(50),
          borderRadius: _radius,
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
