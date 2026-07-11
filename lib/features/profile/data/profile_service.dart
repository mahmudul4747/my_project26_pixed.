import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/user_profile_model.dart';

class ProfileService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  /// Create User Profile
  Future<void> createProfile({
    required String name,
    required String email,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    final doc =
        _firestore.collection('users').doc(user.uid);

    final exists = await doc.get();

    if (exists.exists) return;

    final profile = UserProfileModel(
      uid: user.uid,
      name: name,
      email: email,
      phone: '',
      address: '',
      photoUrl: '',
      createdAt: DateTime.now(),
    );

    await doc.set(profile.toMap());
  }

  /// Live User Profile
  Stream<UserProfileModel> getProfile() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception("Profile not found");
      }

      return UserProfileModel.fromFirestore(doc);
    });
  }

  /// Update Profile
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String address,
    String? photoUrl,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'name': name,
      'phone': phone,
      'address': address,
      'photoUrl': photoUrl ?? '',
    });
  }

  /// Update Only Photo
  Future<void> updatePhoto(
    String photoUrl,
  ) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
      'photoUrl': photoUrl,
    });
  }

  /// Delete Profile (Optional)
  Future<void> deleteProfile() async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .delete();
  }
}