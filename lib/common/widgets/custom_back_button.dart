import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.backgroundColor = Colors.white});
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: IconButton.filled(
        onPressed: () => context.pop(),
        style: IconButton.styleFrom(backgroundColor: backgroundColor),
        icon: Icon(Icons.arrow_back, size: 20),
      ),
    );
  }
}
