import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hoomo_pos/app/app.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/enums/table_type.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/cash_in_out/cubit/cash_in_out_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/bloc/category_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/contract/cubit/contract_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/contract_payment/cubit/contract_payment_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/create_company/cubit/create_company_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/end_products/cubit/end_products_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/prouct_detail/cubit/product_detail_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/report_dialog/cubit/report_manager_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/un_sale_products/cubit/un_sale_products_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/companies/bloc/company_search_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/cubit/user_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/main/cubit/socket_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/order/cubit/order_screen_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/reports/children/cubit/reports_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/search/cubit/search_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/blocs/update_cubit/update_cubit_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/settings/cubit/settings_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/shifts/cubit/shift_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/bloc/stock_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_contractor/cubit/add_contractor_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/cubit/add_manager_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/supplies_1c/bloc/supplies_1c_bloc.dart';
import 'package:provider/provider.dart';

import 'core/styles/theme_provider.dart';

void main() async {
  try {
    configureDependencies();
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
  } catch (e) {
    debugPrint(e.toString());
  } finally {
    runApp(
      Phoenix(
        child: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: EasyLocalization(
            supportedLocales: [const Locale('ru'), const Locale('uz')],
            path: 'assets/translations',
            fallbackLocale: const Locale('ru'),
            child: MultiBlocProvider(providers: [
              BlocProvider(create: (context) => getIt<ShiftCubit>()),
              BlocProvider(create: (context) => getIt<CashInOutCubit>()),
              BlocProvider(create: (context) => getIt<ProductDetailCubit>()),
              BlocProvider(create: (context) => getIt<OrderScreenCubit>()),
              BlocProvider(create: (context) => getIt<UpdateCubit>()),
              BlocProvider(create: (context) => getIt<SocketCubit>()),
              BlocProvider(create: (context) => getIt<SearchBloc>()),
              BlocProvider(create: (context) => getIt<CompanySearchBloc>()),
              BlocProvider(create: (context) => getIt<ContractBloc>()),
              BlocProvider(create: (context) => getIt<StockBloc>()),
              BlocProvider(create: (context) => getIt<AddContractorCubit>()),
              BlocProvider(create: (context) => getIt<AddManagerCubit>()),
              BlocProvider(create: (context) => getIt<UserCubit>()),
              BlocProvider(create: (context) => getIt<ContractPaymentCubit>()),
              BlocProvider(create: (context) => getIt<UnSaleProductsCubit>()),
              BlocProvider(create: (context) => getIt<EndProductsCubit>()),
              BlocProvider(create: (context) => getIt<CreateCompanyCubit>()),
              BlocProvider(create: (context) => getIt<Supplies1cBloc>()),
              BlocProvider(create: (context) => getIt<ReportsCubit>()),
              BlocProvider(create: (context) => getIt<ReportManagerCubit>()),
              BlocProvider(create: (context) => getIt<CategoryBloc>()),
              BlocProvider(create: (context) => getIt<SettingsCubit>()..init(TableType.products)),
            ], child: const POSApp()),
          ),
        ),
      ),
    );
  }
}
