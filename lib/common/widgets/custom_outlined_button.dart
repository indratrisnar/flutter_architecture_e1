import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double width;
  final double? height;
  final String? icon;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color outlineColor;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = 46,
    this.icon,
    this.foregroundColor,
    this.backgroundColor,
    this.outlineColor = AppColors.divider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          side: BorderSide(color: outlineColor, width: 1),
        ),
        onPressed: onPressed,
        icon: icon == null ? null : ImageIcon(AssetImage(icon!), size: 15),
        label: Text(text),
      ),
    );
  }
}
