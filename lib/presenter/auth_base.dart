import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  AuthResult user;
  IdTokenResult token;

  Future<AuthResult> SignIn(String email, String password) async {
    user = await auth.signInWithEmailAndPassword(email: email, password: password);
    token = await user.user.getIdToken(refresh: false);
    print(token.token);
    print(user.toString());
    return user;
  }

  Future<FirebaseUser> Logout() async {
    await auth.signOut();
  }
}
