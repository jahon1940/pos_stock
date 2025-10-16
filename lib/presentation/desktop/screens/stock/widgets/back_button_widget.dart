import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromHeight(48),
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
        onPressed: context.pop,
        child: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.white,
        ),
      );
}
