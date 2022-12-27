class User {
  int id;
  String login;
  String fullName;
  int avatarImageId;
  String phone;
  String email;
  String jobTitle;
  bool isFavorite;
  String role;

  User(this.id, this.login, this.fullName, this.jobTitle, this.avatarImageId,
      this.phone, this.email, this.role, this.isFavorite);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json["id"] as int,
      json["login"] as String,
      json["fullName"] as String,
      json["jobTitle"] as String,
      json["imageId"] as int,
      json["phone"] as String,
      json["email"] as String,
      json["role"] as String,
      json["favorite"] as bool,
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "login": login,
      "fullName": fullName,
      "avatar": avatarImageId,
      "phone": phone,
      "email": email,
      "role": role,
    };
  }
}
