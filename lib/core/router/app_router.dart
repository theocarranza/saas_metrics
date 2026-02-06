import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saas_metrics/features/auth/presentation/pages/login_page.dart';
import 'package:saas_metrics/features/auth/presentation/pages/sign_up_page.dart';
import 'package:saas_metrics/features/auth/presentation/providers/auth_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/pages/dashboard_page.dart';
import 'package:saas_metrics/features/onboarding/presentation/pages/onboarding_page.dart';

part 'app_router.g.dart';

/// Route paths as constants for type-safety
abstract class AppRoutes {
  static const login = '/';
  static const onboarding = '/onboarding';
  static const signUp = '/signup';
  static const dashboard = '/dashboard';
}

/// Provider for a listenable that notifies the router of auth state changes.
class RouterListenable extends ChangeNotifier {
  RouterListenable(Ref ref) {
    _subscription = ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }

  late final ProviderSubscription _subscription;

  void disposeSubscription() {
    _subscription.close();
  }
}

/// Provider for the GoRouter instance
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);
  final listenable = RouterListenable(ref);
  ref.onDispose(listenable.disposeSubscription);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: listenable,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated =
          authState.whenOrNull(
            data: (token) => token != null && token.isValid,
          ) ??
          false;

      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.onboarding;

      // Redirect unauthenticated users trying to access protected routes
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      // Redirect authenticated users away from auth routes to dashboard
      if (isAuthenticated && isAuthRoute) {
        return AppRoutes.dashboard;
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
