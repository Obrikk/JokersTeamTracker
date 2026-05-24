class GripModel {
  final String joueurId;
  final DateTime date;
  final double grip;
  final String joueurNom;
  final String joueurPrenom;

  const GripModel({
    required this.joueurId,
    required this.date,
    required this.grip,
    required this.joueurNom,
    required this.joueurPrenom,
  });

  factory GripModel.fromMap(Map<String, dynamic> map) {
    return GripModel(
      joueurId: map['joueurId'] as String,
      date: DateTime.parse(map['date']),
      grip: map['grip'] as double,
      joueurNom: map['joueur_nom'] as String,
      joueurPrenom: map['joueur_prenom'] as String,
    );
  }
  Map<String, dynamic> toMap() => {
    'joueur_id': joueurId,
    'date': date.toIso8601String().split('T').first,
    'grip': grip,
    'joueur_nom': joueurNom,
    'joueur_prenom': joueurPrenom,
  };
}
