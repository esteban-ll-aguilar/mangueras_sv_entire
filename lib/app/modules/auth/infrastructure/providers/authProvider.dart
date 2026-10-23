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

  /// Fase 3: mensaje genérico al usuario, sin exponer texto crudo del servidor.
  /// No se retorna [message] tal cual para evitar fuga (proveedor, idioma,
  /// enumeración de cuentas). El detalle queda en el log vía `logging`.
  String _friendlyAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('user already registered') ||
        lower.contains('already registered') ||
        lower.contains('already exists')) {
      return 'No se pudo completar el registro. Si ya tienes cuenta, inicia sesión.';
    }
    if (lower.contains('invalid login') ||
        lower.contains('invalid email') ||
        lower.contains('invalid credentials') ||
        lower.contains('email not confirmed')) {
      // Mensaje único anti-enumeración: no confirma si el correo existe.
      return 'Credenciales inválidas. Verifica tu correo y contraseña.';
    }
    if (lower.contains('password') &&
        (lower.contains('short') || lower.contains('weak'))) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
<<<<<<< HEAD
    return 'Ocurrió un error de autenticación. Intenta de nuevo.';
=======
    if (lower.contains('email not confirmed')) {
      return 'Debes confirmar tu correo antes de iniciar sesión.';
    }
    return 'No se pudo completar la operación. Intenta de nuevo.';
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
  }

  /// Registro público: siempre rol cliente por defecto.
  /// El trigger handle_new_user() crea el profile en public.profiles.
  /// Se deja fallback por si el trigger tarda o email requiere confirmación.
  Future<void> signUp(
    String email,
    String password, {
    String fullName = '',
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        // Never accept a role from public registration input.
        data: {'full_name': fullName},
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
          }, onConflict: 'id');
        } catch (_) {}
        state = AuthStateAuthenticated(response.user!, role: 'cliente');
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
<<<<<<< HEAD
      state = AuthStateError(_friendlyAuthError(e.message));
    } catch (e) {
      state = const AuthStateError(
        'No se pudo cerrar la sesión. Intenta de nuevo.',
      );
=======
      state = const AuthStateError('No se pudo cerrar la sesión.');
    } catch (e) {
      state = const AuthStateError('No se pudo cerrar la sesión.');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    }
  }

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
<<<<<<< HEAD
      state = AuthStateError(_friendlyAuthError(e.message));
    } catch (_) {
      state = const AuthStateError(
        'No se pudo enviar el correo. Intenta de nuevo.',
=======
      state = const AuthStateError(
        'No se pudo enviar el correo de recuperación.',
      );
    } catch (e) {
      state = const AuthStateError(
        'No se pudo enviar el correo de recuperación.',
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
      );
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(data: {...updates}),
      );
      if (response.user != null) {
        final role = await _fetchRole(response.user!.id);
        state = AuthStateAuthenticated(response.user!, role: role);
      }
    } on AuthApiException catch (e) {
<<<<<<< HEAD
      state = AuthStateError(_friendlyAuthError(e.message));
    } catch (_) {
      state = const AuthStateError(
        'No se pudo actualizar el perfil. Intenta de nuevo.',
      );
=======
      state = const AuthStateError('No se pudo actualizar el perfil.');
    } catch (e) {
      state = const AuthStateError('No se pudo actualizar el perfil.');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    }
  }

  Future<void> createUserProfile({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      if (response.user != null) {
        state = AuthStateAuthenticated(response.user!, role: 'cliente');
      }
    } on AuthApiException catch (e) {
<<<<<<< HEAD
      state = AuthStateError(_friendlyAuthError(e.message));
    } catch (_) {
      state = const AuthStateError(
        'No se pudo crear el usuario. Intenta de nuevo.',
      );
=======
      state = const AuthStateError('No se pudo crear el usuario.');
    } catch (e) {
      state = const AuthStateError('No se pudo crear el usuario.');
>>>>>>> 66286d4 (feat: enhance error handling and UI feedback across inventory and shop modules)
    }
  }
}
