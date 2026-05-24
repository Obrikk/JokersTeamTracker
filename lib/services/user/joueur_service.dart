import '../../core/constants/supabase_constants.dart';

class JoueurService {
  Future<String> getPlayerId(String userId) async {
    final data = await supabase
        .from('joueur')
        .select('id_joueur')
        .eq('user_id', userId)
        .maybeSingle();

    if (data == null) {
      throw Exception(
        'Joueur introuvable — userId envoyé: $userId — réponse: $data',
      );
    }

    return data['id_joueur'] as String;
  }

  Future<String> getPlayerNom(String userId) async {
    final data = await supabase
        .from('joueur')
        .select('nom')
        .eq('user_id', userId)
        .maybeSingle();

    if (data == null) {
      throw Exception(
        'Joueur introuvable — userId envoyé: $userId — réponse: $data',
      );
    }

    return data['nom'] as String;
  }

  Future<String> getPlayerPrenom(String userId) async {
    final data = await supabase
        .from('joueur')
        .select('prenom')
        .eq('user_id', userId)
        .maybeSingle();

    if (data == null) {
      throw Exception(
        'Joueur introuvable — userId envoyé: $userId — réponse: $data',
      );
    }

    return data['prenom'] as String;
  }
}
