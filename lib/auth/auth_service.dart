import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      final userCredential = await _auth.signInWithCredential(cred);

      // Create or update user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'registrationDate': FieldValue.serverTimestamp(),
        'totalUsageTime': 0,
        'lastActiveDate': FieldValue.serverTimestamp(),
        'sessionCount': 0,
        'totalQuizzesTaken': 0,
        'totalCorrectAnswers': 0,
        'totalQuizQuestions': 0,
      }, SetOptions(merge: true));

      return userCredential;
    } catch (e) {
      return Future.error("Failed to sign in with Google: ${e.toString()}");
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Set the display name
      await cred.user?.updateDisplayName(name);

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'email': email,
        'name': name,
        'registrationDate': FieldValue.serverTimestamp(),
        'totalUsageTime': 0,
        'lastActiveDate': FieldValue.serverTimestamp(),
        'sessionCount': 0,
        'totalQuizzesTaken': 0,
        'totalCorrectAnswers': 0,
        'totalQuizQuestions': 0,
      });

      return cred.user;
    } on FirebaseAuthException catch (e) {
      return Future.error(exceptionHandler(e.code));
    } catch (e) {
      return Future.error("An unexpected error occurred");
    }
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      return Future.error(exceptionHandler(e.code));
    } catch (e) {
      return Future.error("An unexpected error occurred");
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return Future.error("Failed to sign out");
    }
  }
}

String exceptionHandler(String code) {
  switch (code) {
    case "invalid-credential":
      return "Your login credentials are invalid";
    case "weak-password":
      return "Your password must be at least 8 characters";
    case "email-already-in-use":
      return "User already exists";
    case "invalid-email":
      return "Invalid email format";
    case "user-disabled":
      return "This user has been disabled";
    case "user-not-found":
      return "No user found for that email";
    case "wrong-password":
      return "Wrong password provided";
    default:
      return "An unexpected error occurred";
  }
}
