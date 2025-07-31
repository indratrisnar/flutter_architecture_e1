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
    // refreshListenable: GoRouterRefreshStream(_authBloc.stream),
    // redirect: (context, state) {
    //   final currentPath = state.fullPath;
    //   final authenticated = _authBloc.state is Authenticated;

    //   final publicPaths = [
    //     loadAppPath,
    //     onboardingPath,
    //     loginPath,
    //     registerPath,
    //   ];

    //   if (authenticated) {
    //     // has session
    //     if (publicPaths.contains(currentPath)) {
    //       return homePath; // redirect
    //     }
    //     return null; // no redirect
    //   }

    //   if (!authenticated) {
    //     // no session
    //     if (publicPaths.contains(currentPath)) {
    //       return null; // no redirect
    //     }
    //     return onboardingPath; // redirect
    //   }

    //   return null; // No redirect
    // },
  );
}

// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<AuthState> stream) {
//     _authSubscription = stream.listen((event) => notifyListeners());
//   }

//   late final StreamSubscription<AuthState> _authSubscription;

//   @override
//   void dispose() {
//     _authSubscription.cancel();
//     super.dispose();
//   }
// }
