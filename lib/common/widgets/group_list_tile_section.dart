import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';

class GroupListTileSection extends StatelessWidget {
  final List<Widget> children;
  final bool showDivider;
  final EdgeInsetsGeometry padding;

  const GroupListTileSection({
    super.key,
    required this.children,
    this.showDivider = true,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> childrenToDisplay = [];
    if (showDivider) {
      // Dynamically build the list of children with dividers
      for (int i = 0; i < children.length; i++) {
        childrenToDisplay.add(children[i]);
        // Add a Divider after each child, except the last one
        if (i < children.length - 1) {
          childrenToDisplay.add(
            const Divider(height: 1, color: AppColors.divider),
          );
        }
      }
    } else {
      // If no dividers are needed, just use the original children list
      childrenToDisplay.addAll(children);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.divider),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: childrenToDisplay,
          ),
        ),
      ),
    );
  }
}
