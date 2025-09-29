import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/create_company/create_company_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/companies/bloc/company_search_bloc.dart';

import '../../../../core/constants/spaces.dart';
import '../../../../core/enums/states.dart';
import '../../../../core/styles/colors.dart';
import '../../../../core/widgets/custom_box.dart';
import '../../../../core/widgets/product_table_item.dart';
import '../../../../core/widgets/product_table_title.dart';
import '../../../../core/widgets/text_field.dart';

@RoutePage()
class CompaniesScreen extends HookWidget {
  const CompaniesScreen({super.key});

  void _scrollListener(
    ScrollController scrollController,
    BuildContext context,
  ) {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      context.read<CompanySearchBloc>().add(CompanyLoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final searchController = TextEditingController();
    ThemeData themeData = Theme.of(context);

    useEffect(() {
      context.read<CompanySearchBloc>().add(CompanySearchTextChanged('', true));
      scrollController.addListener(() => _scrollListener(scrollController, context));
      return null;
    }, const []);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: themeData.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
              ),
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary100.opcty(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppTextField(
                          height: 50,
                          hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                          contentPadding: const EdgeInsets.all(14),
                          fieldController: searchController,
                          hint: context.tr("search_client"),
                          suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                searchController.clear();
                                context.read<CompanySearchBloc>().add(CompanySearchTextChanged("", true));
                              }),
                          onChange: (value) {
                            context.read<CompanySearchBloc>().add(CompanySearchTextChanged(value, true));
                          },
                          onFieldSubmitted: (v) {
                            context.read<CompanySearchBloc>().add(CompanySearchTextChanged(v, true));
                          },
                        ),
                      ),
                    ),
                    AppSpace.horizontal24,
                    GestureDetector(
                      onTap: () {
                        searchController.clear();
                        context.read<CompanySearchBloc>().add(CompanySearchTextChanged("", true));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                        height: 50,
                        child: const Center(
                          child: Icon(
                            Icons.restart_alt,
                            size: 20,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    AppSpace.horizontal24,
                    Container(
                      height: 50,
                      width: context.width * .15,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const Center(child: CreateCompany()),
                          ).then((onValue) {
                            if (onValue == true) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Успешно"),
                                  content: const Text("Клиент создан"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context.read<CompanySearchBloc>().add(CompanySearchTextChanged("", false));
                                        Navigator.pop(context);
                                      },
                                      child: const Text("ОК"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          });
                        },
                        child: Text(
                          "Создать клиента",
                          style: AppTextStyles.mType14.copyWith(color: context.onPrimary, fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            AppSpace.vertical12,
            Expanded(
              flex: 14,
              child: BarcodeKeyboardListener(
                bufferDuration: const Duration(milliseconds: 500),
                onBarcodeScanned: (value) {
                  if (value.isEmpty) value = searchController.text;
                  searchController.clear();
                  searchController.text = value;

                  context.read<CompanySearchBloc>().add(CompanySearchTextChanged(value, false));
                },
                child: CustomBox(
                  child: Column(
                    children: [
                      TableTitleProducts(
                        fillColor: AppColors.stroke,
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(),
                        },
                        titles: [context.tr("name"), context.tr("phone_number"), context.tr("bonus_card")],
                      ),
                      BlocBuilder<CompanySearchBloc, CompanySearchState>(
                        builder: (context, state) {
                          if (state.status == StateStatus.loading) {
                            return const Expanded(child: Center(child: CircularProgressIndicator()));
                          } else if (state.companies?.results.isEmpty ?? false || state.companies == null) {
                            return Expanded(child: Center(child: Text(context.tr("not_found"))));
                          } else if (state.status == StateStatus.loaded || state.status == StateStatus.loadingMore) {
                            return Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                controller: scrollController,
                                itemBuilder: (context, index) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: TableProductItem(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(2),
                                        2: FlexColumnWidth(),
                                      },
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                            child: CreateCompany(companyDto: state.companies?.results[index]),
                                          ),
                                        ).then((onValue) {
                                          if (onValue == true) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text("Успешно"),
                                                content: const Text("Клиент обнавлен"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CompanySearchBloc>()
                                                          .add(CompanySearchTextChanged("", false));
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("ОК"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                            child: Text(state.companies?.results[index].name ?? ""),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              child: Text(state.companies?.results[index].phoneNumbers != null &&
                                                      state.companies!.results[index].phoneNumbers!.isNotEmpty
                                                  ? state.companies?.results[index].phoneNumbers?.first ?? ""
                                                  : "")),
                                        ),
                                        SizedBox(
                                          height: 40,
                                          child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                              child: Text(state.companies?.results[index].cardNumbers != null &&
                                                      state.companies!.results[index].cardNumbers!.isNotEmpty
                                                  ? state.companies?.results[index].cardNumbers?.first.card_number ?? ""
                                                  : "")),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => AppSpace.vertical12,
                                itemCount: state.companies?.results.length ?? 0,
                              ),
                            );
                          }
                          return const Center(child: Text("Ошибка загрузки"));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
