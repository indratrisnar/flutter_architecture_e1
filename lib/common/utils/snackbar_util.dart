import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';
import 'package:flutter_architecture_e1/common/enums.dart';

class SnackbarUtil {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, SnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, SnackbarType.error);
  }

  static void showNeutral(BuildContext context, String message) {
    _show(context, message, SnackbarType.neutral);
  }

  static void notImplementedYet(BuildContext context) {
    _show(context, 'Not implemented yet', SnackbarType.error);
  }

  static void _show(BuildContext context, String message, SnackbarType type) {
    Color backgroundColor = switch (type) {
      SnackbarType.success => AppColors.success,
      SnackbarType.error => AppColors.failed,
      SnackbarType.neutral => Colors.blueGrey,
    };
    Color textColor = Colors.white;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
