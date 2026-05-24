import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/poids_model.dart';

class PoidsService {
  Future<void> saveToday(PoidsModel model) async {
    await supabase
        .from('poids')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  Future<PoidsModel?> getTodayPoids(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return PoidsModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      poids: data['poids'] as double,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<List<PoidsModel>> getPoidsHistory(String joueurId) async {
    final data = await supabase
        .from('poids')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => PoidsModel.fromMap(e)).toList();
  }

  Future<List<PoidsModel>> getTodayPoidsAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => PoidsModel.fromMap(e)).toList();
  }

  Future<Map<String, double>> getTodayPoidsAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase.from('poids').select('poids').eq('date', today);

    if ((data as List).isEmpty) {
      return {'poids': 0};
    }

    final count = data.length;

    final totals = data.fold<Map<String, double>>({
      'poids': 0,
    }, (acc, e) => {'poids': acc['poids']! + (e['poids'] as double)});

    return {'poids': totals['poids']! / count};
  }

  Future<double> getTodayPoidsTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('poids')
        .select('poids')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<double>(
      0,
      (sum, e) => sum + (e['poids'] as double),
    );

    return total;
  }
}
