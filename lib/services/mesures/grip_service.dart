import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/grip_model.dart';

class GripService {
  Future<void> saveToday(GripModel model) async {
    await supabase
        .from('grip')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  Future<GripModel?> getTodayGrip(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return GripModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      grip: data['grip'] as double,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<List<GripModel>> getGripHistory(String joueurId) async {
    final data = await supabase
        .from('grip')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => GripModel.fromMap(e)).toList();
  }

  Future<List<GripModel>> getTodayGripAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => GripModel.fromMap(e)).toList();
  }

  Future<Map<String, double>> getTodayGripAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase.from('grip').select('grip').eq('date', today);

    if ((data as List).isEmpty) {
      return {'grip': 0};
    }

    final count = data.length;

    final totals = data.fold<Map<String, double>>({
      'grip': 0,
    }, (acc, e) => {'grip': acc['grip']! + (e['grip'] as double)});

    return {'grip': totals['grip']! / count};
  }

  Future<double> getTodayGripTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('grip')
        .select('grip')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<double>(0, (sum, e) => sum + (e['grip'] as double));

    return total;
  }
}
