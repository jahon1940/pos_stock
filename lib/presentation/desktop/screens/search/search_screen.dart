import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/prouct_detail/product_detail_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/search/cubit/search_bloc.dart';

import '../../../../core/styles/colors.dart';
import '../../../../core/styles/text_style.dart';
import '../../../../core/widgets/custom_box.dart';
import '../../../../core/widgets/text_field.dart';

@RoutePage()
class SearchScreen extends HookWidget {
  const SearchScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final scrollController = useScrollController();
    final searchController = useTextEditingController();
    final selectedFilter = useState<String>('remote');

    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
          context.searchBloc.add(LoadMoreSearch(remote: selectedFilter.value == 'remote'));
        }
      });
      context.read<SearchBloc>().add(SearchRemoteTextChangedEvent(''));
      return null;
    }, const []);

    return SelectionArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary100.opcty(.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppTextField(
                      height: 50,
                      hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                      contentPadding: const EdgeInsets.all(14),
                      hint: context.tr('search_product'),
                      fieldController: searchController,
                      suffix: Row(
                        children: [
                          /*DropdownButtonHideUnderline(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButton<String>(
                                value: selectedFilter.value,
                                hint: const Text("Фильтр"),
                                isDense: true,
                                icon: const Icon(Icons.arrow_drop_down),
                                items: [
                                  DropdownMenuItem(
                                      value: 'local',
                                      child: Text(context.tr("local"))),
                                  DropdownMenuItem(
                                      value: 'remote',
                                      child: Text(context.tr("online"))),
                                ],
                                onChanged: (value) {
                                  selectedFilter.value = value ?? "local";
                                  if (value == 'local') {
                                    context
                                        .read<SearchCubit>()
                                        .getLocalProducts();
                                  } else if (value == 'remote') {
                                    context
                                        .read<SearchCubit>()
                                        .SearchRemoteTextChanged('');
                                  }
                                },
                              ),
                            ),
                          ),*/
                          IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                if (searchController.text.isNotEmpty) {
                                  searchController.clear();
                                  context.read<SearchBloc>().add(SearchRemoteTextChangedEvent(''));
                                }
                              }),
                        ],
                      ),
                      onChange: (value) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (selectedFilter.value == 'local') {
                            if (value.isEmpty) {
                              context.read<SearchBloc>().add(GetLocalProducts());
                            } else {
                              context.read<SearchBloc>().add(SearchTextChangedEvent(value));
                            }
                          } else {
                            if (value.isEmpty) {
                              context.read<SearchBloc>().add(SearchRemoteTextChangedEvent(''));
                            } else {
                              context.read<SearchBloc>().add(SearchRemoteTextChangedEvent(value));
                            }
                          }
                        });
                      },
                    ),
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
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(3),
                          //2: FlexColumnWidth(1),
                          2: FlexColumnWidth(3),
                        },
                        titles: [
                          '${context.tr("name")}/${context.tr("article")}',
                          context.tr('name_uz'),
                          //(context.tr("quantity_short")),
                          context.tr('price'),
                        ],
                      ),
                      BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          if (state.status == StateStatus.loading) {
                            return const Expanded(child: Center(child: CircularProgressIndicator()));
                          } else if (state.products?.results.isEmpty ?? false || state.products == null) {
                            return Expanded(child: Center(child: Text(context.tr('not_found'))));
                          } else if (state.status == StateStatus.loaded || state.status == StateStatus.loadingMore) {
                            return BarcodeKeyboardListener(
                              onBarcodeScanned: (value) {
                                if (value.isEmpty) value = searchController.text;
                                searchController.clear();
                                searchController.text = value;

                                context.read<SearchBloc>().add(SearchRemoteTextChangedEvent(value));
                              },
                              child: Expanded(
                                child: Material(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    padding: const EdgeInsets.all(8.0),
                                    itemBuilder: (context, index) {
                                      final product = state.products!.results[index];
                                      final currencyFormatter = NumberFormat.currency(
                                        locale: 'ru_RU',
                                        symbol: '',
                                        decimalDigits: 0,
                                      );

                                      return SelectionArea(
                                        child: TableProductItem(
                                          columnWidths: const {
                                            0: FlexColumnWidth(3),
                                            1: FlexColumnWidth(3),
                                            //2: FlexColumnWidth(1),
                                            2: FlexColumnWidth(3),
                                          },
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Center(
                                                child: ProductDetailDialog(productDto: product),
                                              ),
                                            );
                                          },
                                          children: [
                                            SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          AppSpace.vertical2,
                                                          Text(
                                                            "${context.tr("article")}: ${product.vendorCode ?? 'Не найдено'}",
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w400, fontSize: 9),
                                                          ),
                                                          Text(
                                                            product.title ?? '',
                                                            maxLines: 2,
                                                          ),
                                                          AppSpace.vertical2,
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          AppSpace.vertical2,
                                                          Text(
                                                            "${context.tr("article")}: ${product.vendorCode ?? 'Не найдено'}",
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                                fontWeight: FontWeight.w400, fontSize: 9),
                                                          ),
                                                          Text(
                                                            product.titleUz ?? '',
                                                            maxLines: 2,
                                                          ),
                                                          AppSpace.vertical2,
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              child: Padding(
                                                padding: const EdgeInsets.fromLTRB(15, 15, 10, 0),
                                                child: product.price == null
                                                    ? const SizedBox()
                                                    : Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            "${currencyFormatter.format(product.price).replaceAll('.', ' ')} сум",
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => AppSpace.vertical12,
                                    itemCount: state.products?.results.length ?? 0,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const Center(child: Text('Ошибка загрузки'));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
