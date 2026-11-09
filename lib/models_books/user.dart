class User {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'password': passwordHash,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        id: map['id'] as int?,
        name: map['name'] as String,
        email: map['email'] as String,
        passwordHash: map['password'] as String,
      );
}