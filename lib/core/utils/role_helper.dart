enum UserRole {admin, coach, prep, joueur, medical }

extension UserRoleExtension on UserRole {
  static UserRole fromString(String role) {
    switch (role) {
      case 'Coach':
        return UserRole.coach;
      case 'Prep_Physique':
        return UserRole.prep;
      case 'Admin':
        return UserRole.admin;
      case 'Joueur':
        return UserRole.joueur;
      case 'Medical':
        return UserRole.medical;
      default:
        return UserRole.joueur;
    }
  }
}
