import 'package:credit_card_input/credit_card_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputWidget extends StatelessWidget {
  final String label;

  final CreditCardTheme theme;
  final double left;
  final double right;
  final double bottom;
  final double top;
  final List<TextInputFormatter>? formatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? password;
  final Function(String)? onChanged;
  final Function? onDone;
  final Widget? suffixIcon;
  final double fontSize;
  final TextEditingController? controller;

  const TextInputWidget({
    super.key,
    required this.label,
    required this.theme,
    required this.fontSize,
    required this.onChanged,
    this.onDone,
    this.formatters,
    this.keyboardType,
    this.textInputAction,
    this.password,
    this.suffixIcon,
    this.controller,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
    this.top = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: left > 0 ? theme.borderColor : Colors.transparent,
            width: left,
          ),
          right: BorderSide(
            color: right > 0 ? theme.borderColor : Colors.transparent,
            width: right,
          ),
          top: BorderSide(
            color: top > 0 ? theme.borderColor : Colors.transparent,
            width: top,
          ),
          bottom: BorderSide(
            color: bottom > 0 ? theme.borderColor : Colors.transparent,
            width: bottom,
          ),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: theme.textColor,
          fontSize: fontSize,
        ),
        onChanged: onChanged,
        onFieldSubmitted: (val) {
          onDone?.call();
        },
        obscureText: password ?? false,
        inputFormatters: formatters ?? [],
        keyboardType: keyboardType ?? TextInputType.number,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.all(15),
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(
            color: theme.labelColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
