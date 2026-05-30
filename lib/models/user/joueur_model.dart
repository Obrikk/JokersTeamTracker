class JoueurModel {
  final String id;
  final String nom;
  final String prenom;
  final DateTime dateNaissance;
  final String poste;
  final int numero;
  final int? tailleCm;
  final double? poidsKg;
  final DateTime dateArrivee;
  final String userId;

  const JoueurModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.poste,
    required this.numero,
    this.tailleCm,
    this.poidsKg,
    required this.dateArrivee,
    required this.userId,
  });

  factory JoueurModel.fromMap(Map<String, dynamic> map) {
    return JoueurModel(
      id: map['id_joueur'] as String,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      dateNaissance: DateTime.parse(map['date_naissance']),
      poste: map['poste'] as String,
      numero: map['numero'] as int,
      tailleCm: map['taille_cm'] as int?,
      poidsKg: map['poids_kg'] as double?,
      dateArrivee: DateTime.parse(map['date_arrivee']),
      userId: map['user_id'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'id_joueur': id,
    'nom': nom,
    'prenom': prenom,
    'date_naissance': dateNaissance,
    'poste': poste,
    'numero': numero,
    'taille_cm': tailleCm,
    'poids_kg': poidsKg,
    'date_arrivee': dateArrivee,
    'user_id': userId,
  };
}
