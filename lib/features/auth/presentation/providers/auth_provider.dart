import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saas_metrics/features/auth/domain/entities/auth_token.dart';
import 'package:saas_metrics/features/auth/data/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepository();

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<AuthToken?> build() async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.restoreSession();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      return await repository.login(email, password);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      return null;
    });
  }
}
