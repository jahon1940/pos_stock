import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../../../../../app/router.dart';
import '../../../../../../../../../app/router.gr.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../../data/dtos/stock_dto.dart';
import '../cubit/transfer_cubit.dart';

class TransferNavbar extends HookWidget {
  const TransferNavbar(
    this.stock,
    this.organization, {
    super.key,
  });

  final CompanyDto organization;
  final StockDto? stock;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocBuilder<TransferCubit, TransferState>(
                builder: (context, state) {
                  final isDisabled = ((state.request?.products?.isEmpty ?? true) ||
                      (state.request?.products?.any((e) => e.quantity == 0) ?? true));
                  return IgnorePointer(
                    ignoring: isDisabled,
                    child: Opacity(
                      opacity: isDisabled ? .5 : 1,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          if (state.status.isLoading) return;
                          context.transferBloc.create();
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Успешно"),
                              content: const Text(""),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    router.push(StockItemRoute(stock: stock!, organization: organization));
                                  },
                                  child: const Text("ОК"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                          height: 50,
                          width: context.width * .1,
                          child: Center(
                            child: state.status.isLoading
                                ? const CupertinoActivityIndicator()
                                : Text(
                                    "Сохранить",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 13, color: context.onPrimary),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
}
