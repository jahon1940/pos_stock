import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';

import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../../../data/dtos/company/company_dto.dart';
import 'widgets/supplier_details_widget.dart';
import 'cubit/supplier_cubit.dart';
import 'widgets/image_supplier.dart';
import 'widgets/supplier_navbar.dart';

@RoutePage()
class AddSupplierScreen extends HookWidget implements AutoRouteWrapper {
  const AddSupplierScreen(
    this.organizations, {
    super.key,
    this.supplierDto,
  });

  final SupplierDto? supplierDto;
  final CompanyDto organizations;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        backgroundColor: AppColors.softGrey,
        body: Padding(
          padding: AppUtils.kPaddingAll12,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                height: 60,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                          ),
                          child: InkWell(
                            onTap: () => context.pop(),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(16, 12, 10, 12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    AppSpace.horizontal12,
                    Text('Поставщик : ${supplierDto?.name ?? ""}',
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                        children: const [
                          SupplierDetailsWidget(),
                          AppSpace.vertical24,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: double.maxFinite,
                      width: 360,
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(0, 11, 24, 24),
                        children: const [
                          ImageSupplier(),
                          // AppSpace.vertical24,
                          // ProductPublicationStatus()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(12),
          child: SupplierNavbar(),
        ),
      );

  @override
  Widget wrappedRoute(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<SupplierCubit>()..init(supplierDto),
        child: this,
      );
}
