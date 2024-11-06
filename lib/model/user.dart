class User {
  int id;
  String name;
  String lastName;
  String email;
  String password;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.email,
      required this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
    );
  }
}
