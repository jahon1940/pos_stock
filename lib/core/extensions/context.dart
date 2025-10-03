import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/inventories/cubit/inventory_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/supplies/cubit/supply_cubit.dart';
import '../../presentation/desktop/dialogs/category/bloc/category_bloc.dart';
import '../../presentation/desktop/screens/manager/children/cubit/manager_cubit.dart';
import '../../presentation/desktop/screens/reports/children/cubit/reports_cubit.dart';
import '../../presentation/desktop/screens/search/cubit/search_bloc.dart';
import '../../presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import '../../presentation/desktop/screens/stock/screens/organizations/cubit/organization_cubit.dart';
import '../../presentation/desktop/screens/supplier/children/cubit/supplier_cubit.dart';

extension BuildContextEntension<T> on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mq => MediaQuery.of(this);

  // COLORS
  Color get primaryColor => theme.primaryColor;

  Color get primaryColorDark => theme.primaryColorDark;

  Color get primaryColorLight => theme.primaryColorLight;

  Color get primary => theme.colorScheme.primary;

  Color get onPrimary => theme.colorScheme.onPrimary;

  Color get secondary => theme.colorScheme.secondary;

  Color get onSecondary => theme.colorScheme.onSecondary;

  Color get cardColor => theme.cardColor;

  Color get errorColor => theme.colorScheme.error;

  Color get background => theme.scaffoldBackgroundColor;

  ColorScheme get colorScheme => theme.colorScheme;

  // RESPONSIBILITY

  bool get isTablet => (orientation != Orientation.landscape ? mq.size.width : mq.size.height) >= 500.0;

  bool get sizeS => size.shortestSide < 600;

  double get aspectRatio => MediaQuery.of(this).size.aspectRatio;

  double get width => mq.size.width;

  double get height => mq.size.height;

  TextScaler get textScaler => mq.textScaler;

  Size get size => mq.size;

  bool get isLandscape => mq.orientation == Orientation.landscape;

  Orientation get orientation => mq.orientation;

  double get devicePixelRatio => mq.devicePixelRatio;

  // TEXT STYLES
  TextStyle? get displayMedium => textTheme.displayMedium;

  TextStyle? get displaySmall => textTheme.displaySmall;

  TextStyle? get headlineLarge => textTheme.headlineLarge;

  TextStyle? get headlineMedium => textTheme.headlineMedium;

  TextStyle? get headlineSmall => textTheme.headlineSmall;

  TextStyle? get titleLarge => textTheme.titleLarge;

  TextStyle? get titleMedium => textTheme.titleMedium;

  TextStyle? get titleSmall => textTheme.titleSmall;

  TextStyle? get labelLarge => textTheme.labelLarge;

  TextStyle? get labelMedium => textTheme.labelMedium;

  TextStyle? get labelSmall => textTheme.labelSmall;

  TextStyle? get bodyLarge => textTheme.bodyLarge;

  TextStyle? get bodyMedium => textTheme.bodyMedium;

  TextStyle? get bodySmall => textTheme.bodySmall;

  TextStyle? get bodyLargeSemibold => bodyMedium?.copyWith(fontWeight: FontWeight.w600);

  TextStyle? get bodyMediumSemibold => bodyMedium?.copyWith(fontWeight: FontWeight.w600);

  TextStyle? get bodySmallSemibold => bodySmall?.copyWith(fontWeight: FontWeight.w600);

  TextStyle? get bodyMediumUnderline => bodySmall?.copyWith(decoration: TextDecoration.underline);

  TextStyle? get headlineSmall2 => headlineSmall?.copyWith(
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
      );

  TextStyle? get headlineSmall3 => headlineSmall?.copyWith(
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
      );

  TextStyle? get labelLargeSemibold => labelLarge?.copyWith(fontWeight: FontWeight.w600);

  TextStyle? get labelLargeMedium => labelLarge?.copyWith(fontWeight: FontWeight.w500);

  TextStyle? get labelLargeUnderline => labelLarge?.copyWith(decoration: TextDecoration.underline);

  // POP UPS
  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) =>
      showModalBottomSheet(
        context: this,
        barrierColor: barrierColor,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor ?? Colors.transparent,
        builder: (context) => Wrap(children: [child]),
      );

  Future<T?> showCustomDialog(
    Widget dialog, {
    double? padding,
    Color? barrierColor,
    Color? bgColor,
    bool barrierDismissible = true,
    bool showCloseButton = true,
  }) =>
      showDialog(
          useSafeArea: false,
          context: this,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          builder: (context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: dialog,
            );
          });

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    dynamic message,
  ) =>
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          content: message is String ? Text(message) : message,
          behavior: SnackBarBehavior.floating,
        ),
      );

  void removeSnackBar() => ScaffoldMessenger.of(this).removeCurrentSnackBar();

  void hideSnackBar() => ScaffoldMessenger.of(this).hideCurrentSnackBar();

  void pop([T? result]) => Navigator.pop(this, result);
}

extension BlocExtension on BuildContext {
  OrganizationCubit get organizationBloc => read<OrganizationCubit>();

  StockBloc get stockBloc => read<StockBloc>();

  SupplierCubit get supplierBloc => read<SupplierCubit>();

  ManagerCubit get managerBloc => read<ManagerCubit>();

  SearchBloc get searchBloc => read<SearchBloc>();

  ReportsCubit get reportsBloc => read<ReportsCubit>();

  CategoryBloc get categoryBloc => read<CategoryBloc>();

  InventoryCubit get inventoryBloc => read<InventoryCubit>();

  SupplyCubit get supplyBloc => read<SupplyCubit>();
}
