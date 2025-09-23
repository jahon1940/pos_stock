import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/icons/app_icons.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';

import '../../../../../app/di.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../domain/services/user_data.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/cubit/user_cubit.dart';

part 'user_card.dart';

part 'sidebar_item.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  final List<({Widget Function(bool isSelected) icon, String name, PageRouteInfo<void> route})> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(
    BuildContext context,
  ) {
    ThemeData themeData = Theme.of(context);
    final userDataService = getIt<UserDataService>();
    return SizedBox(
      width: isCollapsed ? 75 : 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themeData.cardColor,
          border: Border(right: BorderSide(color: context.theme.dividerColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: SizedBox(
                    height: 120,
                    child: Row(
                      spacing: 10,
                      children: [
                        if (isCollapsed)
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.primary100.withOpacity(0.5),
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.person,
                                    color: AppColors.primary500,
                                  ),
                                  onPressed: () {},
                                )),
                          )
                        else
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: UserCard(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              AppSpace.vertical12,
              Divider(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        color: context.primary,
                        isCollapsed ? AppIcons.maxSidebar : AppIcons.minSidebar,
                        width: 25,
                        height: 25,
                      ),
                      onPressed: onToggleCollapse,
                    ),
                    if (!isCollapsed)
                      GestureDetector(
                        onTap: onToggleCollapse,
                        child: Text(
                          'MENU',
                          style: AppTextStyles.mType12
                              .copyWith(color: context.primary, fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      ),
                  ],
                ),
              ),
              Divider(height: 10),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: SidebarItem(
                        leadingIcon: item.icon(index == selectedIndex),
                        label: isCollapsed ? "" : item.name.tr(),
                        isSelected: index == selectedIndex,
                        selectedColor: context.primary,
                        selectedTextColor: Colors.white,
                        onTap: () => onTap(index),
                      ),
                    );
                  },
                ),
              ),
              if (!isCollapsed) ...[
                SidebarItem(
                  onTap: () async {
                    userDataService.setUnlocked(true);
                    await context.router.push(LockerRoute(
                      isFirstAuth: false,
                      onResult: () => context.router.replace(MainRoute()),
                    ));
                  },
                  label: context.tr("lock"),
                  selectedColor: AppColors.primary100.withOpacity(0.5),
                  selectedTextColor: AppColors.primary500,
                  leadingIcon: Icon(
                    AppIcons.lock,
                    color: AppColors.primary500,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(color: Colors.blue),
                //   ),
                //   padding: const EdgeInsets.all(4),
                //   child: Row(
                //     children: [
                //       Image.asset('assets/images/hoomo_ai.gif', height: 35),
                //       AppSpace.horizontal12,
                //       Text(
                //         'hoomo AI',
                //         style: TextStyle(
                //           fontSize: 25.0,
                //           fontWeight: FontWeight.bold,
                //           foreground: Paint()..shader = linearGradient,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
