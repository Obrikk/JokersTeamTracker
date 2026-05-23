import 'package:jokers_team_tracker/models/user/profiles_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';

class AuthService {
  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  // Récupère le profil de l'utilisateur connecté par son id
  Future<UserProfile?> fetchCurrentProfile() async {
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) return null;

    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', uid)
        .single();

    return UserProfile.fromMap(data);
  }
}
