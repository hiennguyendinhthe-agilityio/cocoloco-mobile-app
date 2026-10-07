enum AppRole { guest, user, admin }

class UserProfile {
  final String id;
  final String clerkId;
  final String email;
  final String fullName;
  final String role; // 'ADMIN' or 'USER'
  final String? avatarUrl;
  final bool isActive;

  const UserProfile({
    required this.id,
    required this.clerkId,
    required this.email,
    required this.fullName,
    required this.role,
    this.avatarUrl,
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
      avatarUrl: (json['avatar_url'] ?? json['avatarUrl']) as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'clerk_id': clerkId,
    'email': email,
    'full_name': fullName,
    'role': role,
    'avatar_url': avatarUrl,
    'is_active': isActive,
  };

  UserProfile copyWith({
    String? id,
    String? clerkId,
    String? email,
    String? fullName,
    String? role,
    String? avatarUrl,
    bool? isActive,
  }) {
    return UserProfile(
      id: id ?? this.id,
      clerkId: clerkId ?? this.clerkId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
    );
  }
}

