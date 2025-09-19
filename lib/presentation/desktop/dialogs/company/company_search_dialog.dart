import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/company_bonus_dto.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/discount_card_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/company/bloc/search_bonuses_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/screens/companies/bloc/company_search_bloc.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/contract/contract_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/create_company/create_company_dialog.dart';

class CompanySearchDialog extends HookWidget {
  const CompanySearchDialog({
    super.key,
    this.forInvoice = false,
    this.forReserve = false,
    this.isBonuses = false,
  });

  final bool forInvoice;
  final bool forReserve;
  final bool isBonuses;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final searchController = TextEditingController();

    useEffect(() {
      void scrollListener() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          if (!isBonuses) {
            context.read<CompanySearchBloc>().add(CompanyLoadMore());
          }
        }
      }

      context.read<CompanySearchBloc>().add(CompanySearchTextChanged('', true));
      scrollController.addListener(scrollListener);

      return () => scrollController.removeListener(scrollListener);
    }, [scrollController]);

    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: context.width * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 15,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: AppColors.primary100.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: context.theme.dividerColor)),
                              child: AppTextField(
                                radius: 8,
                                hint: context.tr("search"),
                                width: context.width * 0.8,
                                fieldController: searchController,
                                contentPadding: EdgeInsets.all(14),
                                onFieldSubmitted: (value) {
                                  isBonuses
                                      ? context
                                          .read<SearchBonusesBloc>()
                                          .add(SearchBonusesEvent.search(value))
                                      : context.read<CompanySearchBloc>().add(
                                          CompanySearchTextChanged(
                                              value, true));
                                },
                                prefixPadding: EdgeInsets.zero,
                                prefix: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: AppColors.stroke),
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.white,
                                            blurRadius: 3)
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.person_search_rounded,
                                        color: AppColors.primary500,
                                      ),
                                    ),
                                  ),
                                ),
                                suffix: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      searchController.clear();
                                      isBonuses
                                          ? context
                                              .read<SearchBonusesBloc>()
                                              .add(SearchBonusesEvent.search(
                                                  searchController.text))
                                          : context
                                              .read<CompanySearchBloc>()
                                              .add(CompanySearchTextChanged(
                                                  searchController.text, true));
                                    }),
                                onChange: (value) {
                                  isBonuses
                                      ? context
                                          .read<SearchBonusesBloc>()
                                          .add(SearchBonusesEvent.search(value))
                                      : context.read<CompanySearchBloc>().add(
                                          CompanySearchTextChanged(
                                              value, true));
                                },
                              ),
                            ),
                          ),
                        ),
                        AppSpace.horizontal24,
                        isBonuses
                            ? SizedBox()
                            : InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                      child: CreateCompany(),
                                    ),
                                  ).then((onValue) {
                                    if (onValue == true) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text("Успешно"),
                                          content: Text("Клиент создан"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<CompanySearchBloc>()
                                                    .add(
                                                        CompanySearchTextChanged(
                                                            "", false));
                                                Navigator.pop(context);
                                              },
                                              child: Text("ОК"),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  width: context.width * .14,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: context.theme.dividerColor),
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.primary500),
                                  child: Center(
                                    child: Text(
                                      "Создать клиента",
                                      style: AppTextStyles.mType12.copyWith(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                        isBonuses ? SizedBox() : AppSpace.horizontal24,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 50,
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: context.theme.dividerColor),
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.error200.withOpacity(0.5)),
                                child: Center(
                                  child: Icon(Icons.close,
                                      color: AppColors.error600),
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: BarcodeKeyboardListener(
                      bufferDuration: const Duration(milliseconds: 500),
                      onBarcodeScanned: (value) {
                        if (value.isEmpty) value = searchController.text;
                        searchController.clear();
                        searchController.text = value;

                        if (value.isEmpty) return;
                        isBonuses
                            ? context
                                .read<SearchBonusesBloc>()
                                .add(SearchBonusesEvent.search(value))
                            : context
                                .read<CompanySearchBloc>()
                                .add(CompanySearchTextChanged(value, true));
                      },
                      child: isBonuses
                          ? BlocBuilder<SearchBonusesBloc, SearchBonusesState>(
                              builder: (context, state) {
                                if (state.status == StateStatus.loading &&
                                    state.companies == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (state.companies?.results.isEmpty ?? true) {
                                  return Center(
                                      child: Text(context.tr("not_found")));
                                }

                                return Column(children: [
                                  TableTitleProducts(
                                    fillColor: AppColors.stroke,
                                    columnWidths: const {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(2),
                                      2: FlexColumnWidth(1),
                                    },
                                    titles: [
                                      context.tr("name"),
                                      context.tr("Бонус"),
                                      context.tr("bonus_card"),
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(8.0),
                                      controller: scrollController,
                                      itemBuilder: (context, index) {
                                        CompanyBonusDto company =
                                            state.companies!.results[index];

                                        return Material(
                                          child: TableProductItem(
                                            columnWidths: const {
                                              0: FlexColumnWidth(2),
                                              1: FlexColumnWidth(2),
                                              2: FlexColumnWidth(1),
                                            },
                                            onTap: () async {
                                              // context
                                              //     .read<CartCubit>()
                                              //     .addClient(CompanyDto(
                                              //         id: company.id,
                                              //         name: company.companyName,
                                              //         card_numbers: [
                                              //           DiscountCardDto(
                                              //               card_cid: '',
                                              //               card_number: company
                                              //                   .cardNumber!,
                                              //               bonus: company.bonus
                                              //                   .toString())
                                              //         ]));
                                              Navigator.pop(context);
                                            },
                                            children: [
                                              SizedBox(
                                                height: 50,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 5, 5),
                                                  child: Text(
                                                      company.companyName ??
                                                          ""),
                                                ),
                                              ),
                                              SizedBox(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 5, 0, 0),
                                                    child: Text(company.bonus
                                                        .toString())),
                                              ),
                                              SizedBox(
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text(company
                                                                    .cardNumber !=
                                                                null &&
                                                            company.cardNumber!
                                                                .isNotEmpty
                                                        ? company.cardNumber ??
                                                            ""
                                                        : ""),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          AppSpace.vertical12,
                                      itemCount:
                                          state.companies?.results.length ?? 0,
                                    ),
                                  ),
                                ]);
                              },
                            )
                          : BlocBuilder<CompanySearchBloc, CompanySearchState>(
                              builder: (context, state) {
                                if (state.status == StateStatus.loading &&
                                    state.companies == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                if (state.status == StateStatus.error &&
                                    state.companies == null) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Ошибка загрузки данных"),
                                        AppSpace.vertical12,
                                        ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<CompanySearchBloc>()
                                                .add(CompanySearchTextChanged(
                                                    "", true));
                                          },
                                          child: Text("Повторить"),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (state.companies?.results.isEmpty ?? true) {
                                  return Center(
                                      child: Text(context.tr("not_found")));
                                }

                                return Column(children: [
                                  TableTitleProducts(
                                    fillColor: AppColors.stroke,
                                    columnWidths: const {
                                      0: FlexColumnWidth(2),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(1),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                    },
                                    titles: [
                                      context.tr("name"),
                                      context.tr("phone_number"),
                                      context.tr("bonus_card"),
                                      context.tr("tin_pinfl"),
                                      'Действия',
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(8.0),
                                            controller: scrollController,
                                            itemBuilder: (context, index) {
                                              CompanyDto company = state
                                                  .companies!.results[index];

                                              return Material(
                                                child: TableProductItem(
                                                  columnWidths: const {
                                                    0: FlexColumnWidth(2),
                                                    1: FlexColumnWidth(1),
                                                    2: FlexColumnWidth(1),
                                                    3: FlexColumnWidth(1),
                                                    4: FlexColumnWidth(1),
                                                  },
                                                  onTap: () async {
                                                    if (forInvoice) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            Center(
                                                          child: ContractDialog(
                                                              companyDto:
                                                                  company),
                                                        ),
                                                      ).then((value) {
                                                        Navigator.pop(context, [
                                                          company.id,
                                                          value
                                                        ]);
                                                      });
                                                    } else {
                                                      if (context.mounted) {
                                                        // if (forReserve) {
                                                        //   context
                                                        //       .read<
                                                        //           ReserveCubit>()
                                                        //       .addClient(
                                                        //           company);
                                                        // } else {
                                                        //   context
                                                        //       .read<CartCubit>()
                                                        //       .addClient(
                                                        //           company);
                                                        // }

                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                  },
                                                  children: [
                                                    SizedBox(
                                                      height: 50,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                8, 5, 5, 5),
                                                        child: Text(
                                                            company.name ?? ""),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  10, 5, 0, 0),
                                                          child: Text(company
                                                                          .phoneNumbers !=
                                                                      null &&
                                                                  company
                                                                      .phoneNumbers!
                                                                      .isNotEmpty
                                                              ? company
                                                                      .phoneNumbers
                                                                      ?.first ??
                                                                  ""
                                                              : "")),
                                                    ),
                                                    SizedBox(
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text(company
                                                                          .card_numbers !=
                                                                      null &&
                                                                  company
                                                                      .card_numbers!
                                                                      .isNotEmpty
                                                              ? company
                                                                      .card_numbers!
                                                                      .first
                                                                      .card_number ??
                                                                  ""
                                                              : ""),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text(
                                                              company.inn ??
                                                                  ""),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: 60,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Row(
                                                            children: [
                                                              AppSpace
                                                                  .horizontal24,
                                                              InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            Center(
                                                                      child: CreateCompany(
                                                                          companyDto: state
                                                                              .companies
                                                                              ?.results[index]),
                                                                    ),
                                                                  ).then(
                                                                      (onValue) {
                                                                    if (onValue ==
                                                                        true) {
                                                                      showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) =>
                                                                                AlertDialog(
                                                                          title:
                                                                              Text("Успешно"),
                                                                          content:
                                                                              Text("Клиент обнавлен"),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                context.read<CompanySearchBloc>().add(CompanySearchTextChanged("", false));
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text("ОК"),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: context
                                                                            .theme
                                                                            .dividerColor),
                                                                    color: AppColors
                                                                        .primary100
                                                                        .withOpacity(
                                                                            0.4),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  height: 40,
                                                                  width: 40,
                                                                  child: Icon(
                                                                    Icons.edit,
                                                                    color: AppColors
                                                                        .primary500,
                                                                  ),
                                                                ),
                                                              ),
                                                              AppSpace
                                                                  .horizontal12,
                                                              InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                onTap: () {},
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: context
                                                                            .theme
                                                                            .dividerColor),
                                                                    color: AppColors
                                                                        .error200
                                                                        .withOpacity(
                                                                            0.5),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  height: 40,
                                                                  width: 40,
                                                                  child: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: AppColors
                                                                        .error500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    AppSpace.vertical12,
                                            itemCount: state.companies?.results
                                                    .length ??
                                                0,
                                          ),
                                        ),
                                        if (state.status ==
                                                StateStatus.loading &&
                                            state.companies != null)
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                      ],
                                    ),
                                  ),
                                ]);
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
