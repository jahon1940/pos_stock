import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/cubit/add_manager_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/widgets/details_manager.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/widgets/image_manager.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/widgets/manager_navbar.dart';
import '../../../../../../app/router.dart';
import '../../../../../../app/router.gr.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../../../data/dtos/company_dto.dart';

@RoutePage()
class AddManagerScreen extends HookWidget implements AutoRouteWrapper {
  const AddManagerScreen(this.organizations, {super.key, this.managerDto});

  final ManagerDto? managerDto;
  final CompanyDto organizations;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: AppColors.softGrey,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: AppColors.stroke, blurRadius: 3)
                  ],
                ),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: AppColors.stroke, blurRadius: 3)
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              router.push(
                                  StocksRoute(organizations: organizations));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 10, 12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    AppSpace.horizontal12,
                    Text('Сотрудник : ${managerDto?.name ?? ""}',
                        style: AppTextStyles.boldType14
                            .copyWith(fontWeight: FontWeight.w600)),
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
                          DetailsManager(),
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
                          ImageManager(),
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: const ManagerNavbar(),
        ));
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddManagerCubit>()..init(managerDto),
      child: this,
    );
  }
}
