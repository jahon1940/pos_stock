import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/presentation/desktop/screens/order/cubit/order_screen_cubit.dart';
import 'package:webview_windows/webview_windows.dart';

@RoutePage()
class OrderScreen extends HookWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        body: Center(
          child: BlocBuilder<OrderScreenCubit, OrderScreenState>(
            builder: (context, state) {
              final controller = context.read<OrderScreenCubit>().controller;
      
              if (state.status == StateStatus.error) {
                return Center(child: Text(state.errorMessage ?? "", style: const TextStyle(color: Colors.red)));
              }
      
              if (state.status == StateStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
      
              return Stack(
                children: [
                  Webview(controller, permissionRequested: (url, kind, isUserInitiated) async {
                    final decision = await showDialog<WebviewPermissionDecision>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('WebView permission requested'),
                        content: Text('WebView has requested permission \'$kind\''),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.deny),
                            child: const Text('Deny'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, WebviewPermissionDecision.allow),
                            child: const Text('Allow'),
                          ),
                        ],
                      ),
                    );
                    return decision ?? WebviewPermissionDecision.none;
                  }),
                  StreamBuilder<LoadingState>(
                    stream: controller.loadingState,
                    builder: (context, snapshot) {
                      if (snapshot.data == LoadingState.loading) {
                        return const LinearProgressIndicator();
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
