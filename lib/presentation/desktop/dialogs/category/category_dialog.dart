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
import 'package:hoomo_pos/data/dtos/category/category_dto.dart';
import '../create_category/create_category_dialog.dart';
import 'bloc/category_bloc.dart';

class CategoryDialog extends HookWidget {
  const CategoryDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<CategoryBloc>().add(GetCategory());
      return null;
    }, const []);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: context.width * 0.8,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 50,
                            width: context.width * .15,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primary800),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                    child: CreateCategoryDialog(),
                                  ),
                                ).then((onValue) {
                                  if (onValue == true) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Успешно"),
                                        content: Text("Котегория создан"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {},
                                            child: Text("ОК"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Text(
                                "Создать Котегорию",
                                style: AppTextStyles.mType14.copyWith(
                                    color: context.onPrimary, fontSize: 12),
                              ),
                            ),
                          ),
                          AppSpace.horizontal24,
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
                                  style: IconButton.styleFrom(
                                      overlayColor: AppColors.error500),
                                  icon: Icon(Icons.close,
                                      color: AppColors.error600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                          if (state.status == StateStatus.loading &&
                              state.categories == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (state.categories?.results.isEmpty ?? true) {
                            return Center(child: Text(context.tr("not_found")));
                          }

                          return Column(children: [
                            TableTitleProducts(
                              fillColor: AppColors.stroke,
                              columnWidths: const {
                                0: FlexColumnWidth(2),
                                1: FlexColumnWidth(6),
                                2: FlexColumnWidth(2),
                              },
                              titles: [
                                "ID",
                                context.tr("name"),
                                "Действия",
                              ],
                            ),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8.0),
                                itemBuilder: (context, index) {
                                  CategoryDto category =
                                      state.categories!.results[index];

                                  return Material(
                                    child: TableProductItem(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(6),
                                        2: FlexColumnWidth(2),
                                      },
                                      onTap: () async {},
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 5, 5, 5),
                                            child: Text("${category.id}"),
                                          ),
                                        ),
                                        SizedBox(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 5, 0, 0),
                                              child: Text(category.name ?? "")),
                                        ),
                                        SizedBox(
                                            height: 60,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        50, 5, 5, 5),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .primary500,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: AppColors
                                                                    .stroke,
                                                                blurRadius: 3)
                                                          ],
                                                        ),
                                                        height: 40,
                                                        width: 40,
                                                        child: Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    AppSpace.horizontal12,
                                                    GestureDetector(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    CategoryBloc>(
                                                                context)
                                                            .add(
                                                                DeleteCategoryId(
                                                                    category
                                                                        .cid));
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .error500,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: AppColors
                                                                    .stroke,
                                                                blurRadius: 3)
                                                          ],
                                                        ),
                                                        height: 40,
                                                        width: 40,
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    AppSpace.vertical12,
                                itemCount:
                                    state.categories?.results.length ?? 0,
                              ),
                            ),
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
