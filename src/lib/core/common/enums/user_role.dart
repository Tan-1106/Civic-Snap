enum UserRole {
  admin('admin'),
  user('user')
  ;

  final String value;

  const UserRole(this.value);

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value.toLowerCase() == value.toLowerCase(),
      orElse: () => UserRole.user,
    );
  }

  String get initialRoute {
    switch (this) {
      case UserRole.admin:
        return '/admin-dashboard';
      case UserRole.user:
        return '/user-map';
    }
  }
}
