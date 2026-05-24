import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/rpe_model.dart';

class RpeService {
  Future<void> saveToday(RpeModel model) async {
    await supabase
        .from('rpe')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  Future<RpeModel?> getTodayRpe(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return RpeModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      rpem: data['rpem'] as int,
      rpec: data['rpec'] as int,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<List<RpeModel>> getRpeHistory(String joueurId) async {
    final data = await supabase
        .from('rpe')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => RpeModel.fromMap(e)).toList();
  }

  Future<List<RpeModel>> getTodayRpeAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => RpeModel.fromMap(e)).toList();
  }

  Future<Map<String, double>> getTodayRpeAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select('rpem, rpec')
        .eq('date', today);

    if ((data as List).isEmpty) {
      return {'rpem': 0, 'rpec': 0};
    }

    final count = data.length;

    final totals = data.fold<Map<String, int>>(
      {'rpem': 0, 'rpec': 0},
      (acc, e) => {
        'rpem': acc['rpem']! + (e['rpem'] as int),
        'rpec': acc['rpec']! + (e['rpec'] as int),
      },
    );

    return {'rpem': totals['rpem']! / count, 'rpec': totals['rpec']! / count};
  }

  Future<int> getTodayRpeTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('rpe')
        .select('rpem, rpec')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<int>(
      0,
      (sum, e) => sum + (e['rpem'] as int) + (e['rpec'] as int),
    );

    return total;
  }
}
