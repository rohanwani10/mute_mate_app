import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String email;
  final String username;
  final String avatarUrl;
  final bool isVerified;

  UserProfile({
    required this.name,
    required this.email,
    required this.username,
    required this.avatarUrl,
    this.isVerified = true,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? username,
    String? avatarUrl,
    bool? isVerified,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier()
      : super(UserProfile(
          name: 'Alex Rivera',
          email: 'alex.rivera@example.com',
          username: '@alexrivera',
          avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBAuS3urnxYXYkUNxfhTt4PXoEU7hLU3aiEgPM2KghcgO6clgCNmGjhphYYgt7VRR-z_mXQNcwIp2YQwAEN_DrwlYT2eJfnkYiWjskfR12VeIFk8AlV9aowRcNlKmVSVemPtI-Qv1ks2OExa8xRKYZmp4S3fsew4hdwEwtIFS37DSX3rL-xPcZucB9UgzV2fTsUoX0ToOjRTiTQC9yqjOqOH6ONZ9bllgSuevn_Th4_QRMXSjZbLlbtdk47RP-ugrJRm9btOCCGUVge',
          isVerified: true,
        ));

  void updateProfile({String? name, String? email, String? username, String? avatarUrl}) {
    state = state.copyWith(
      name: name,
      email: email,
      username: username,
      avatarUrl: avatarUrl,
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});
