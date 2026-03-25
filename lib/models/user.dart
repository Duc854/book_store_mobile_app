class UserModel {
  final int id;
  final String username;
  final String fullName;
  final String role;
  final String? phoneNumber;
  final String? address;
  final DateTime? birthDate;
  final String? gender;
  final String? avatarUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    this.address,
    this.birthDate,
    this.gender,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 'Customer',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      gender: json['gender'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "address": address,
      "birthDate": birthDate?.toIso8601String(),
      "gender": gender,
      "avatarUrl": avatarUrl,
    };
  }
}
