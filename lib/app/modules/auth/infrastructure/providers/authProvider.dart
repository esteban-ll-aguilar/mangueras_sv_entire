import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authProvider.g.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final SupabaseClient _supabase;
  @override
  AuthState build() {
    _supabase = ref.read(supabaseProvider);
    _initialize();
    return const AuthStateUnauthenticated();
  }

  Future<void> _initialize() async {
    final session = _supabase.auth.currentSession;

    if (session != null) {
      state = AuthStateAuthenticated(session.user);
    }

    _supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            state = AuthStateAuthenticated(session.user);
          }
          break;
        
        case AuthChangeEvent.userUpdated:
          if (session != null) {
            state = AuthStateAuthenticated(session.user);
          }
          break;

        case AuthChangeEvent.signedOut:
          state = const AuthStateUnauthenticated();
          break;

        case AuthChangeEvent.passwordRecovery:
          // Handle password recovery if needed
          break;
        default:
          break;
      }
    });
  }



  Future<void> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!);
      } 
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password
      );

      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!);
      } 
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      state = const AuthStateUnauthenticated();
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {...updates},
        ),
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!);
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> createUserProfile({ required String email, required String password, required String fullName}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        }
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!);
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

}
