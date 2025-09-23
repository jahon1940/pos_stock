import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/icons/app_icons.dart';
import 'package:hoomo_pos/presentation/desktop/screens/cubit/user_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/main/cubit/socket_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/main/widgets/app_sidebar.dart';

import '../../../../core/styles/colors.dart';

@RoutePage()
class MainScreen extends HookWidget {
  const MainScreen({
    super.key,
  });

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
          builder: (context, children, tabsRouter) => Scaffold(
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
          ),
        );
      },
    );
  }
}
