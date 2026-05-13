import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudySessionService {
  static Future<void> saveStudySession({
    required int minutesStudied,
    required String ambience,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('studySessions')
        .add({
      'minutesStudied': minutesStudied,
      'ambience': ambience,
      'completedAt': Timestamp.now(),
    });
  }
}