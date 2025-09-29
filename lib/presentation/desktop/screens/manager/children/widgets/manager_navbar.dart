import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../../../core/widgets/custom_box.dart';

class ManagerNavbar extends HookWidget {
  const ManagerNavbar({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      InkWell(
        onTap: () => context.managerBloc.createManager(context),
        child: CustomBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                height: 50,
                width: context.width * .1,
                child: Center(
                  child: Text(
                    "Сохранить",
                    maxLines: 2,
                    style: TextStyle(fontSize: 13, color: context.onPrimary),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
