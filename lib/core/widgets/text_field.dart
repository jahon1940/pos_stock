import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/virtual_keyboard/type.dart';
import 'package:hoomo_pos/presentation/desktop/widgets/virtual_keyboard/virtual_keyboard_widget.dart';

class AppTextField extends StatelessWidget {
  final double? enableBorderWidth;
  final String? label;
  final VoidCallback? onFieldTap;
  final TextEditingController? fieldController;
  final double? height;
  final double? width;
  final EdgeInsets? prefixPadding;
  final Widget? suffix;
  final TextInputType? textInputType;
  final Color? fillColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final List<TextInputFormatter> textInputFormatter;
  final bool readOnly;
  final int? maxLength;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final bool? alignLabelWithHint;
  final double radius;
  final TextInputAction? inputAction;
  final Widget? prefix;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsets? contentPadding;
  final TextStyle? hintStyle;
  final String? hint;
  final bool obscureText;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final double enabledBorderWith;
  final Color? enabledBorderColor;
  final double focusedBorderWith;
  final bool showKeyboard;
  final VirtualKeyboardType? keyboardType;
  final Color? focusedBorderColor;
  final TextAlign textAlign;
  final VoidCallback? onEditingComplete;
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.onFieldTap,
    this.fieldController,
    this.height,
    this.suffix,
    this.prefix,
    this.textInputType = TextInputType.text,
    this.fillColor,
    this.autoFocus = false,
    this.focusNode,
    this.onChange,
    this.prefixPadding,
    this.readOnly = false,
    this.textInputFormatter = const [],
    this.maxLength,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.alignLabelWithHint,
    this.radius = 8,
    this.inputAction,
    this.onFieldSubmitted,
    this.contentPadding,
    this.hintStyle,
    this.hint,
    this.width,
    this.obscureText = false,
    this.style,
    this.labelStyle,
    this.enabledBorderWith = 0,
    this.enabledBorderColor,
    this.focusedBorderWith = 0,
    this.focusedBorderColor,
    this.textAlign = TextAlign.start,
    this.onEditingComplete,
    this.errorText,
    this.showKeyboard = false,
    this.keyboardType = VirtualKeyboardType.Alphanumeric,
    this.enableBorderWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color bgColor = fillColor != null ? fillColor! : theme.shadowColor;
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        readOnly: readOnly,
        validator: validator,
        style: style ?? context.bodyLarge!.copyWith(fontSize: 16),
        onTap: onFieldTap,
        textAlign: textAlign,
        maxLength: maxLength,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        textInputAction: inputAction,
        controller: fieldController,
        keyboardType: textInputType,
        autofocus: autoFocus,
        inputFormatters: textInputFormatter,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChange,
        textCapitalization: textCapitalization,
        cursorColor: theme.primaryColor,
        cursorErrorColor: theme.primaryColor,
        maxLines: maxLines,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: errorText,
          labelStyle: labelStyle ?? AppTextStyles.rType16,
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          counterText: '',
          prefixIcon: prefix != null
              ? Padding(
                  padding: prefixPadding ?? const EdgeInsets.all(16.0),
                  child: prefix,
                )
              : null,
          suffixIcon: suffix != null || showKeyboard
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (suffix != null) suffix!,
                    if (showKeyboard)
                      VirtualKeyboardWidget(
                        controller: fieldController ?? TextEditingController(),
                        keyboardType: keyboardType ?? VirtualKeyboardType.Alphanumeric,
                        containerMarginRight: 10,
                      ),
                  ],
                )
              : null,
          isDense: true,
          prefixIconConstraints: const BoxConstraints(),
          filled: true,
          hintText: hint,
          labelText: label,
          hintStyle: hintStyle ?? AppTextStyles.rType16,
          alignLabelWithHint: alignLabelWithHint,
          fillColor: bgColor,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelStyle: AppTextStyles.rType12,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: focusedBorderColor ?? theme.primaryColor,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: enableBorderWidth ?? 0.3,
              color: enabledBorderColor ?? context.theme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(radius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.error500),
            borderRadius: BorderRadius.circular(radius),
          ),
          errorMaxLines: 3,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.error500),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
