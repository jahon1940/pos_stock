import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/icons/app_icons.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/app_tile.dart';
import 'package:hoomo_pos/core/widgets/user_card.dart';
import 'package:hoomo_pos/presentation/desktop/screens/cubit/user_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/main/cubit/socket_cubit.dart';

import '../../../../app/di.dart';
import '../../../../core/constants/spaces.dart';
import '../../../../core/styles/colors.dart';
import '../../../../domain/services/user_data.dart';

@RoutePage()
class MainScreen extends HookWidget {
  const MainScreen({super.key});

  static final _items = [
    (
      icon: (bool isSelected) => Icon(
            AppIcons.product,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.catalog',
      route: SearchRoute(),
    ),
    (
      icon: (bool isSelected) => Icon(
            AppIcons.user,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.clients',
      route: CompaniesRoute(),
    ),
    (
      icon: (bool isSelected) => Icon(
            Icons.list_alt,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.supplies',
      route: Supplies1CParentRoute(),
    ),
    (
      icon: (bool isSelected) => Icon(
            Icons.document_scanner_outlined,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.reports',
      route: ReportsParentRoute(),
    ),

    (
      icon: (bool isSelected) => Icon(
            AppIcons.receipt_3,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.shifts',
      route: ShiftsRoute(),
    ),
    (
      icon: (bool isSelected) => Icon(
            AppIcons.product,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.stock',
      route: StockParentRoute(),
    ),
    (
      icon: (bool isSelected) => Icon(
            AppIcons.setting_2,
            color: !isSelected ? AppColors.primary500 : Colors.white,
          ),
      name: 'sidebar.settings',
      route: SettingsRoute(),
    ),
    // (
    //   icon: (bool isSelected) => Image.asset(
    //         'assets/images/mirel.png',
    //         width: 24,
    //         height: 24,
    //         // color: isSelected ? Colors.blue : null, // если PNG поддерживает tint
    //       ),
    //   name: 'mirel.uz',
    //   route: OrderRoute(),
    // )
  ];

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(false);

    useEffect(() {
      context.read<SocketCubit>().init();
      context.read<SocketCubit>().connect();
      // context.read<SocketCubit>().startPeriodicUnsentReceiptSync();
      context.read<UserCubit>().init();

      return null;
    }, const []);

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => previous.manager != current.manager,
      builder: (context, state) {
        if (state.manager == null) {
          return SizedBox();
        }

        if (state.manager?.pos?.integration_with_1c ?? false) {
          _items.removeWhere((e) => e.name == 'sidebar.stock');
          // _items.removeWhere((e) => e.name == 'Отчеты');
        } else {
          _items.removeWhere((e) => e.name == 'Поступление товара');
          _items.removeWhere((e) => e.name == 'sidebar.reserve');
        }

        return AutoTabsRouter.builder(
          routes: _items.map((e) => e.route).toList(),
          homeIndex: 0,
          builder: (context, children, tabsRouter) {
            return Scaffold(
              backgroundColor: const Color(0xFFF9F9F9),
              body: Row(
                children: [
                  BlocBuilder<SocketCubit, SocketState>(builder: (context, state) {
                    if (state.posManager?.pos?.integration_with_1c ?? false) {
                      //_items = _items.where((item) => item.name != 'sidebar.stock').toList();
                    }
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isCollapsed.value ? 75 : 220,
                      child: AppSidebar(
                        items: _items,
                        selectedIndex: tabsRouter.activeIndex,
                        onTap: tabsRouter.setActiveIndex,
                        isCollapsed: isCollapsed.value,
                        onToggleCollapse: () {
                          isCollapsed.value = !isCollapsed.value;
                        },
                      ),
                    );
                  }),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Shortcuts(
                      shortcuts: {
                        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyF): ActivateIntent(),
                        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF): ActivateIntent(),
                      },
                      child: Actions(
                        actions: {
                          ActivateIntent: CallbackAction<ActivateIntent>(
                            onInvoke: (intent) {
                              // handle Ctrl/Cmd+F
                              return true;
                            },
                          ),
                        },
                        child: Focus(
                          autofocus: true,
                          child: children[tabsRouter.activeIndex],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

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
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    final userDataService = getIt<UserDataService>();

    return SizedBox(
      width: isCollapsed ? 75 : 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: themeData.cardColor,
          border: Border(
            right: BorderSide(color: context.theme.dividerColor),
          ),
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
                          ),
                        if (!isCollapsed)
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
                      child: AppTile(
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
                AppTile(
                  onTap: () async {
                    userDataService.setUnlocked(true);
                    await context.router.push(LockerRoute(
                      isFirstAuth: false,
                      onResult: () {
                        context.router.replace(MainRoute());
                      },
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
