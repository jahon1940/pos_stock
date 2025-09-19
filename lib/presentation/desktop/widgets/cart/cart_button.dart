import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../core/styles/colors.dart';
import '../../../../core/styles/text_style.dart';

class CartButton extends StatelessWidget {
  const CartButton(
      {super.key,
      required this.text,
      this.subText,
      required this.width,
      required this.onTap,
      required this.height,
      required this.color,
      this.boxShadow,
      this.textColor,
      this.icon,
      this.iconColor,
      this.borderColor});

  final String text;
  final String? subText;
  final Color color;
  final Color? boxShadow;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        hoverColor: AppColors.primary500,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            height: height,
            width: width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: borderColor ?? AppColors.primary500, // Новый параметр
                  width:
                      0.5, // Можете изменить толщину границы при необходимости
                ),
                boxShadow: [
                  BoxShadow(
                    color: boxShadow ?? AppColors.stroke,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: icon == null
                  ? Center(
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.boldType14.copyWith(
                          color: textColor ?? AppColors.secondary900,
                        ),
                      ),
                    )
                  : Center(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: height,
                              width: width! * .2,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: boxShadow ?? AppColors.primary500,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  icon,
                                  color: AppColors.primary500,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          AppSpace.horizontal6,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width! * 0.52,
                                child: Text(
                                  text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.rType12.copyWith(
                                    color: textColor ?? AppColors.secondary500,
                                  ),
                                ),
                              ),
                              if (subText != null)
                                Text(
                                  subText ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: AppTextStyles.boldType14.copyWith(
                                    fontSize: 10,
                                    color: textColor ?? AppColors.secondary900,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
