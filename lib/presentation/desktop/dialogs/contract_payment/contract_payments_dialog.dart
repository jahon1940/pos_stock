import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/data/dtos/contract_dto.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/contract_payment/cubit/contract_payment_cubit.dart';

class ContractPaymentsDialog extends HookWidget {
  const ContractPaymentsDialog({super.key, required this.contract});

  final ContractDto contract;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<ContractPaymentCubit>().init(contract.id);
      return null;
    }, const []);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
            width: context.width * 0.6,
            height: context.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Платежи по договору: ${contract.name ?? contract.number ?? "Не указано"}",
                          style: AppTextStyles.boldType18,
                          textAlign: TextAlign.start),
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
                            icon: Icon(Icons.close, color: AppColors.error600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(child:
                    BlocBuilder<ContractPaymentCubit, ContractPaymentState>(
                  builder: (context, state) {
                    if (state.status == StateStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.payments?.isEmpty ?? true) {
                      return const Center(child: Text('Ничего не найдено'));
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TableTitleProducts(
                            fillColor: AppColors.stroke,
                            columnWidths: const {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(3),
                            },
                            titles: [
                              "Номер",
                              "Дата",
                              context.tr("sum"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            itemBuilder: (context, index) {
                              final payment = state.payments![index];

                              return TableProductItem(
                                columnWidths: const {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(3),
                                  2: FlexColumnWidth(3),
                                },
                                onTap: () {},
                                children: [
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                      child: Text(
                                        payment.number ?? '',
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                      child: Text(
                                        FormatterService().dateFormatter(payment.date ?? ''),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                      child: Text(
                                        FormatterService().formatNumber(
                                            payment.amount ?? '0'),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                AppSpace.vertical12,
                            itemCount: state.payments?.length ?? 0,
                          ),
                        )
                      ],
                    );
                  },
                ))
              ],
            )),
      ),
    );
  }
}
