import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/wellness_model.dart';

class WellnessService {
  //
  // Enregistrement
  //

  Future<void> saveToday(WellnessModel model) async {
    await supabase
        .from('wellness')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  //
  // Lecture
  //
  Future<WellnessModel?> getTodayWellness(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('wellness')
        .select()
        .eq('joueur_id', joueurId)
        .eq('date', today)
        .maybeSingle();
    if (data == null) return null;

    return WellnessModel(
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      sommeil: data['sommeil'] as double,
      humeur: data['humeur'] as double,
      energie: data['energie'] as double,
      courbatures: data['courbatures'] as double,
      stress: data['stress'] as double,
      joueurNom: data['joueur_nom'] as String,
      joueurPrenom: data['joueur_prenom'] as String,
    );
  }

  Future<List<WellnessModel>> getWellnessHistory(String joueurId) async {
    final data = await supabase
        .from('wellness')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: true);

    return (data as List).map((e) => WellnessModel.fromMap(e)).toList();
  }

  Future<List<WellnessModel>> getWellnessTodayHistory(DateTime date) async {
    final data = await supabase
        .from('wellness')
        .select()
        .eq('date', date)
        .order('joueur_id', ascending: true);

    return (data as List).map((e) => WellnessModel.fromMap(e)).toList();
  }

  Future<List<WellnessModel>> getTodayWellnessAllPlayers() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('wellness')
        .select()
        .eq('date', today)
        .order('joueur_nom', ascending: true);

    return (data as List).map((e) => WellnessModel.fromMap(e)).toList();
  }

  Future<List<WellnessModel>> getTeamWellnessRange({
    required String dateStart,
    required String dateEnd,
  }) async {
    final data = await supabase
        .from('wellness')
        .select()
        .gte('date', dateStart)
        .lte('date', dateEnd)
        .order('date', ascending: true);

    return (data as List).map((row) {
      return WellnessModel.fromMap({
        'joueur_id': row['joueur_id'],
        'joueur_nom': row['joueur_nom'],
        'joueur_prenom': row['joueur_prenom'],
        'date': row['date'],
        'sommeil': row['sommeil'],
        'humeur': row['humeur'],
        'energie': row['energie'],
        'courbatures': row['courbatures'],
        'stress': row['stress'],
      });
    }).toList();
  }

  //
  // Calculs
  //

  /// Retourne la moyenne du score_total de l'équipe par jour sur les N derniers jours.
  Future<List<Map<String, dynamic>>> getTeamWellnessRangeAverage({
    int days = 30,
  }) async {
    final startStr = DateTime.now()
        .subtract(Duration(days: days))
        .toIso8601String()
        .substring(0, 10);

    final response = await supabase
        .from('wellness')
        .select('date, sommeil, humeur, energie, courbatures, stress')
        .gte('date', startStr)
        .order('date', ascending: true);

    // Agrégation par date côté Dart
    final Map<String, List<double>> scoresByDate = {};

    for (final row in response as List) {
      final date = row['date'] as String;
      final score = _computeScore(row);
      scoresByDate.putIfAbsent(date, () => []).add(score);
    }

    return scoresByDate.entries.map((entry) {
      final scores = entry.value;
      final avg = scores.reduce((a, b) => a + b) / scores.length;
      return {
        'date': entry.key,
        'score_total': double.parse(avg.toStringAsFixed(2)),
      };
    }).toList();
  }

  /// À adapter selon ta formule de calcul du score_total
  double _computeScore(Map<String, dynamic> row) {
    final sommeil = (row['sommeil'] as num).toDouble();
    final humeur = (row['humeur'] as num).toDouble();
    final energie = (row['energie'] as num).toDouble();
    final courbatures = (row['courbatures'] as num).toDouble();
    final stress = (row['stress'] as num).toDouble();

    return (sommeil + humeur + energie + courbatures + stress) / 5;
  }

  Future<Map<String, double>> getTodayWellnessAverages() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('wellness')
        .select('sommeil, humeur, energie, courbatures, stress')
        .eq('date', today);

    if ((data as List).isEmpty) {
      return {
        'sommeil': 0,
        'humeur': 0,
        'energie': 0,
        'courbatures': 0,
        'stress': 0,
      };
    }

    final count = data.length;

    final totals = data.fold<Map<String, double>>(
      {'sommeil': 0, 'humeur': 0, 'energie': 0, 'courbatures': 0, 'stress': 0},
      (acc, e) => {
        'sommeil': acc['sommeil']! + (e['sommeil'] as double),
        'humeur': acc['humeur']! + (e['humeur'] as double),
        'energie': acc['energie']! + (e['energie'] as double),
        'courbatures': acc['courbatures']! + (e['courbatures'] as double),
        'stress': acc['stress']! + (e['stress'] as double),
      },
    );

    return {
      'sommeil': totals['sommeil']! / count,
      'humeur': totals['humeur']! / count,
      'energie': totals['energie']! / count,
      'courbatures': totals['courbatures']! / count,
      'stress': totals['stress']! / count,
    };
  }

  Future<double> getTodayWellnessTotal(String joueurId) async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final data = await supabase
        .from('wellness')
        .select('sommeil, humeur, energie, courbatures, stress')
        .eq('joueur_id', joueurId)
        .eq('date', today);

    if ((data as List).isEmpty) return 0;

    final total = data.fold<double>(
      0,
      (sum, e) =>
          sum +
          (e['sommeil'] as double) +
          (e['humeur'] as double) +
          (e['energie'] as double) +
          (e['courbatures'] as double) +
          (e['stress'] as double),
    );

    return total;
  }
}
