class ProfileModel {
  final String id;
  final String? email;
  final String? fullName;
  final String role; // admin | cliente
  final DateTime? createdAt;

  const ProfileModel({
    required this.id,
    this.email,
    this.fullName,
    required this.role,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        email: json['email'] as String?,
        fullName: json['full_name'] as String?,
        role: (json['role'] as String?) ?? 'cliente',
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'full_name': fullName,
        'role': role,
      };
}
