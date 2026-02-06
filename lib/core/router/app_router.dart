import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saas_metrics/features/auth/presentation/pages/login_page.dart';
import 'package:saas_metrics/features/auth/presentation/pages/sign_up_page.dart';
import 'package:saas_metrics/features/auth/presentation/providers/auth_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/pages/dashboard_page.dart';
import 'package:saas_metrics/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:saas_metrics/features/onboarding/presentation/providers/onboarding_provider.dart';

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
    _authSubscription = ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
    _onboardingSubscription = ref.listen(onboardingProvider, (previous, next) {
      notifyListeners();
    });
  }

  late final ProviderSubscription _authSubscription;
  late final ProviderSubscription _onboardingSubscription;

  @override
  void dispose() {
    _authSubscription.close();
    _onboardingSubscription.close();
    super.dispose();
  }
}

/// Provider for the GoRouter instance
@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);
  final onboardingState = ref.watch(onboardingProvider);
  final listenable = RouterListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: listenable,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      if (authState.isLoading || onboardingState.isLoading) {
        return null;
      }

      final isAuthenticated =
          authState.value != null && authState.value!.isValid;

      final hasSeenOnboarding = onboardingState.value ?? false;

      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.onboarding;

      // 1. Unauthenticated users
      if (!isAuthenticated) {
        // Force onboarding on first run
        if (!hasSeenOnboarding) {
          if (state.matchedLocation != AppRoutes.onboarding) {
            return AppRoutes.onboarding;
          }
          return null;
        }

        // If they have seen onboarding but are on the onboarding page, go to login
        if (state.matchedLocation == AppRoutes.onboarding) {
          return AppRoutes.login;
        }

        // Protect internal routes
        if (!isAuthRoute) {
          return AppRoutes.login;
        }
      }

      // 2. Authenticated users
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
