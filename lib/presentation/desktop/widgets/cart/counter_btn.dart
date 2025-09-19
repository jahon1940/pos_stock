import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/styles/colors.dart';

class CounterBtn extends StatelessWidget {
  const CounterBtn({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.stroke, // фон кнопки
        borderRadius: BorderRadius.circular(8), // округление
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        splashRadius: 20, // радиус эффекта нажатия
      ),
    );
  }
}
