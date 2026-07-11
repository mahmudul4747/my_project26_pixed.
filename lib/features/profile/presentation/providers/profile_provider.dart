import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_service.dart';
import '../../domain/user_profile_model.dart';

/// Service
final profileServiceProvider =
    Provider<ProfileService>((ref) {
  return ProfileService();
});

/// Current User Profile
final profileProvider =
    StreamProvider<UserProfileModel>((ref) {
  return ref
      .read(profileServiceProvider)
      .getProfile();
});

/// Update Profile
final updateProfileProvider =
    Provider<ProfileService>((ref) {
  return ref.read(profileServiceProvider);
});