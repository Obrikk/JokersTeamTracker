import '../../core/utils/role_helper.dart';

class UserProfile {
  final String id;
  final String nom;
  final String prenom;
  final DateTime? dateNaissance;
  final UserRole role;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.nom,
    required this.prenom,
    this.dateNaissance,
    required this.role,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      dateNaissance: map['date_naissance'] != null
          ? DateTime.parse(map['date_naissance'])
          : null,
      role: UserRoleExtension.fromString(map['role'] as String),
      createdAt: DateTime.parse(map['created_at']),
    );
  }
  Map<String, dynamic> toMap() => {
    'nom': nom,
    'prenom': prenom,
    'date_naissance': dateNaissance?.toIso8601String().split('T').first,
    'role': role.name,
  };
}
