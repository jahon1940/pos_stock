import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/styles/colors.dart';

@RoutePage()
class CompanyInfoScreen extends HookWidget {
  const CompanyInfoScreen({super.key, @PathParam('id') this.companyId,});
  final int? companyId;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            AppSpace.vertical2,
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 8)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.stroke, width: 1.5),
                      borderRadius: BorderRadius.circular(10)),

                ),
              ),
            ),
            AppSpace.vertical12,

          ],
        ),
      ),
    );
  }
}
