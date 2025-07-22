import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';
import 'package:flutter_architecture_e1/presentation/home/bloc/popular_destination_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'popular_destination.dart';

class HomeFragment extends StatelessWidget {
  const HomeFragment({super.key});

  Future<void> _onScrollRefresh(BuildContext context) async {
    context.read<PopularDestinationBloc>().add(
      const RefreshPopularDestinationsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      displacement: 10,
      onRefresh: () => _onScrollRefresh(context),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 40, bottom: 100),
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ready to go to next\nbeautiful place?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Gap(20),
          PopularDestination(),
          Gap(20),
        ],
      ),
    );
  }
}
