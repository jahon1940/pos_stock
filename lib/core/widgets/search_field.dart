import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../constants/spaces.dart';
import '../styles/colors.dart';
import '../styles/text_style.dart';

class SearchField extends StatelessWidget {
  const SearchField(
      {super.key,
      required this.onTap,
      required this.hintText,
      this.flex,
      required this.icon});

  final Function() onTap;
  final String hintText;
  final int? flex;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Material(
        child: InkWell(
          hoverColor: context.theme.hoverColor,
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: AppColors.primary100.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: context.secondary.withOpacity(0.5), width: 0.5)),
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.stroke),
                        boxShadow: [
                          BoxShadow(color: AppColors.white, blurRadius: 3)
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: icon,
                      ),
                    ),
                    AppSpace.horizontal12,
                    Text(hintText,
                        style: AppTextStyles.mType12.copyWith(
                          color: AppColors.primary500,
                        )),
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
