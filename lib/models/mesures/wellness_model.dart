class WellnessModel {
  final String joueurId;
  final DateTime date;
  final int sommeil;
  final int humeur;
  final int energie;
  final int courbatures;
  final int stress;
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
      sommeil: map['sommeil'] as int,
      humeur: map['humeur'] as int,
      energie: map['energie'] as int,
      courbatures: map['courbatures'] as int,
      stress: map['stress'] as int,
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
