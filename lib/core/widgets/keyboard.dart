import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';

class PinInputWidget extends StatefulWidget {
  const PinInputWidget({super.key, this.codeLength = 4, this.onResult});

  final int codeLength;
  final ValueChanged<String>? onResult;

  @override
  State<PinInputWidget> createState() => _PinInputWidgetState();
}

class _PinInputWidgetState extends State<PinInputWidget> {
  String code = '';
  final userDataService = getIt<UserDataService>();

  late final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    [Icons.exit_to_app_outlined, '0', Icons.backspace],
  ];

  late final renderKeyboard = keys
      .map(
        (x) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: x.map(
            (y) {
              if (y == '') {
                return SizedBox(width: 80, height: 80);
              }

              return InkWell(
                borderRadius: BorderRadius.circular(80),
                highlightColor: Colors.transparent,
                onTap: () {
                  if (y == Icons.backspace) {
                    if (code.isEmpty) return;

                    code = code.substring(0, code.length - 1);
                    setState(() {});
                    return;
                  } else if (y == Icons.exit_to_app_outlined) {
                    userDataService.deletePinCode();
                    userDataService.setToken(null);
                    context.router.push(LoginRoute(
                      onResult: () {
                        context.router.push(LockerRoute(
                          isFirstAuth: false,
                          onResult: () {
                            userDataService.setUnlocked(true);
                            userDataService.setFirstAuth(true);
                            userDataService.deleteSecure();
                            context.router.push(MainRoute());
                          },
                        ));
                      },
                    ));
                    return;
                  }

                  code += y as String;
                  setState(() {});

                  if (code.length == widget.codeLength) {
                    widget.onResult?.call(code);
                    code = '';
                    setState(() {});
                    return;
                  }
                },
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Center(
                    child: y is IconData
                        ? Icon(y)
                        : Text(
                            y.toString(),
                            style: AppTextStyles.rType24,
                          ),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: List.generate(
              widget.codeLength,
              (index) => SizedBox(
                width: 20,
                height: 20,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: code.length - 1 < index
                        ? Colors.black12
                        : context.theme.primaryColor,
                  ),
                ),
              ),
            ),
          ),
          ...renderKeyboard
        ],
      ),
    );
  }
}
