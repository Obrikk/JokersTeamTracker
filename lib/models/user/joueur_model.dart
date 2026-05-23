class JoueurModel {
  final String id;
  final String userId;
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final double? tailleCm;
  final double? poidsKg;
  final DateTime dateArrivee;

  const JoueurModel({
    required this.id,
    required this.userId,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    this.tailleCm,
    this.poidsKg,
    required this.dateArrivee,
  });

  factory JoueurModel.fromMap(Map<String, dynamic> map) {
    return JoueurModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      dateNaissance: DateTime.parse(map['date_naissance']),
      dateArrivee: DateTime.parse(map['date_arrivee']),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'nom': nom,
    'prenom': prenom,
    'date_naissance': dateNaissance,
    'date_arrivee': dateArrivee,
  };
}
