import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'authProvider.g.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateAuthenticated extends AuthState {
  final User user;
  /// Rol cacheado desde public.profiles para guards síncronos del router.
  /// null = aún cargando / sin perfil.
  final String? role;
  const AuthStateAuthenticated(this.user, {this.role});

  bool get isAdmin => role == 'admin';
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

  Future<String?> _fetchRole(String uid) async {
    try {
      final row = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', uid)
          .maybeSingle();
      return (row?['role'] as String?) ?? 'cliente';
    } catch (_) {
      return 'cliente';
    }
  }

  Future<void> refreshRole() async {
    final s = state;
    if (s is AuthStateAuthenticated) {
      final role = await _fetchRole(s.user.id);
      state = AuthStateAuthenticated(s.user, role: role);
    }
  }

  Future<void> _initialize() async {
    final session = _supabase.auth.currentSession;

    if (session != null) {
      final role = await _fetchRole(session.user.id);
      state = AuthStateAuthenticated(session.user, role: role);
    }

    _supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            final role = await _fetchRole(session.user.id);
            state = AuthStateAuthenticated(session.user, role: role);
          }
          break;

        case AuthChangeEvent.userUpdated:
          if (session != null) {
            final role = await _fetchRole(session.user.id);
            state = AuthStateAuthenticated(session.user, role: role);
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
        final role = await _fetchRole(response.user!.id);
        state = AuthStateAuthenticated(response.user!, role: role);
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(_friendlyAuthError(e.message));
    } catch (e) {
      state = AuthStateError(_friendlyAuthError(e.toString()));
    }
  }

  String _friendlyAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('user already registered') ||
        lower.contains('already registered') ||
        lower.contains('already exists')) {
      return 'Este correo ya está registrado. Intenta iniciar sesión.';
    }
    if (lower.contains('invalid email') || lower.contains('invalid login')) {
      return 'Correo electrónico o contraseña inválidos.';
    }
    if (lower.contains('password') && lower.contains('short')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Debes confirmar tu correo antes de iniciar sesión.';
    }
    return message;
  }

  /// Registro público: siempre rol cliente por defecto.
  /// El trigger handle_new_user() crea el profile en public.profiles.
  /// Se deja fallback por si el trigger tarda o email requiere confirmación.
  Future<void> signUp(
    String email,
    String password, {
    String fullName = '',
    String role = 'cliente',
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': role},
      );

      // Si Supabase exige confirmación de email, session será null
      // aunque user exista. En ese caso no autenticamos todavía.
      if (response.session != null && response.user != null) {
        // Fallback: asegura profile cliente si el trigger aún no corrió
        try {
          await _supabase.from('profiles').upsert({
            'id': response.user!.id,
            'email': email,
            'full_name': fullName,
            'role': role,
          }, onConflict: 'id');
        } catch (_) {}
        state = AuthStateAuthenticated(response.user!, role: role);
      } else if (response.user != null && response.session == null) {
        state = const AuthStateError(
          'Cuenta creada. Revisa tu correo para confirmar tu cuenta.',
        );
      } else {
        state = const AuthStateError(
          'No se pudo crear la cuenta. Intenta de nuevo.',
        );
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(_friendlyAuthError(e.message));
    } catch (e) {
      state = AuthStateError(_friendlyAuthError(e.toString()));
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
        final role = await _fetchRole(response.user!.id);
        state = AuthStateAuthenticated(response.user!, role: role);
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
          'role': 'cliente',
        }
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!, role: 'cliente');
      }
    } on AuthApiException catch (e) {
      state = AuthStateError(e.message);
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

}
