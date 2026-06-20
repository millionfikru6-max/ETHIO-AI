import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await credential.user!.updateDisplayName(fullName);
        
        await _db.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'photoUrl': '',
          'phoneNumber': '',
        });
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception("An unexpected error occurred during sign up.");
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception("An unexpected error occurred during sign in.");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Error signing out.");
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception("Error sending password reset email.");
    }
  }

  Future<void> updateDisplayName(String name) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(name);
        await _db.collection('users').doc(user.uid).update({
          'fullName': name,
        });
      }
    } catch (e) {
      throw Exception("Error updating display name.");
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _db.collection('users').doc(user.uid).delete();
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception("Error deleting account.");
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided for that user.');
      case 'invalid-email':
        return Exception('The email address is not valid.');
      case 'user-disabled':
        return Exception('This user has been disabled.');
      case 'too-many-requests':
        return Exception('Too many requests. Try again later.');
      case 'operation-not-allowed':
        return Exception('Operation not allowed.');
      default:
        return Exception(e.message ?? 'Authentication failed.');
    }
  }
}