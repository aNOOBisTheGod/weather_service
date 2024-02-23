import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthExceptionWithMessage implements Exception {
  String message;
  FirebaseAuthExceptionWithMessage(this.message);
}

class AuthorizationManager {
  FirebaseAuth auth = FirebaseAuth.instance;

  bool checkAuth() {
    return auth.currentUser != null;
  }

  Future<bool> authenticate(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw FirebaseAuthExceptionWithMessage("Некорректный email!");
      }
      if (e.code == 'wrong-password') {
        throw FirebaseAuthExceptionWithMessage("Некорректный пароль!");
      }
      if (e.code == 'too-many-requests') {
        throw FirebaseAuthExceptionWithMessage(
            "Слишком много запросов, повторите попытку позже!");
      }
      return false;
    }
    return true;
  }

  Future<bool> createNewUser(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-email') {
        throw FirebaseAuthExceptionWithMessage("Некорректный email!");
      }
      if (e.code == 'wrong-password') {
        throw FirebaseAuthExceptionWithMessage("Некорректный пароль!");
      }
      if (e.code == 'invalid-credential' || e.code == 'email-already-in-use') {
        throw FirebaseAuthExceptionWithMessage(
            "Пользователь с такой почтой уже существует!");
      }
      return false;
    }
    return true;
  }
}
