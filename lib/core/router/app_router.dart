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
import 'package:saas_metrics/features/financial_modeling/presentation/providers/initial_simulation_provider.dart';
import 'package:saas_metrics/features/financial_modeling/presentation/pages/simulation_loading_page.dart';

part 'app_router.g.dart';

/// Route paths as constants for type-safety
abstract class AppRoutes {
  static const login = '/';
  static const onboarding = '/onboarding';
  static const signUp = '/signup';
  static const dashboard = '/dashboard';
  static const simulationLoading = '/loading-simulation';
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
    _simulationSubscription = ref.listen(initialSimulationProvider, (
      previous,
      next,
    ) {
      notifyListeners();
    });
  }

  late final ProviderSubscription _authSubscription;
  late final ProviderSubscription _onboardingSubscription;
  late final ProviderSubscription _simulationSubscription;

  @override
  void dispose() {
    _authSubscription.close();
    _onboardingSubscription.close();
    _simulationSubscription.close();
    super.dispose();
  }
}

/// Provider for the GoRouter instance
@riverpod
GoRouter appRouter(Ref ref) {
  final listenable = RouterListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: listenable,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final onboardingState = ref.read(onboardingProvider);
      final simulationState = ref.read(initialSimulationProvider);

      if (authState.isLoading ||
          onboardingState.isLoading ||
          simulationState.isLoading) {
        return null;
      }

      final isAuthenticated =
          authState.value != null && authState.value!.isValid;
      final hasSeenOnboarding = onboardingState.value ?? false;
      final hasRunSimulation = simulationState.value ?? false;

      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.onboarding;

      // ... rest of redirection logic
      if (!isAuthenticated) {
        if (!hasSeenOnboarding) {
          if (state.matchedLocation != AppRoutes.onboarding) {
            return AppRoutes.onboarding;
          }
          return null;
        }
        if (state.matchedLocation == AppRoutes.onboarding) {
          return AppRoutes.login;
        }
        if (!isAuthRoute) {
          return AppRoutes.login;
        }
      }

      // 2. Authenticated users
      if (isAuthenticated && isAuthRoute) {
        if (!hasRunSimulation) return AppRoutes.simulationLoading;
        return AppRoutes.dashboard;
      }

      if (isAuthenticated &&
          state.matchedLocation == AppRoutes.dashboard &&
          !hasRunSimulation) {
        return AppRoutes.simulationLoading;
      }

      if (isAuthenticated &&
          state.matchedLocation == AppRoutes.simulationLoading &&
          hasRunSimulation) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    // ... rest of routes
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
        path: AppRoutes.simulationLoading,
        name: 'simulationLoading',
        builder: (context, state) => const SimulationLoadingPage(),
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
