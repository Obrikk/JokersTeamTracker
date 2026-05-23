import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/wellness_model.dart';

class WellnessService {
  final today = DateTime.now().toIso8601String().split('T').first;

  Future<WellnessModel?> getTodayWellness(String playerId) async {
    final data = await supabase
        .from('wellness')
        .select()
        .eq('joueur_id', playerId)
        .eq('date', today)
        .maybeSingle();

    if (data == null) return null;

    return WellnessModel(
      id: data['id'] as String,
      joueurId: data['joueur_id'] as String,
      date: DateTime.parse(data['date'] as String),
      sommeil: data['sommeil'] as int,
      humeur: data['humeur'] as int,
      energie: data['energie'] as int,
      courbatures: data['courbatures'] as int,
      stress: data['stress'] as int,
    );
  }

  Future<List<WellnessModel>> getWellnessHistory(String playerId) async {
    final data = await supabase
        .from('wellness')
        .select()
        .eq('joueur_id', playerId)
        .order('date', ascending: true);

    return (data as List).map((e) => WellnessModel.fromMap(e)).toList();
  }

  Future<List<WellnessModel>> getTodayWellnessAllPlayers() async {
    final data = await supabase
        .from('wellness')
        .select()
        .eq('date', today)
        .order('nom', ascending: true);

    return (data as List).map((e) => WellnessModel.fromMap(e)).toList();
  }

  Future<Map<String, double>> getTodayWellnessAverages() async {
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

    final totals = data.fold<Map<String, int>>(
      {'sommeil': 0, 'humeur': 0, 'energie': 0, 'courbatures': 0, 'stress': 0},
      (acc, e) => {
        'sommeil': acc['sommeil']! + (e['sommeil'] as int),
        'humeur': acc['humeur']! + (e['humeur'] as int),
        'energie': acc['energie']! + (e['energie'] as int),
        'courbatures': acc['courbatures']! + (e['courbatures'] as int),
        'stress': acc['stress']! + (e['stress'] as int),
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
}
