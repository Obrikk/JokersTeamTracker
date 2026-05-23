class WellnessModel {
  final String id;
  final String joueurId;
  final DateTime date;
  final int sommeil;
  final int humeur;
  final int energie;
  final int courbatures;
  final int stress;

  const WellnessModel({
    required this.id,
    required this.joueurId,
    required this.date,
    required this.sommeil,
    required this.humeur,
    required this.energie,
    required this.courbatures,
    required this.stress,
  });

  factory WellnessModel.fromMap(Map<String, dynamic> map) {
    return WellnessModel(
      id: map['id'] as String,
      joueurId: map['joueur_id'] as String,
      date: DateTime.parse(map['date']),
      sommeil: map['sommeil'] as int,
      humeur: map['humeur'] as int,
      energie: map['energie'] as int,
      courbatures: map['courbatures'] as int,
      stress: map['stress'] as int,
    );
  }
  Map<String, dynamic> toMap() => {
    'id': id,
    'joueur_id': joueurId,
    'date': date,
    'sommeil': sommeil,
    'humeur': humeur,
    'energie': energie,
    'courbatures': courbatures,
    'stress': stress,
  };
}
