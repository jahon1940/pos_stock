import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../core/constants/network.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/enums/states.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/text_style.dart';
import '../../../../../data/dtos/product_dto.dart';
import '../../../screens/cubit/user_cubit.dart';
import '../../print_price/print_price_dialog.dart';
import '../cubit/product_detail_cubit.dart';
import '../widgets/details_widget.dart';

class ProductInfo extends HookWidget {
  const ProductInfo(
    this.productDto, {
    super.key,
  });

  final ProductDto productDto;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(builder: (context, state) {
      if (state.status == StateStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state.status == StateStatus.loaded) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.width * .3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(8), right: Radius.circular(8)),
                  child: ColoredBox(
                    color: AppColors.white,
                    child: CachedNetworkImage(
                      width: context.width * .2,
                      imageUrl: NetworkConstants.baseUrl +
                          (state.productDetail?.imageUrl ?? state.productDetail!.imageUrl ?? ''),
                      errorWidget: (context, url, error) => const SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: context.width * .2,
                      child: state.manager?.pos?.integration_with_1c == false
                          ? const SizedBox()
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primary500),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        currencyFormatter.format(productDto.price).replaceAll('.', ' '),
                                        style: const TextStyle(
                                            fontSize: 20, color: AppColors.primary500, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  AppSpace.vertical12,
                                  Center(
                                    child: SizedBox(
                                      width: context.width * .18,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary500,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                  child: ExposrPriceDialog(product: productDto),
                                                ),
                                              ).then((onValue) {
                                                if (onValue == true) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      title: const Text('Успешно'),
                                                      content: const Text('Котегория создан'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {},
                                                          child: const Text('ОК'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }
                                              });
                                            },
                                            child: Text(
                                              'Печатать ценник',
                                              style: AppTextStyles.boldType16.copyWith(color: AppColors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AppSpace.vertical12,
                                ],
                              ),
                            ),
                    );
                  },
                ),
                AppSpace.vertical12,
                SizedBox(
                  width: context.width * .37,
                  height: context.height * .45,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: context.width * .17,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Бренд'),
                                  Text(':'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "${state.productDetail?.brand?.name ?? state.productDetail!.brand?.name ?? ""} ",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      AppSpace.vertical12,
                      DetailsWidget(
                        keyI: 'Категория',
                        value: state.productDetail?.category?.name ?? state.productDetail!.category?.name ?? '',
                      ),
                      AppSpace.vertical12,
                      DetailsWidget(
                        keyI: 'Страна производителя',
                        value: state.productDetail?.madeIn?.name ?? state.productDetail!.madeIn?.name ?? '',
                      ),
                      AppSpace.vertical12,
                      DetailsWidget(
                        keyI: 'Артикул',
                        value: state.productDetail?.vendorCode ?? state.productDetail!.vendorCode ?? '',
                      ),
                      AppSpace.vertical12,
                      SizedBox(
                        child: DetailsWidget(
                          keyI: 'Код классификатора',
                          value: state.productDetail?.classifierCode ?? state.productDetail!.classifierCode ?? '',
                        ),
                      ),
                      AppSpace.vertical12,
                      DetailsWidget(
                        keyI: 'Классификатор',
                        value: state.productDetail?.classifierTitle ?? state.productDetail!.classifierTitle ?? '',
                      ),
                      AppSpace.vertical12,
                      DetailsWidget(
                        keyI: 'Ед. измерение',
                        value: state.productDetail?.measure ?? state.productDetail!.measure ?? '',
                      ),
                      if (state.productDetail?.packagename != null || state.productDetail!.packagename != null) ...[
                        AppSpace.vertical12,
                        DetailsWidget(
                          keyI: 'Тип упаковки',
                          value: state.productDetail?.packagename ?? state.productDetail!.packagename!,
                        ),
                      ],
                      if (state.productDetail?.packagecode != null || state.productDetail!.packagecode != null) ...[
                        AppSpace.vertical12,
                        DetailsWidget(
                          keyI: 'Код упаковки',
                          value: state.productDetail?.packagecode ?? state.productDetail!.packagecode!,
                        ),
                      ],
                      if (state.productDetail?.quantityInBox != null || state.productDetail!.quantityInBox != null) ...[
                        AppSpace.vertical12,
                        DetailsWidget(
                          keyI: 'В упаковке',
                          value: state.productDetail?.quantityInBox ?? state.productDetail!.quantityInBox!,
                        ),
                      ],
                      if (state.productDetail?.size != null || state.productDetail!.size != null) ...[
                        AppSpace.vertical12,
                        DetailsWidget(
                          keyI: 'Размер',
                          value: state.productDetail?.size ?? state.productDetail!.size!,
                        ),
                      ],
                      if (state.productDetail?.weight != 0.0 && state.productDetail!.weight != 0.0) ...[
                        AppSpace.vertical12,
                        DetailsWidget(
                          keyI: 'Вес',
                          value: '${state.productDetail?.weight ?? state.productDetail!.weight} т.',
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      }
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ошибка загрузки'),
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
                    context.read<ProductDetailCubit>().search(productDto.id);
                  },
                  child: Text(
                    'Обновить',
                    style: AppTextStyles.boldType16.copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    });
  }
}
