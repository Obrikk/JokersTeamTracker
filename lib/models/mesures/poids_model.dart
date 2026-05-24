class PoidsModel {
  final String joueurId;
  final DateTime date;
  final double poids;
  final String joueurNom;
  final String joueurPrenom;

  const PoidsModel({
    required this.joueurId,
    required this.date,
    required this.poids,
    required this.joueurNom,
    required this.joueurPrenom,
  });

  factory PoidsModel.fromMap(Map<String, dynamic> map) {
    return PoidsModel(
      joueurId: map['joueurId'] as String,
      date: DateTime.parse(map['date']),
      poids: map['poids'] as double,
      joueurNom: map['joueur_nom'] as String,
      joueurPrenom: map['joueur_prenom'] as String,
    );
  }
  Map<String, dynamic> toMap() => {
    'joueur_id': joueurId,
    'date': date.toIso8601String().split('T').first,
    'poids': poids,
    'joueur_nom': joueurNom,
    'joueur_prenom': joueurPrenom,
  };
}
