class StatsModel {
  final String id;
  final DateTime date;
  final int bench;
  final int squat;
  final int deadlift;
  final int clean;
  final int pullup;
  final double broadjump;
  final double cmj;
  final double sprint5m;
  final double sprint10m;
  final double sprint20m;
  final String joueurId;
  final DateTime createdAt;

  const StatsModel({
    required this.id,
    required this.date,
    required this.bench,
    required this.squat,
    required this.deadlift,
    required this.clean,
    required this.pullup,
    required this.broadjump,
    required this.cmj,
    required this.sprint5m,
    required this.sprint10m,
    required this.sprint20m,
    required this.joueurId,
    required this.createdAt,
  });

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      id: map['id_statistiques'] as String,
      date: DateTime.parse(map['date'] as String),
      bench: map['bench'] as int,
      squat: map['squat'] as int,
      deadlift: map['deadlift'] as int,
      clean: map['clean'] as int,
      pullup: map['pullup'] as int,
      broadjump: (map['broadjump'] as num).toDouble(),
      cmj: (map['cmj'] as num).toDouble(),
      sprint5m: (map['sprint5m'] as num).toDouble(),
      sprint10m: (map['sprint10m'] as num).toDouble(),
      sprint20m: (map['sprint20m'] as num).toDouble(),
      joueurId: map['joueur_id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String().split('T').first,
    'bench': bench,
    'squat': squat,
    'deadlift': deadlift,
    'clean': clean,
    'pullup': pullup,
    'broadjump': broadjump,
    'cmj': cmj,
    'sprint5m': sprint5m,
    'sprint10m': sprint10m,
    'sprint20m': sprint20m,
    'joueur_id': joueurId,
    'created_at': createdAt.toIso8601String(),
  };
}
