import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/keyboard.dart';
import 'package:hoomo_pos/domain/services/user_data.dart';
import 'package:hoomo_pos/presentation/desktop/screens/cubit/user_cubit.dart';

@RoutePage()
class LockerScreen extends StatefulWidget {
  const LockerScreen({super.key, this.onResult, required this.isFirstAuth});

  final VoidCallback? onResult;
  final bool isFirstAuth;

  @override
  State<LockerScreen> createState() => _LockerScreenState();
}

class _LockerScreenState extends State<LockerScreen> {
  String? _firstPin;
  bool _isConfirming = false;
  bool? _isFirstAuth; // Может быть null перед инициализацией
  final userDataService = getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    _checkFirstAuth();
  }

  Future<void> _checkFirstAuth() async {
    bool hasPin = await hasPinCode();
    setState(() {
      _isFirstAuth = !hasPin; // Если PIN нет, значит первый вход
    });
  }

  Future<void> _onPinEntered(String pin) async {
    if (_isFirstAuth == null) return; // Ждем, пока не будет инициализировано
    final messanger = ScaffoldMessenger.of(context);
    if (_isFirstAuth!) {
      if (!_isConfirming) {
        setState(() {
          _firstPin = pin;
          _isConfirming = true;
        });
      } else {
        if (_firstPin == pin) {
                    context.read<UserCubit>().init();

          await userDataService.setPinCode(pin);
          widget.onResult?.call();
        } else {
          setState(() {
            _isConfirming = false;
            _firstPin = null;
          });
          messanger.showSnackBar(
            SnackBar(content: Text('Коды не совпадают, попробуйте снова')),
          );
        }
      }
    } else {
      String pinCode = await userDataService.getPinCode() ?? "1234";
      if (pin == pinCode) {
        context.read<UserCubit>().init();

        widget.onResult?.call();
      } else {
        messanger.showSnackBar(
          SnackBar(content: Text('Неверный PIN-код')),
        );
      }
    }
  }

  Future<bool> hasPinCode() async {
    return await userDataService.getPinCode() != null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isFirstAuth == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Показываем загрузку
      );
    }

    ThemeData themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.cardColor,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300, maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: 150,
                  height: 80,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(height: 24),
              Text(
                _isFirstAuth!
                    ? (_isConfirming
                        ? context.tr('confirm_pin')
                        : context.tr('create_pin'))
                    : context.tr('enter_pin'),
                style: AppTextStyles.semiType32,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              PinInputWidget(onResult: _onPinEntered),
            ],
          ),
        ),
      ),
    );
  }
}
