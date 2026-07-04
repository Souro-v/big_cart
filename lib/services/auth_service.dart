import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Referral code generate
  String _generateReferralCode(String uid) {
    return 'BIGCART${uid.substring(0, 6).toUpperCase()}';
  }

  // Register
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = UserModel(
      uid: cred.user!.uid,
      name: name,
      email: email,
      phone: phone,
      referralCode: _generateReferralCode(cred.user!.uid),
    );

    await _db.collection(AppConstants.usersCol).doc(user.uid).set(user.toMap());

    return user;
  }

  // Login
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final doc =
        await _db.collection(AppConstants.usersCol).doc(cred.user!.uid).get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get user data
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection(AppConstants.usersCol).doc(uid).get();

    if (doc.exists) return UserModel.fromMap(doc.data()!);
    return null;
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
    await _db
        .collection(AppConstants.usersCol)
        .doc(user.uid)
        .update(user.toMap());
  }

  Future<void> deleteAccount() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Firestore data delete
    await _db.collection(AppConstants.usersCol).doc(uid).delete();

    // Firebase Auth account delete
    await _auth.currentUser?.delete();
  }
}
