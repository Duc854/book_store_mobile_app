class RegisterDto {
  String username;
  String password;
  String fullName;

  RegisterDto({this.username = '', this.password = '', this.fullName = ''});

  factory RegisterDto.fromJson(Map<String, dynamic> json) {
    return RegisterDto(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'fullName': fullName};
  }
}
