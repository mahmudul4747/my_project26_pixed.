import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> login(String email, String password) async {
  try {
    UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(uid).get();

    if (!userDoc.exists) {
      return "user";
    }

    return userDoc['role'];
  } catch (e) {
    print(e);
    return null;
  }
}
  User? get currentUser => _auth.currentUser;
}