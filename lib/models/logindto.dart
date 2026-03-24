class LoginDto {
  String username;
  String password;

  LoginDto({this.username = '', this.password = ''});

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
