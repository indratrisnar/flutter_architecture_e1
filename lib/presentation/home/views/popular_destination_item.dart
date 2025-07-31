import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';
import 'package:flutter_architecture_e1/data/models/destination_model.dart';
import 'package:go_router/go_router.dart';

class PopularDestinationItem extends StatelessWidget {
  final DestinationModel destination;
  final int index;
  final int lastIndex;

  const PopularDestinationItem({
    super.key,
    required this.destination,
    required this.index,
    required this.lastIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/destinations/${destination.id}');
      },
      child: Container(
        padding: EdgeInsets.only(
          left: index == 0 ? 16 : 8,
          right: index == lastIndex ? 16 : 8,
        ),
        width: 240,
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ExtendedImage.network(
                  destination.cover,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                    tileMode: TileMode.clamp,
                  ),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.textThin.withAlpha(50),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            destination.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        const Icon(
                          Icons.arrow_forward_outlined,
                          size: 20,
                          color: AppColors.textThin,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
