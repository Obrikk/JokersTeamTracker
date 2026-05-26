class WellnessModel {
  final String joueurId;
  final DateTime date;
  final double sommeil;
  final double humeur;
  final double energie;
  final double courbatures;
  final double stress;
  final String joueurNom;
  final String joueurPrenom;

  const WellnessModel({
    required this.joueurId,
    required this.date,
    required this.sommeil,
    required this.humeur,
    required this.energie,
    required this.courbatures,
    required this.stress,
    required this.joueurNom,
    required this.joueurPrenom,
  });

  factory WellnessModel.fromMap(Map<String, dynamic> map) {
    return WellnessModel(
      joueurId: map['joueur_id'] as String,
      date: DateTime.parse(map['date']),
      sommeil: map['sommeil'] as double,
      humeur: map['humeur'] as double,
      energie: map['energie'] as double,
      courbatures: map['courbatures'] as double,
      stress: map['stress'] as double,
      joueurNom: map['joueur_nom'] as String,
      joueurPrenom: map['joueur_prenom'] as String,
    );
  }
  Map<String, dynamic> toMap() => {
    'joueur_id': joueurId,
    'date': date.toIso8601String().split('T').first,
    'sommeil': sommeil,
    'humeur': humeur,
    'energie': energie,
    'courbatures': courbatures,
    'stress': stress,
    'joueur_nom': joueurNom,
    'joueur_prenom': joueurPrenom,
  };
}
