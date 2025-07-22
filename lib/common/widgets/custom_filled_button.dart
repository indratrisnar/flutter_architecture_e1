import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double width;
  final double? height;
  final String? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomFilledButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = 46,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        onPressed: onPressed,
        icon: icon == null ? null : ImageIcon(AssetImage(icon!), size: 15),
        label: Text(text),
      ),
    );
  }
}
