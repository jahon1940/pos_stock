import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/search/cubit/fast_search_bloc.dart';

import '../../../../../../../core/styles/colors.dart';

class MirelProductsDialog extends StatefulWidget {
  const MirelProductsDialog({
    super.key,
    this.searchParam,
    this.isSelect = false,
    this.stockId,
  });

  final String? searchParam;
  final int? stockId;
  final bool isSelect;

  @override
  State<MirelProductsDialog> createState() => _MirelProductsDialogState();
}

class _MirelProductsDialogState extends State<MirelProductsDialog> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  late FocusNode focusNode;
  late FocusNode keyboardFocus;

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<FastSearchBloc>().add(LoadMoreSearch());
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    keyboardFocus = FocusNode();
    context.fastSearchBloc.add(SearchTextChanged(widget.searchParam ?? '', id: widget.stockId));

    _scrollController = ScrollController()..addListener(_scrollListener);
    _searchController = TextEditingController(text: widget.searchParam ?? '');
    WidgetsBinding.instance.addPostFrameCallback((d) {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      KeyboardListener(
        focusNode: keyboardFocus,
        onKeyEvent: (value) {
          if (value.logicalKey.keyLabel != 'Enter') return;
          context.fastSearchBloc.add(SearchTextChanged(_searchController.text));
        },
        child: SelectionArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
            child: BlocListener<FastSearchBloc, FastSearchState>(
              listenWhen: (previous, current) => previous.request?.title != current.request?.title,
              listener: (context, state) {
                if (_scrollController.hasClients && _scrollController.offset != 0) {
                  _scrollController.animateTo(0, duration: Durations.medium1, curve: Curves.easeIn);
                }
              },
              child: BlocBuilder<FastSearchBloc, FastSearchState>(
                builder: (context, state) => Material(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: context.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                /// search
                                Expanded(
                                  flex: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary100.opcty(.3),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: context.theme.dividerColor),
                                      ),
                                      child: AppTextField(
                                        hint: context.tr('search'),
                                        width: context.width * 0.8,
                                        fieldController: _searchController,
                                        focusNode: focusNode,
                                        contentPadding: const EdgeInsets.all(14),
                                        onChange: (val) => context.fastSearchBloc.add(SearchTextChanged(val)),
                                        onFieldSubmitted: (value) {
                                          context.fastSearchBloc.add(SearchTextChanged(_searchController.text));
                                          keyboardFocus.requestFocus();
                                        },
                                        prefixPadding: EdgeInsets.zero,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: AppColors.stroke),
                                              boxShadow: [const BoxShadow(color: AppColors.white, blurRadius: 3)],
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(6),
                                              child: Icon(
                                                Icons.content_paste_search_sharp,
                                                color: AppColors.primary500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        suffix: IconButton(
                                            icon: const Icon(Icons.close, color: AppColors.secondary900),
                                            onPressed: () {
                                              if (_searchController.text.isNotEmpty) {
                                                _searchController.clear();
                                                context
                                                    .read<FastSearchBloc>()
                                                    .add(SearchTextChanged(_searchController.text));
                                              }
                                            }),
                                      ),
                                    ),
                                  ),
                                ),

                                /// price
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary100.opcty(.3),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: context.theme.dividerColor),
                                      ),
                                      child: AppTextField(
                                        hint: 'Цена',
                                        textInputType: TextInputType.number,
                                        width: context.width * 0.8,
                                        contentPadding: const EdgeInsets.all(14),
                                        onChange: (val) => context.fastSearchBloc.add(SetPriceLimit(int.tryParse(val))),
                                        prefixPadding: EdgeInsets.zero,
                                        prefix: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: AppColors.stroke),
                                              boxShadow: [const BoxShadow(color: AppColors.white, blurRadius: 3)],
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.payments,
                                                color: AppColors.primary500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                ///
                                AppUtils.kGap12,
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    hoverColor: context.theme.hoverColor,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: context.theme.dividerColor),
                                        borderRadius: BorderRadius.circular(8),
                                        color: AppColors.error200.opcty(.5),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.close,
                                          color: AppColors.error600,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Column(
                              children: [
                                TableTitleProducts(
                                  fillColor: AppColors.stroke,
                                  columnWidths: const {
                                    0: FlexColumnWidth(4),
                                    1: FlexColumnWidth(3),
                                    2: FlexColumnWidth(2),
                                    3: FlexColumnWidth(2),
                                  },
                                  titles: [
                                    '${context.tr("name")}/${context.tr("article")}',
                                    context.tr('name_uz'),
                                    "${context.tr("quantity_short")}/${context.tr("reserve")}",
                                    context.tr('price'),
                                  ],
                                ),
                                BarcodeKeyboardListener(
                                  onBarcodeScanned: (value) {
                                    if (value.isEmpty) {
                                      value = _searchController.text;
                                    }
                                    _searchController.clear();
                                    _searchController.text = value;
                                    if (value.isEmpty) return;
                                    context.fastSearchBloc.add(SearchTextChanged(_searchController.text));
                                  },
                                  child: BlocBuilder<FastSearchBloc, FastSearchState>(
                                    builder: (context, state) {
                                      if (state.status == StateStatus.loading && state.mirelProducts == null) {
                                        return const Padding(
                                          padding: EdgeInsets.all(50),
                                          child: Center(child: CircularProgressIndicator()),
                                        );
                                      }

                                      if (state.mirelProducts?.results.isEmpty ?? true) {
                                        debugPrint('UI: Showing empty state');
                                        return const Padding(
                                          padding: EdgeInsets.all(50),
                                          child: Center(child: Text('Ничего не найдено')),
                                        );
                                      }

                                      return Expanded(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          controller: _scrollController,
                                          padding: const EdgeInsets.all(8.0),
                                          separatorBuilder: (context, index) => AppSpace.vertical6,
                                          itemCount: state.mirelProducts?.results.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final product = state.mirelProducts?.results[index];
                                            final currencyFormatter = NumberFormat.currency(
                                              locale: 'ru_RU',
                                              symbol: '',
                                              decimalDigits: 0,
                                            );
                                            return TableProductItem(
                                              columnWidths: const {
                                                0: FlexColumnWidth(4),
                                                1: FlexColumnWidth(3),
                                                2: FlexColumnWidth(2),
                                                3: FlexColumnWidth(2),
                                              },
                                              onTap: () => context.pop(product),
                                              children: [
                                                /// name ru
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
                                                                "${context.tr("article")}: ${product?.vendorCode ?? 'Не найдено'}",
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                    fontWeight: FontWeight.w400, fontSize: 9),
                                                              ),
                                                              Text(
                                                                product?.titleRu ?? product?.title ?? '',
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

                                                /// name uz
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
                                                                "${context.tr("article")}: ${product?.vendorCode ?? 'Не найдено'}",
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 9,
                                                                ),
                                                              ),
                                                              Text(
                                                                product?.titleUz ?? product?.title ?? '',
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

                                                /// quantity
                                                SizedBox(
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Ост./Резерв: ${product?.quantity}/${product?.reserveQuantity}',
                                                            style: const TextStyle(fontSize: 11),
                                                          ),
                                                          Text(
                                                            product?.leftQuantity == 0
                                                                ? 'Нет в наличии'
                                                                : 'Своб. ост : ${product?.leftQuantity}',
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: product?.leftQuantity == 0
                                                                    ? AppColors.error500
                                                                    : AppColors.success600),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                /// price
                                                SizedBox(
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                                                    child: product?.price == null
                                                        ? const SizedBox()
                                                        : Column(
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              product?.purchasePriceDollar == 0 ||
                                                                      product?.purchasePriceDollar == null
                                                                  ? const SizedBox()
                                                                  : Text(
                                                                      'Приходная цена: ${product?.purchasePriceDollar} \$',
                                                                      style: const TextStyle(
                                                                        fontSize: 11,
                                                                        color: AppColors.success600,
                                                                      ),
                                                                    ),
                                                              product?.priceDollar == 0 || product?.priceDollar == null
                                                                  ? const SizedBox()
                                                                  : Text(
                                                                      'Цена продажи: ${product?.priceDollar} \$',
                                                                      style: const TextStyle(
                                                                        fontSize: 11,
                                                                        color: AppColors.success600,
                                                                      ),
                                                                    ),
                                                              product?.priceDollar == 0 || product?.priceDollar == null
                                                                  ? const SizedBox()
                                                                  : const Divider(),
                                                              Text(
                                                                "${currencyFormatter.format(product?.price).replaceAll('.', ' ')} сум",
                                                                style: const TextStyle(fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
