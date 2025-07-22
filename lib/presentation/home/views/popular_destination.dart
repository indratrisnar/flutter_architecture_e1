import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';
import 'package:flutter_architecture_e1/common/widgets/custom_failed_section.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:flutter_architecture_e1/presentation/home/bloc/popular_destination_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'popular_destination_item.dart';

class PopularDestination extends StatefulWidget {
  const PopularDestination({super.key});

  @override
  State<PopularDestination> createState() => _PopularDestinationState();
}

class _PopularDestinationState extends State<PopularDestination> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PopularDestinationBloc>().add(
        const FetchPopularDestinationsEvent(),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Destination',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 300,
          child: BlocBuilder<PopularDestinationBloc, PopularDestinationState>(
            builder: (context, state) {
              if (state is PopularDestinationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PopularDestinationFailed) {
                return CustomFailedSection(failure: state.failure);
              }
              if (state is PopularDestinationLoaded) {
                final list = state.destinations;
                if (list.isEmpty) {
                  return const CustomFailedSection(
                    failure: NotFoundFailure(
                      message: 'No popular destination yet',
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: list.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final destination = list[index];
                    return PopularDestinationItem(
                      destination: destination,
                      index: index,
                      lastIndex: list.length - 1,
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
