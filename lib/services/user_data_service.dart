import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserActivity() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'lastActiveDate': FieldValue.serverTimestamp(),
        'sessionCount': FieldValue.increment(1),
      });
    }
  }

  Future<void> updateTotalUsageTime(int seconds) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'totalUsageTime': FieldValue.increment(seconds),
      });
    }
  }

  Future<void> saveQuizResult(
      String quizName, int score, int totalQuestions) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('quizResults')
          .add({
        'quizName': quizName,
        'score': score,
        'totalQuestions': totalQuestions,
        'date': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('users').doc(user.uid).update({
        'totalQuizzesTaken': FieldValue.increment(1),
        'totalCorrectAnswers': FieldValue.increment(score),
        'totalQuizQuestions': FieldValue.increment(totalQuestions),
      });
    }
  }

  Future<Map<String, dynamic>> getUserStats() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return {
        'totalQuizzesTaken': doc['totalQuizzesTaken'] ?? 0,
        'totalCorrectAnswers': doc['totalCorrectAnswers'] ?? 0,
        'totalQuizQuestions': doc['totalQuizQuestions'] ?? 0,
      };
    }
    return {};
  }

  Future<void> createUserProfile(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': user.displayName,
      'registrationDate': FieldValue.serverTimestamp(),
      'totalQuizzesTaken': 0,
      'totalCorrectAnswers': 0,
      'totalQuizQuestions': 0,
      'totalUsageTime': 0,
      'sessionCount': 0,
    }, SetOptions(merge: true));
  }

  Future<void> updateProfileImage(String imageUrl) async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.updatePhotoURL(imageUrl);
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': imageUrl,
      });
    }
  }

  Future<void> completeModule(String moduleName) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('completedModules')
          .add({
        'moduleName': moduleName,
        'completionDate': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getCompletedModules() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('completedModules')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    }
    return [];
  }

  Future<bool> isModuleCompleted(String moduleName) async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('completedModules')
          .where('moduleName', isEqualTo: moduleName)
          .get();
      return snapshot.docs.isNotEmpty;
    }
    return false;
  }

  Future<void> checkAndCompleteModule(
      String moduleName, int score, int totalQuestions) async {
    final user = _auth.currentUser;
    if (user != null) {
      bool isCompleted = await isModuleCompleted(moduleName);
      if (!isCompleted && score >= (totalQuestions * 0.8).round()) {
        await completeModule(moduleName);
      }
    }
  }
}
