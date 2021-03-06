import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotlighter1/model/note.dart';
import 'package:spotlighter1/model/task.dart';

class FirebaseService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  FirebaseService(this._auth, this._db);

  Stream<User?> get authState => _auth.authStateChanges();

  String get getUID => _auth.currentUser!.uid;

  String? get getEmail => _auth.currentUser!.email;

  String? get getName => _auth.currentUser!.displayName;


  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  // Future<void> signUp(
  //     {required String email,
  //     required String password,
  //     required String username}) async {
  //   try {
  //     await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((value) async {
  //       await _db
  //           .collection('userData')
  //           .doc(value.user!.uid)
  //           .set({'userName': username});
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     throw e;
  //   } on FirebaseException catch (e) {
  //     throw e;
  //   }
  // }
  Future<void> signUp(
      {required String email,
      required String password,
      required String username}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await value.user!.updateDisplayName(username);
      });
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> updateUserName(String name) async {
    try {
      await _auth.currentUser!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Stream<QuerySnapshot> get notestream => _db
      .collection('notes')
      .where('userID', isEqualTo: _auth.currentUser!.uid)
      .orderBy('created', descending: true)
      .snapshots();

  Stream<QuerySnapshot> get taskstream => _db
      .collection('tasks')
      .where('userID', isEqualTo: _auth.currentUser!.uid)
      .orderBy('created', descending: true)
      .snapshots();

  Future<void> createNote(Note note) async {
    try {
      await _db.collection('notes').add(note.toMap());
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> editNote(Note note, String? id) async {
    try {
      await _db.collection('notes').doc(id).update(note.toMap());
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> deleteNote(String? id) async {
    try {
      await _db.collection('notes').doc(id).delete();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> createTask(Task task) async {
    try {
      await _db.collection('tasks').add(task.toMap());
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> editTask(Task task, String? id) async {
    try {
      await _db.collection('tasks').doc(id).update(task.toMap());
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  Future<void> deleteTask(String? id) async {
    try {
      await _db.collection('tasks').doc(id).delete();
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  String showError(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-not-found':
        return 'User not found! Sign up to continue';
      case 'wrong-password':
        return 'Wrong password!';
      case 'user-disabled':
        return 'User disabled! Please contact support';
      case 'email-already-in-use':
        return 'Email address already exists!';
      case 'weak-password':
        return 'Password too waek!';
      default:
        return errorCode;
    }
  }
}
