enum AppRole { guest, user, admin }

class UserProfile {
  final String id;
  final String clerkId;
  final String email;
  final String fullName;
  final String role; // 'ADMIN' or 'USER'
  final bool isActive;

  const UserProfile({
    required this.id,
    required this.clerkId,
    required this.email,
    required this.fullName,
    required this.role,
    this.isActive = true,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? '',
      clerkId: json['clerk_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Cocoloco Member',
      role: (json['role'] as String? ?? 'USER').toUpperCase(),
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
