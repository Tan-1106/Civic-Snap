class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
  });

  @override
  String toString() {
    return 'UserEntity{id: $id, name: $name, email: $email, role: $role, profileImageUrl: $profileImageUrl}';
  }
}
