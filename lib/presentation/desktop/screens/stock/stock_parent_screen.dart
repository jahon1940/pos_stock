import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class StockParentScreen extends HookWidget {
  const StockParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
