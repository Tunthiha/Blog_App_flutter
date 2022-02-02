class User {
  int? id;
  String? name;
  String? image;
  String? email;
  String? token;

  User({
    this.id,
    this.email,
    this.name,
    this.image,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      email: json['user']['email'],
      name: json['user']['name'],
      image: json['user']['image'],
      token: json['token'],
    );
  }
  @override
  toString() => 'User: $id' 'token:$token';
}
