import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/profiles_model.dart';
import '../../services/user/auth_service.dart';
import '../../core/constants/supabase_constants.dart';
import '../../core/utils/role_helper.dart';

// Authentification

class AuthState {
  final bool isLoading;
  final User? user;
  final UserProfile? profile;
  final UserRole? role;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.profile,
    this.role,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    User? user,
    UserRole? role,
    UserProfile? profile,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      role: role ?? this.role,
      profile: profile ?? this.profile,
    );
  }
}

// Notifier
// Permet de rafraichir les données lorsque l'utilisateur se connecte
// Travail avec NotifierListener

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  AuthNotifier(this._authService) : super(const AuthState(isLoading: true)) {
    _init();
  }

  void _init() {
    final session = supabase.auth.currentSession;
    if (session != null) {
      _loadProfile();
    } else {
      state = const AuthState();
    }
    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _loadProfile();
      } else if (data.event == AuthChangeEvent.signedOut) {
        state = const AuthState();
      }
    });
  }

  Future<void> _loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final user = supabase.auth.currentUser;
      print('User connecté : ${user?.email}');
      final profile = await _authService.fetchCurrentProfile();
      print('Profil chargé : ${profile?.role}');
      state = AuthState(user: user, profile: profile, role: profile?.role);
      print('State mis à jour : ${state.role}');
    } catch (e) {
      print('Erreur loadProfile : $e');
      state = const AuthState();
    }
  }

  // Connexion et récup du role
  Future<String?> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.login(email, password);
      return null;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false);
      return e.message;
    }
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    state = const AuthState();
  }
}

// Provider
// Ecoute les changements d'états
// Adapte l'UI en fonction des changements

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.watch(authServiceProvider)),
);
