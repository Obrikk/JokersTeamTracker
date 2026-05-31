import '../../core/constants/supabase_constants.dart';
import '../../models/mesures/statistiques_model.dart';

class StatsService {
  //
  // Enregistrement
  //
  Future<void> saveToday(StatsModel model) async {
    await supabase
        .from('statistiques')
        .upsert(model.toMap(), onConflict: 'joueur_id, date');
  }

  //
  // Lecture
  //

  Future<List<StatsModel>> getPlayerStats(String joueurId) async {
    final data = await supabase
        .from('statistiques')
        .select()
        .eq('joueur_id', joueurId);

    return (data as List).map((e) => StatsModel.fromMap(e)).toList();
  }

  Future<StatsModel?> getPlayerRecentStats(String joueurId) async {
    final data = await supabase
        .from('statistiques')
        .select()
        .eq('joueur_id', joueurId)
        .order('date', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return null;

    return StatsModel(
      id: data['id_statistiques'] as String,
      date: DateTime.parse(data['date'] as String),
      bench: data['bench'] as int,
      squat: data['squat'] as int,
      deadlift: data['deadlift'] as int,
      clean: data['clean'] as int,
      pullup: data['pullup'] as int,
      broadjump: (data['broadjump'] as num).toDouble(),
      cmj: (data['cmj'] as num).toDouble(),
      sprint5m: (data['sprint5m'] as num).toDouble(),
      sprint10m: (data['sprint10m'] as num).toDouble(),
      sprint20m: (data['sprint20m'] as num).toDouble(),
      joueurId: data['joueur_id'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
