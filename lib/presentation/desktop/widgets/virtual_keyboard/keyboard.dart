import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/virtual_keyboard/type.dart';

import '../../../../core/styles/colors.dart';
import 'key.dart';
import 'key_action.dart';
import 'key_type.dart';
import 'layout_keys.dart';
import 'layouts.dart';

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

const int _virtualKeyboardBackspaceEventPerioud = 250;

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  final ValueChanged<VirtualKeyboardKey>? onKeyPress;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Virtual keyboard height. Default is full screen width
  final double? width;

  /// Color for key texts and icons.
  final Color textColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// the custom layout for multi or single language
  final VirtualKeyboardLayoutKeys? customLayoutKeys;

  /// the text controller go get the output and send the default input
  final TextEditingController? textController;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// inverse the layout to fix the issues with right to left languages.
  final bool reverseLayout;

  /// used for multi-languages with default layouts, the default is English only
  /// will be ignored if customLayoutKeys is not null
  final List<VirtualKeyboardDefaultLayouts>? defaultLayouts;

  final bool clearTextControllerBeforeKeyPress;

  const VirtualKeyboard(
      {Key? key,
      required this.type,
      this.onKeyPress,
      this.builder,
      this.width,
      this.defaultLayouts,
      this.customLayoutKeys,
      this.textController,
      this.reverseLayout = false,
      this.height = _virtualKeyboardDefaultHeight,
      this.textColor = Colors.black,
      this.fontSize = 14,
      this.alwaysCaps = false,
      required this.clearTextControllerBeforeKeyPress})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  late VirtualKeyboardType type;
  ValueChanged<VirtualKeyboardKey>? onKeyPress;
  late TextEditingController textController;
  // The builder function will be called for each Key object.
  Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  double? width;
  late Color textColor;
  late double fontSize;
  late bool alwaysCaps;
  late bool reverseLayout;
  late VirtualKeyboardLayoutKeys customLayoutKeys;
  // Text Style for keys.
  late TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = false;
  late bool clearTextControllerBeforeKeyPress;
  bool textControllerCleared = false;

  void _onKeyPress(VirtualKeyboardKey key) {
    if (clearTextControllerBeforeKeyPress && !textControllerCleared) {
      textController.text = "";
      textControllerCleared = true;
    }
    if (key.keyType == VirtualKeyboardKeyType.String) {
      textController.text += ((isShiftEnabled ? key.capsText : key.text) ?? '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (textController.text.isEmpty) {
            return;
          }
          textController.text =
              textController.text.substring(0, textController.text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          //textController.text += '\n';
          // Navigator.pop(context);
          break;
        case VirtualKeyboardKeyAction.Space:
          textController.text += (key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          break;
        default:
      }
    }

    onKeyPress?.call(key);
  }

  @override
  dispose() {
    if (widget.textController == null) {
      // dispose if created locally only
      textController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(VirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      builder = widget.builder;
      onKeyPress = widget.onKeyPress;
      height = widget.height;
      width = widget.width;
      textColor = widget.textColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      reverseLayout = widget.reverseLayout;
      textController = widget.textController ?? textController;
      customLayoutKeys = widget.customLayoutKeys ?? customLayoutKeys;
      textStyle = TextStyle(fontSize: fontSize, color: textColor);
      clearTextControllerBeforeKeyPress =
          widget.clearTextControllerBeforeKeyPress;
    });
  }

  @override
  void initState() {
    super.initState();

    textController = widget.textController ?? TextEditingController();
    width = widget.width;
    type = widget.type;
    customLayoutKeys = widget.customLayoutKeys ??
        VirtualKeyboardDefaultLayoutKeys(
            widget.defaultLayouts ?? [VirtualKeyboardDefaultLayouts.English]);
    builder = widget.builder;
    onKeyPress = widget.onKeyPress;
    height = widget.height;
    textColor = widget.textColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    reverseLayout = widget.reverseLayout;
    // Init the Text Style for keys.
    textStyle = TextStyle(fontSize: fontSize, color: textColor);
    clearTextControllerBeforeKeyPress =
        widget.clearTextControllerBeforeKeyPress;
  }

  @override
  Widget build(BuildContext context) {
    return type == VirtualKeyboardType.Numeric ? _numeric() : _alphanumeric();
  }

  Widget _alphanumeric() {
    return Container(
        padding: const EdgeInsets.all(5),
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _rows(),
        ));
  }

  Widget _numeric() {
    return Container(
        padding: const EdgeInsets.all(5),
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _rows()));
  }

  /// Keys for Virtual Keyboard's rows.
  static const List<List> _keyRowsNumeric = [
    [
      '1',
      '2',
      '3',
    ],
    [
      '4',
      '5',
      '6',
    ],
    [
      '7',
      '8',
      '9',
    ],
    [
      '.',
      '0',
    ],
  ];

  /// Returns reports list of `VirtualKeyboardKey` objects for Numeric keyboard.
  List<VirtualKeyboardKey> _getKeyboardRowKeysNumeric(rowNum) {
    // Generate VirtualKeyboardKey objects for each row.
    return List.generate(_keyRowsNumeric[rowNum].length, (int keyNum) {
      // Get key string value.
      String key = _keyRowsNumeric[rowNum][keyNum];

      // Create and return new VirtualKeyboardKey object.
      return VirtualKeyboardKey(
          text: key,
          capsText: key.toUpperCase(),
          keyType: VirtualKeyboardKeyType.String);
    });
  }

  /// Returns reports list of `VirtualKeyboardKey` objects.
  List<VirtualKeyboardKey> _getKeyboardRowKeys(
      VirtualKeyboardLayoutKeys layoutKeys, rowNum) {
    // Generate VirtualKeyboardKey objects for each row.
    return List.generate(layoutKeys.activeLayout[rowNum].length, (int keyNum) {
      // Get key string value.
      if (layoutKeys.activeLayout[rowNum][keyNum] is String) {
        String key = layoutKeys.activeLayout[rowNum][keyNum];

        // Create and return new VirtualKeyboardKey object.
        return VirtualKeyboardKey(
            text: key,
            capsText: key.toUpperCase(),
            keyType: VirtualKeyboardKeyType.String);
      } else {
        var action =
            layoutKeys.activeLayout[rowNum][keyNum] as VirtualKeyboardKeyAction;
        return VirtualKeyboardKey(
            keyType: VirtualKeyboardKeyType.Action, action: action);
      }
    });
  }

  /// Returns reports list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
  List<List<VirtualKeyboardKey>> _getKeyboardRows(
      VirtualKeyboardLayoutKeys layoutKeys) {
    // Generate lists for each keyboard row.
    return List.generate(layoutKeys.activeLayout.length,
        (int rowNum) => _getKeyboardRowKeys(layoutKeys, rowNum));
  }

  /// Returns reports list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
  List<List<VirtualKeyboardKey>> _getKeyboardRowsNumeric() {
    // Generate lists for each keyboard row.
    return List.generate(_keyRowsNumeric.length, (int rowNum) {
      // Will contain the keyboard row keys.
      List<VirtualKeyboardKey> rowKeys = [];

      // We have to add Action keys to keyboard.
      switch (rowNum) {
        case 3:
          // String keys.
          rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum));
          // Right Shift
          rowKeys.add(VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Backspace));
          break;
        default:
          rowKeys = _getKeyboardRowKeysNumeric(rowNum);
      }

      return rowKeys;
    });
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows =
        type == VirtualKeyboardType.Numeric
            ? _getKeyboardRowsNumeric()
            : _getKeyboardRows(customLayoutKeys);

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      var items = List.generate(keyboardRows[rowNum].length, (int keyNum) {
        // Get the VirtualKeyboardKey object.
        VirtualKeyboardKey virtualKeyboardKey = keyboardRows[rowNum][keyNum];

        Widget keyWidget;

        // Check if builder is specified.
        // Call builder function if specified or use default
        //  Key widgets if not.
        if (builder == null) {
          // Check the key type.
          switch (virtualKeyboardKey.keyType) {
            case VirtualKeyboardKeyType.String:
              // Draw String key.
              keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
              break;
            case VirtualKeyboardKeyType.Action:
              // Draw action key.
              keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
              break;
          }
        } else {
          // Call the builder function, so the user can specify custom UI for keys.
          keyWidget = builder!(context, virtualKeyboardKey);

          // if (keyWidget == null) {
          //   throw 'builder function must return Widget';
          // }
        }

        return keyWidget;
      });

      if (reverseLayout) {
        items = items.reversed.toList();
      }
      return Material(
          color: Colors.transparent,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Generate keyboard keys
              children: items));
    });

    return rows;
  }

  // True if long press is enabled.
  bool longPress = false;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.all(5),
            height: height / customLayoutKeys.activeLayout.length -
                (type == VirtualKeyboardType.Numeric ? -5 : 12),
            child: ElevatedButton(
                onPressed: () {
                  _onKeyPress(key);
                },
                style: ElevatedButton.styleFrom(
                    shadowColor: AppColors.primary100,
                    backgroundColor: const Color(0xffF4F4F4),
                    elevation: 0,
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Center(
                    child: Text(
                        alwaysCaps
                            ? key.capsText ?? ''
                            : (isShiftEnabled ? key.capsText : key.text) ?? '',
                        style: textStyle)))));
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget? actionKey;
    // Switch the action type to build action Key widget.
    switch (key.action ?? VirtualKeyboardKeyAction.SwithLanguage) {
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = GestureDetector(
            onLongPress: () {
              longPress = true;
              // Start sending backspace key events while longPress is true
              Timer.periodic(
                  const Duration(
                      milliseconds: _virtualKeyboardBackspaceEventPerioud),
                  (timer) {
                if (longPress) {
                  _onKeyPress(key);
                } else {
                  // Cancel timer.
                  timer.cancel();
                }
              });
            },
            onLongPressUp: () {
              // Cancel event loop
              longPress = false;
            },
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Icon(Icons.backspace, color: textColor)));
        break;
      case VirtualKeyboardKeyAction.Shift:
        actionKey = SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Icon(Icons.arrow_upward, color: textColor));
        break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Icon(Icons.space_bar, color: textColor));
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Icon(Icons.keyboard_return, color: textColor));
        break;
      case VirtualKeyboardKeyAction.SwithLanguage:
        actionKey = InkWell(
            onTap: () {
              setState(() {
                customLayoutKeys.switchLanguage();
              });
            },
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                    child: Text(customLayoutKeys.activeIndex == 0 ? 'RU' : 'UZ',
                        style: TextStyle(color: AppColors.secondary500)))));
        break;
      case VirtualKeyboardKeyAction.Symbol:
        actionKey = InkWell(
            onTap: () {
              setState(() {
                customLayoutKeys.showSymbol = !customLayoutKeys.showSymbol;
              });
            },
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                    child: Text(customLayoutKeys.showSymbol ? '123' : '=/#',
                        style: TextStyle(color: AppColors.secondary500)))));
    }

    var widget = Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        height: height / customLayoutKeys.activeLayout.length -
            (type == VirtualKeyboardType.Numeric ? -5 : 12),
        child: ElevatedButton(
            onPressed: () {
              if (key.action == VirtualKeyboardKeyAction.Shift) {
                if (!alwaysCaps) {
                  setState(() {
                    isShiftEnabled = !isShiftEnabled;
                  });
                }
              }
              _onKeyPress(key);
            },
            style: ElevatedButton.styleFrom(
                shadowColor: AppColors.primary100,
                backgroundColor: const Color(0xffF4F4F4),
                elevation: 0,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: actionKey));

    if (key.action == VirtualKeyboardKeyAction.Space) {
      return SizedBox(
          width: (width ?? MediaQuery.of(context).size.width) / 2,
          child: widget);
    } else {
      return Expanded(child: widget);
    }
  }
}
