class UserModel {
  String? fullName;
  int? age;
  DateTime? dateOfBirth;
  String? email;
  String? gender;

  String? imagePath;

  UserModel({
    this.fullName,
    this.age,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.imagePath,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'email': email,
      'gender': gender,
      'imagePath': imagePath,
      // Optional: Serialize enum as a string
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      age: json['age'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      email: json['email'],
      gender: json['gender'],
      imagePath: json['imagePath'],
    );
  }
}
