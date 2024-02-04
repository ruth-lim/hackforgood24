class UserModel {
  String email;
  String username;
  bool onboardingCompleted;

  UserModel({
    required this.email,
    required this.username,
    this.onboardingCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'onboardingCompleted': onboardingCompleted,
    };
  }
}
