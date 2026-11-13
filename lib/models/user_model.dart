class UserModel {
  final String id;
  final String fullName;
  final String academicId;
  final String email;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    required this.email,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? academicId,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      academicId: academicId ?? this.academicId,
      email: email ?? this.email,
    );
  }
}