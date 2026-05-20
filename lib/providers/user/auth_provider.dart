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
    print('LOGIN APPELÉ — email: $email'); // ← ici
    state = state.copyWith(isLoading: true);

    try {
      print('AVANT SUPABASE'); // ← ici
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password.trim(),
      );
      print('APRÈS SUPABASE — user: ${response.user?.id}'); // ← ici

      final user = response.user;
      if (user == null) return "T'es qui ?";

      print('RECHERCHE PROFIL pour id: ${user.id}');

      final profile = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();
      print('PROFIL TROUVÉ : $profile');

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
