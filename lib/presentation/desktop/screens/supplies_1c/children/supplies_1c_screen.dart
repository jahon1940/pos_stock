import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/supplies_1c/cubit/supplies_1c_cubit.dart'
    as cubit;
import 'package:hoomo_pos/presentation/desktop/screens/supplies_1c/bloc/supplies_1c_bloc.dart';

import '../../../../../core/constants/spaces.dart';
import '../../../../../core/enums/states.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/text_style.dart';
import '../../../../../core/widgets/custom_box.dart';
import '../../../../../core/widgets/product_table_item.dart';
import '../../../../../core/widgets/product_table_title.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../dialogs/supplies_1c/supplies_1c_dialog.dart';

@RoutePage()
class Supplies1CScreen extends HookWidget {
  const Supplies1CScreen({super.key});

  void _scrollListener(
    ScrollController scrollController,
    BuildContext context,
  ) {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      context.read<Supplies1cBloc>().add(LoadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final scrollController = useScrollController();

    ThemeData themeData = Theme.of(context);

    useEffect(() {
      context.read<Supplies1cBloc>().add(SearchTextChanged(''));
      scrollController
          .addListener(() => _scrollListener(scrollController, context));
      return null;
    });

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
                boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
              ),
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary100.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AppTextField(
                          radius: 8,
                          height: 50,
                          hintStyle: AppTextStyles.mType16
                              .copyWith(color: AppColors.primary500),
                          contentPadding: EdgeInsets.all(14),
                          hint: "Поиск документов поступление товаров",
                          fieldController: searchController,
                          suffix: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                if (searchController.text.isNotEmpty) {
                                  searchController.clear();
                                  context
                                      .read<Supplies1cBloc>()
                                      .add(SearchTextChanged(""));
                                }
                              }),
                          onChange: (value) {
                            context
                                .read<Supplies1cBloc>()
                                .add(SearchTextChanged(value));
                          },
                        ),
                      ),
                    ),
                    AppSpace.horizontal24,
                    GestureDetector(
                      onTap: () {
                        searchController.clear();
                        context
                            .read<Supplies1cBloc>()
                            .add(SearchTextChanged(''));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 18),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: context.primary),
                        height: 50,
                        child: Center(
                          child: Icon(
                            Icons.restart_alt,
                            size: 20,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    AppSpace.horizontal24,
                  ],
                ),
              ),
            ),
            AppSpace.vertical12,
            Expanded(
              flex: 14,
              child: CustomBox(
                child: Column(
                  children: [
                    TableTitleProducts(
                      fillColor: AppColors.stroke,
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(1),
                      },
                      titles: [
                        "Номер документа",
                        "Дата поступления",
                        "Тип документа",
                        "Статус"
                      ],
                    ),
                    BlocBuilder<Supplies1cBloc, Supplies1cState>(
                        builder: (context, state) {
                      if (state.status == StateStatus.loading) {
                        return Expanded(
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else if (state.supplies1C?.results.isEmpty ??
                          false || state.supplies1C == null) {
                        return Expanded(
                            child:
                                Center(child: Text(context.tr("not_found"))));
                      } else if (state.status == StateStatus.loaded ||
                          state.status == StateStatus.loadingMore) {
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
                                    2: FlexColumnWidth(2),
                                    3: FlexColumnWidth(1),
                                  },
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) => BlocProvider(
                                        create: (context) =>
                                            getIt<cubit.Supplies1cCubit>(),
                                        child: Center(
                                          child: Supplies1CDialog(
                                              supply: state
                                                  .supplies1C!.results[index]),
                                        ),
                                      ),
                                    );

                                    context
                                        .read<Supplies1cBloc>()
                                        .add(SearchTextChanged(''));
                                  },
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 0, 0),
                                        child: Text(state.supplies1C
                                                ?.results[index].number ??
                                            ""),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(state.supplies1C
                                                      ?.results[index].date !=
                                                  null
                                              ? state.supplies1C?.results[index]
                                                      .date ??
                                                  ''
                                              : "")),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(state.supplies1C
                                                  ?.results[index].supplyType ??
                                              '')),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(
                                            state.supplies1C?.results[index]
                                                        .conducted ==
                                                    false
                                                ? "Непроведен"
                                                : "Проведен",
                                            style: TextStyle(
                                                color: state
                                                            .supplies1C
                                                            ?.results[index]
                                                            .conducted ==
                                                        false
                                                    ? Colors.red
                                                    : Colors.green,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                AppSpace.vertical12,
                            itemCount: state.supplies1C?.results.length ?? 0,
                          ),
                        );
                      }
                      return Center(child: Text("Ошибка загрузки"));
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
