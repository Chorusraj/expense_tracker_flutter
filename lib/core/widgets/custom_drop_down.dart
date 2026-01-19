import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown({
    super.key,
    required this.onChanged,
    required this.items,
    this.labelText,
    this.validator,
    this.hintText,
    this.initialValue,
    this.borderRadius,
  });
  Function(dynamic)? onChanged;
  List<String>? items;
  String? labelText, hintText;
  String? Function(String?)? validator;
  String? initialValue;
  double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
      ),
      items: items
          ?.map((item) => DropdownMenuItem(child: Text(item), value: item))
          .toList(),
      onChanged: onChanged,
    );
  }
}
