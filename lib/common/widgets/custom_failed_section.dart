import 'package:extended_image/extended_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_assets.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:gap/gap.dart';

class CustomFailedSection extends StatelessWidget {
  final Failure failure;
  final Widget? action;
  const CustomFailedSection({super.key, required this.failure, this.action});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ExtendedImage.asset(
                _mappingFailureImages,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(16),
            Text(
              _mappingFailureTitles,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              failure.message,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const Gap(16),
            ?action,
          ],
        ),
      ),
    );
  }

  String get _mappingFailureImages => switch (failure) {
    CacheFailure _ => AppAssets.images.failures.cache,
    NetworkFailure _ => AppAssets.images.failures.network,
    NoConnectionFailure _ => AppAssets.images.failures.noConnection,
    NotFoundFailure _ => AppAssets.images.failures.notFound,
    ServerFailure _ => AppAssets.images.failures.server,
    ServiceUnavailableFailure _ => AppAssets.images.failures.serviceUnavailable,
    UnauthenticatedFailure _ => AppAssets.images.failures.unauthenticated,
    PermissionFailure _ => AppAssets.images.failures.permission,
    _ => AppAssets.images.failures.unexpected,
  };

  String get _mappingFailureTitles => switch (failure) {
    CacheFailure _ => 'Cache Error',
    NetworkFailure _ => 'Network Error',
    NoConnectionFailure _ => 'No Connection',
    NotFoundFailure _ => 'Not Found',
    ServerFailure _ => 'Server Error',
    ServiceUnavailableFailure _ => 'Service Unavailable',
    UnauthenticatedFailure _ => 'Unauthenticated',
    PermissionFailure _ => 'No Permission',
    _ => 'Unknown Error',
  };
}
