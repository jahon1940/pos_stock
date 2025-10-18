import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/product_table_title.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/contract_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/contract/widgets/create_contract.dart';

import 'cubit/contract_bloc.dart';

class ContractDialog extends HookWidget {
  const ContractDialog({super.key, required this.companyDto, this.fromCart = false});

  final CompanyDto companyDto;
  final bool fromCart;

  @override
  Widget build(
    BuildContext context,
  ) {
    final ValueNotifier<bool> showCreate = useState(false);
    useEffect(() {
      context.read<ContractBloc>().add(ContractLoad(companyDto.id));
      return null;
    }, const []);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: context.width * 0.6,
          height: context.width * 0.5,
          child: BlocBuilder<ContractBloc, ContractState>(
            builder: (context, state) {
              final bloc = context.read<ContractBloc>();
              if (state.status == StateStatus.loaded) {
                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(companyDto.name ?? '', style: AppTextStyles.boldType14),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            margin: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                showCreate.value = !showCreate.value;
                                bloc.contractId = null;
                                bloc.contractDate.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
                                bloc.contractNumber.text = '';
                                bloc.number = 0;
                                bloc.generateContractNumber();
                              },
                              child: const Text(
                                'Создать договор',
                                style: AppTextStyles.boldType16,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
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
                                  style: IconButton.styleFrom(overlayColor: AppColors.error500),
                                  icon: const Icon(Icons.close, color: AppColors.error600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  if (showCreate.value) ...[
                    CreateContract(companyDto: companyDto, posManagerDto: state.posManagerDto!)
                  ],
                  TableTitleProducts(
                    fillColor: AppColors.stroke,
                    columnWidths: const {
                      0: FlexColumnWidth(),
                      1: FlexColumnWidth(4),
                      2: FlexColumnWidth(),
                    },
                    titles: [
                      context.tr('contract_id'),
                      context.tr('contract_number'),
                      context.tr('action'),
                    ],
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        final ContractDto contract = state.contracts![index];
                        return Material(
                          child: TableProductItem(
                            columnWidths: const {
                              0: FlexColumnWidth(),
                              1: FlexColumnWidth(4),
                              2: FlexColumnWidth(),
                            },
                            onTap: () async {
                              if (fromCart) {
                                // context.read<ReserveCubit>().addContract(
                                //     contract);
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context, contract.id);
                              }
                            },
                            children: [
                              SizedBox(
                                height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                  child: Text(
                                    contract.id.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                    child: Text(
                                      contract.name ?? contract.number ?? 'Не указано',
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                              SizedBox(
                                width: 40,
                                height: 70,
                                child: CustomBox(
                                  color: context.primary,
                                  child: IconButton(
                                    color: context.onPrimary,
                                    onPressed: () {
                                      bloc.updateContract(contract);
                                      showCreate.value = true;
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => AppSpace.vertical12,
                      itemCount: state.contracts?.length ?? 0,
                    ),
                  ),
                ]);
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
