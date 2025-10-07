import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../app/router.dart';
import '../../../../../../app/router.gr.dart';
import '../../../../../../core/constants/app_utils.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../data/dtos/manager/manager_dto.dart';

class ManagerItemWidget extends StatelessWidget {
  const ManagerItemWidget({
    super.key,
    required this.manager,
    required this.columnWidths,
  });

  final ManagerDto manager;
  final Map<int, TableColumnWidth>? columnWidths;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: columnWidths,
        onTap: () async {},
        children: [
          ///
          _item(Text(manager.name ?? '')),

          ///
          _item(Text(manager.phoneNumber ?? '')),

          ///
          _item(Text(manager.position ?? '')),

          /// buttons
          _item(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///
                GestureDetector(
                  onTap: () =>
                      router.push(AddManagerRoute(managerDto: manager)).then((_) => context.managerBloc.getManagers()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                    ),
                    height: 40,
                    width: 40,
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),

                ///
                AppUtils.kGap12,
                GestureDetector(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Подтверждение'),
                        content: Text('Вы действительно хотите удалить сотрудника ${manager.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      context.managerBloc.deleteManager(manager.cid);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.error500,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                    ),
                    height: 40,
                    width: 40,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _item(
    Widget child,
  ) =>
      Container(
        height: 60,
        padding: AppUtils.kPaddingAll12,
        child: child,
      );
}
