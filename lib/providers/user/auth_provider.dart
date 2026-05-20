import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Authentification

class AuthState {
  final bool isLoading;
  final User? user;
  final String? role;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.role,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    String? role,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      role: role ?? this.role,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Notifier
// Permet de rafraichir les données lorsque l'utilisateur se connecte
// Travail avec NotifierListener

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  final _supabase = Supabase.instance.client;

  // Connexion et récup du role
  Future<String?> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password.trim(),
      );

      final user = response.user;
      if (user == null) return "T'es qui ?";

      final profile = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();

      final role = profile['role'] as String;

      state = state.copyWith(isLoading: false, user: user, role: role);

      return null;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false);
      return e.message;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return 'Erreur, franchement pas cool';
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    state = const AuthState();
  }
}

// Provider
// Ecoute les changements d'états
// Adapte l'UI en fonction des changements

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
