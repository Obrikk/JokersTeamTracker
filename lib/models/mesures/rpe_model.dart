class RpeModel {
  final String joueurId;
  final DateTime date;
  final int rpem;
  final int rpec;
  final String joueurNom;
  final String joueurPrenom;

  const RpeModel({
    required this.joueurId,
    required this.date,
    required this.rpec,
    required this.rpem,
    required this.joueurNom,
    required this.joueurPrenom,
  });

  factory RpeModel.fromMap(Map<String, dynamic> map) {
    return RpeModel(
      joueurId: map['joueur_id'] as String,
      date: DateTime.parse(map['date']),
      rpec: map['rpec'] as int,
      rpem: map['rpem'] as int,
      joueurNom: map['joueur_nom'] as String,
      joueurPrenom: map['joueur_prenom'] as String,
    );
  }
  Map<String, dynamic> toMap() => {
    'joueur_id': joueurId,
    'date': date.toIso8601String().split('T').first,
    'rpem': rpem,
    'rpec': rpec,
    'joueur_nom': joueurNom,
    'joueur_prenom': joueurPrenom,
  };
}
