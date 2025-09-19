import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/virtual_keyboard/key_action.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/virtual_keyboard/type.dart';
import 'keyboard.dart';
import 'layouts.dart';

class VirtualKeyboardWidget extends StatefulWidget {
  final TextEditingController controller;
  final VirtualKeyboardType keyboardType;
  final double containerMarginRight;
  final bool clearTextControllerBeforeKeyPress;
  final GlobalKey widgetKey = GlobalKey();

  VirtualKeyboardWidget({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.containerMarginRight = 0,
    this.clearTextControllerBeforeKeyPress = true,
  });

  @override
  State<VirtualKeyboardWidget> createState() => _VirtualKeyboardWidgetState();
}

class _VirtualKeyboardWidgetState extends State<VirtualKeyboardWidget> {
  OverlayEntry? _overlayEntry;
  double _keyboardPositionLeft = 0;
  double _keyboardPositionBottom = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: widget.containerMarginRight),
      child: IconButton(
        key: widget.widgetKey,
        tooltip: 'Клавиатура',
        onPressed: () {
          if (_overlayEntry == null) {
            _showKeyboardOverlay(context);
          } else {
            _hideKeyboardOverlay();
          }
        },
        highlightColor: context.secondary,
        splashColor: Colors.white,
        padding: EdgeInsets.zero,
        icon: Icon(Icons.keyboard_alt_rounded,
            color: AppColors.secondary900, size: 20),
      ),
    );
  }

  void _showKeyboardOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardSize =
        _getKeyboardSize(widget.keyboardType, screenWidth, screenHeight);

    // Initial position at the bottom center
    _keyboardPositionLeft = (screenWidth - keyboardSize.width) / 2;
    _keyboardPositionBottom = 0;

    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Positioned(
            left: _keyboardPositionLeft,
            bottom: _keyboardPositionBottom,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _keyboardPositionLeft += details.delta.dx;
                  _keyboardPositionBottom -= details.delta.dy;

                  // Keep the keyboard within screen bounds (optional)
                  if (_keyboardPositionLeft < 0) _keyboardPositionLeft = 0;
                  if (_keyboardPositionLeft >
                      screenWidth - keyboardSize.width) {
                    _keyboardPositionLeft = screenWidth - keyboardSize.width;
                  }
                  if (_keyboardPositionBottom < 0) _keyboardPositionBottom = 0;
                  if (_keyboardPositionBottom >
                      screenHeight - keyboardSize.height) {
                    _keyboardPositionBottom =
                        screenHeight - keyboardSize.height;
                  }
                });
              },
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppSpace.vertical24,
                          VirtualKeyboard(
                            height: keyboardSize.height,
                            width: keyboardSize.width,
                            textColor: Colors.black,
                            fontSize: 24,
                            defaultLayouts: const [
                              VirtualKeyboardDefaultLayouts.English,
                              VirtualKeyboardDefaultLayouts.Russian
                            ],
                            type: widget.keyboardType,
                            textController: widget.controller,
                            clearTextControllerBeforeKeyPress:
                                widget.clearTextControllerBeforeKeyPress,
                            onKeyPress: (e) {
                              if (e.action == VirtualKeyboardKeyAction.Return) {
                                _hideKeyboardOverlay();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: Icon(Icons.close,
                            color: context.secondary, size: 20),
                        onPressed: _hideKeyboardOverlay,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 25, minHeight: 25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideKeyboardOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  /// Определение размеров клавиатуры
 Size _getKeyboardSize(
      VirtualKeyboardType type, double screenWidth, double screenHeight) {
    double keyboardWidth;
    double keyboardHeight;

    // Определяем константы для минимальных/максимальных размеров и пропорций
    // (Эти значения можно подбирать для лучшего вида)
    const double minNumericWidth = 280.0;
    const double maxNumericWidth = 380.0; // Немного уменьшили макс. ширину для числовой
    const double numericHeightRatio = 0.30; // Уменьшили долю высоты экрана для числовой
    const double minNumericHeight = 220.0; // Немного уменьшили мин. высоту
    const double maxNumericHeight = 320.0; // Немного уменьшили макс. высоту

    const double alphanumericHeightRatio =
        0.30; // Уменьшили долю высоты экрана для буквенной
    const double minAlphanumericHeight = 200.0; // Немного уменьшили мин. высоту
    const double maxAlphanumericHeight = 380.0; // Немного уменьшили макс. высоту
    // Буквенная клавиатура обычно занимает всю ширину (или почти всю)
    const double maxAlphanumericWidth =
        800.0; // Немного уменьшили ограничение для очень широких экранов

    if (type == VirtualKeyboardType.Numeric) {
      // --- Расчет для числовой клавиатуры ---
      // Ширина: процент от ширины экрана, но в пределах min/max
      // Уменьшили коэффициент для начального расчета ширины
      keyboardWidth = (screenWidth * 0.40).clamp(
          minNumericWidth, maxNumericWidth); // clamp ограничивает значение

      // Высота: процент от высоты экрана, но в пределах min/max
      // Используем уменьшенный numericHeightRatio
      keyboardHeight = (screenHeight * numericHeightRatio)
          .clamp(minNumericHeight, maxNumericHeight);

      // Альтернатива: высота зависит от расчитанной ширины (сохранение пропорций)
      // double desiredHeight = keyboardWidth * 1.0; // Пример пропорции 1:1
      // keyboardHeight = desiredHeight.clamp(minNumericHeight, maxNumericHeight);
    } else {
      // --- Расчет для буквенно-цифровой клавиатуры ---
      // Ширина: вся доступная ширина экрана, но не более maxAlphanumericWidth
       keyboardWidth = screenWidth.clamp(
          0.0, maxAlphanumericWidth); // Используем min() вместо clamp

      // Высота: процент от высоты экрана, в пределах min/max
      // Используем уменьшенный alphanumericHeightRatio
      keyboardHeight = (screenHeight * alphanumericHeightRatio)
          .clamp(minAlphanumericHeight, maxAlphanumericHeight);

      // Альтернатива: высота зависит от ширины (например, пропорция ~2.5 : 1)
      // double desiredHeight = keyboardWidth / 2.5;
      // keyboardHeight = desiredHeight.clamp(minAlphanumericHeight, maxAlphanumericHeight);
    }

    // Дополнительная проверка: размеры не должны превышать размеры экрана
    keyboardWidth = min(keyboardWidth, screenWidth);
    keyboardHeight = min(keyboardHeight, screenHeight);

    // Для отладки можно раскомментировать:
    // print('Screen: ${screenWidth.toStringAsFixed(1)}x${screenHeight.toStringAsFixed(1)}, Type: $type, Keyboard Size: ${keyboardWidth.toStringAsFixed(1)}x${keyboardHeight.toStringAsFixed(1)}');

    return Size(keyboardWidth, keyboardHeight);
  }
}
