import '../../core/constants/supabase_constants.dart';
import '../../models/user/joueur_model.dart';

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

  Future<JoueurModel?> getPlayer(String joueurId) async {
    final data = await supabase
        .from('joueur')
        .select()
        .eq('id_joueur', joueurId)
        .maybeSingle();

    if (data == null) return null;

    return JoueurModel(
      id: data['id_joueur'] as String,
      nom: data['nom'] as String,
      prenom: data['prenom'] as String,
      dateNaissance: DateTime.parse(data['date_naissance']),
      poste: data['poste'] as String,
      numero: data['numero'] as int,
      tailleCm: data['taille_cm'] as int?,
      poidsKg: data['poids_kg'] as double?,
      dateArrivee: DateTime.parse(data['date_arrivee']),
      userId: data['user_id'] as String,
    );
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

  Future<List<JoueurModel>> getAllPlayers() async {
    final data = await supabase
        .from('joueur')
        .select()
        .order('nom', ascending: true);

    return (data as List).map((e) => JoueurModel.fromMap(e)).toList();
  }
}
