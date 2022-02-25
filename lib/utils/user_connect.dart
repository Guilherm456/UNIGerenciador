import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConnect {
  //  final SharedPreferences prefs =  SharedPreferences.getInstance();

  void connect(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('idUser', user.uid);
  }

  void disconnect() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('idUser');
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<String?> connectUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        connect(user.user!);
      });
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não cadastrado';
        case 'wrong-password':
          return 'Senha incorreta';
        case 'invalid-email':
          return 'Email inválido';
        default:
          return e.code;
      }
    }
  }

  Future<String?> registerUser(
      String email, String password, String name, String salario) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        DatabaseReference ref = FirebaseDatabase.instance.ref();
        await ref.child(user.user!.uid).set({
          'name': name,
          'salario': salario,
        });
        connect(user.user!);
      });
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-exists':
          return 'Email já cadastrado';
        case 'invalid-email':
          return 'Email inválido';
        case 'invalid-password':
          return 'Senha inválida';
        default:
          return e.code;
      }
    }
  }

  recoverUser(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String?> actualUser() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      user = prefs.getString('idUser');
    }
    return user;
  }
}
