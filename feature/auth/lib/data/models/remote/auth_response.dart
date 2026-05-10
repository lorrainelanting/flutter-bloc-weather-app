class AuthResponse {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AuthResponse({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}
