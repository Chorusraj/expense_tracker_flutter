import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    this.onPressed,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
  });
  Function()? onPressed;
  Widget? child;
  Color? backgroundColor;
  Color? foregroundColor;
  double? borderRadius;
  EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: backgroundColor ?? Colors.black,
          foregroundColor: foregroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
