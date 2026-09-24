enum UserRole { admin, user }

class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final UserRole role;
  final bool isActive;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    this.role = UserRole.user,
    this.isActive = true,
  });

  bool get isAdmin => role == UserRole.admin;
}
