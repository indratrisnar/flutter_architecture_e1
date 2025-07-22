import 'package:flutter/material.dart';
import 'package:flutter_architecture_e1/presentation/dashboard/views/dashboard_page.dart';
import 'package:flutter_architecture_e1/presentation/home/views/home_fragment.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  late final config = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeFragment(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/discover',
                builder: (context, state) =>
                    const Center(child: Text('Discover')),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/account',
                builder: (context, state) =>
                    const Center(child: Text('Account')),
              ),
            ],
          ),
        ],
      ),
    ],
    initialLocation: '/home',
  );
}
