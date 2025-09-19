import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/prouct_detail/cubit/product_detail_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/prouct_detail/tabs/product_info.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/prouct_detail/tabs/quantity_info.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/prouct_detail/tabs/update_barcode.dart';

class ProductDetailDialog extends HookWidget {
  const ProductDetailDialog({super.key, required this.productDto});

  final ProductDto productDto;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    useEffect(() {
      context.read<ProductDetailCubit>().search(productDto.id);
      return null;
    }, []);

    return SelectionArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(80, 15, 80, 15),
          child: Material(
            borderRadius: BorderRadius.circular(12),
            child: BlocBuilder<ProductDetailCubit, ProductDetailState>(
                builder: (context, state) {
              if (state.status == StateStatus.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.status == StateStatus.loaded) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: Text(productDto.title ?? "",
                                  style: AppTextStyles.boldType16),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.success500,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: TextButton(
                                      onPressed: () {
                                        context
                                            .read<ProductDetailCubit>()
                                            .syncProduct(productDto.id);
                                      },
                                      child: Text(
                                        "Синхронизировать",
                                        style: AppTextStyles.boldType16
                                            .copyWith(color: AppColors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: AppColors.error100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: IconButton.styleFrom(
                                          overlayColor: AppColors.error500),
                                      icon: Icon(Icons.close,
                                          color: AppColors.error600),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      AppSpace.vertical12,
                      SizedBox(
                        width: context.width * .7,
                        child: TabBar(
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: context.primary),
                          tabs: <Widget>[
                            // for (final index in [0, 1, 2])
                            SizedBox(
                              width: context.width * .2,
                              child: Tab(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Информация о Наменклатуре",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: context.width * .2,
                              child: Tab(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.tr("availability_in_stock"),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: context.width * .2,
                              child: Tab(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Штрихкоды",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpace.vertical6,
                      Divider(),
                      AppSpace.vertical6,
                      SizedBox(
                        height: context.height * .65,
                        child: TabBarView(
                          children: <Widget>[
                            ProductInfo(productDto),
                            QuantityInfo(productDto),
                            UpdateBarcode(productDto),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ошибка загрузки"),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.success500,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: TextButton(
                          onPressed: () {
                            context
                                .read<ProductDetailCubit>()
                                .search(productDto.id);
                          },
                          child: Text(
                            "Обновить",
                            style: AppTextStyles.boldType16
                                .copyWith(color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            }),
          ),
        ),
      ),
    );
  }
}
