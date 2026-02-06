class AuthToken {
  final String value;
  final DateTime expiry;

  const AuthToken({required this.value, required this.expiry});

  bool get isValid => DateTime.now().isBefore(expiry);
}
