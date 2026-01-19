import 'package:flutter/material.dart';

class CustomTextformfield extends StatelessWidget {
  CustomTextformfield({
    super.key,
    this.labelText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.hintText,
    this.labelStyle,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines,
    this.initialValue,
    this.borderRadius,
    this.contentPadding,
    this.controller
  });
  String? labelText, hintText;
  TextInputType? keyboardType;
  String? Function(String?)? validator;
  Function(String)? onChanged;
  TextStyle? labelStyle;
  Widget? suffixIcon;
  bool? obscureText;
  int? maxLines = 1;
  String? initialValue;
  double? borderRadius;
  EdgeInsetsGeometry? contentPadding;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      maxLines: maxLines,
      obscureText: obscureText!,
      keyboardType: keyboardType ?? TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        labelStyle: labelStyle,
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
      ),
    );
  }
}
