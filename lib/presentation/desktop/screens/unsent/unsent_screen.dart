import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class UnsentScreen extends HookWidget {
  const UnsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Unsent'),
    );
  }
}
