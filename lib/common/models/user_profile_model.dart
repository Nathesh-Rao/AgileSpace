class UserProfileModel {
  final String? nickname;
  final String? username;
  final String? gender;
  final String? role;
  final String? worktype;
  final String? location;

  UserProfileModel({
    this.nickname,
    this.username,
    this.gender,
    this.role,
    this.worktype,
    this.location,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      nickname: json['nickname'],
      username: json['username'],
      gender: json['gender'],
      role: json['role'],
      worktype: json['worktype'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'username': username,
      'gender': gender,
      'role': role,
      'worktype': worktype,
      'location': location,
    };
  }
}
