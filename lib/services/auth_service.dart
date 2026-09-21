/// Simple in-memory user model.
class AppUser {
  final String name;
  final String email;
  final String password;

  const AppUser({
    required this.name,
    required this.email,
    required this.password,
  });
}

/// Mock authentication service backed by an in-memory list.
/// Replace this with real API / database calls when ready.
class AuthService {
  AuthService._();

  static final List<AppUser> _users = [
    const AppUser(
      name: 'Juan Dela Cruz',
      email: 'juan@example.com',
      password: '123456',
    ),
  ];

  /// Looks up a user by email (case-insensitive). Returns null if not found.
  static AppUser? findByEmail(String email) {
    final trimmed = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email.toLowerCase() == trimmed) {
        return user;
      }
    }
    return null;
  }

  /// Registers a new user. Returns false if the email is already taken.
  static bool register({
    required String name,
    required String email,
    required String password,
  }) {
    if (findByEmail(email) != null) {
      return false;
    }
    _users.add(AppUser(name: name, email: email.trim(), password: password));
    return true;
  }
}
