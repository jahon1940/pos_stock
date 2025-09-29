part of '../managers_screen.dart';

class ManagerItemWidget extends StatelessWidget {
  const ManagerItemWidget({
    super.key,
    required this.organization,
    required this.manager,
    required this.columnWidths,
  });

  final CompanyDto organization;
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
          _item(Text(manager.name ?? "")),

          ///
          _item(Text(manager.phoneNumber ?? "")),

          ///
          _item(Text(manager.position ?? "")),

          /// buttons
          _item(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///
                GestureDetector(
                  onTap: () => router
                      .push(AddManagerRoute(organizations: organization, managerDto: manager))
                      .then((_) => context.managerBloc.getManagers()),
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
                        title: const Text("Подтверждение"),
                        content: Text("Вы действительно хотите удалить сотрудника ${manager.name}?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Отмена"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Удалить", style: TextStyle(color: Colors.red)),
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
      SizedBox(
        height: 60,
        child: Padding(
          padding: AppUtils.kPaddingAll12,
          child: child,
        ),
      );
}
