import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parti_app/models/failure.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  FirebaseAuth.FirebaseAuth _auth;
  FirebaseAuth.User? _user;
  Status _status = Status.uninitialized;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthProvider.instance() : _auth = FirebaseAuth.FirebaseAuth.instance {
    _auth.authStateChanges().listen((event) {
      _onAuthStateChanged(event);
    });
  }

  Status get status => _status;
  FirebaseAuth.User? get user => _user;

  Future<bool?>? signIn() async {
    Failure? failure;
    if (_loginFormKey.currentState!.validate()) {
      try {
        _status = Status.authenticating;
        notifyListeners();
        await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        return true;
      } catch (e) {
        _status = Status.unauthenticated;
        notifyListeners();
        throw Exception(e);
      }
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print(e);
      _status = Status.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void _onAuthStateChanged(FirebaseAuth.User? firebaseUser) {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.authenticated;
    }
    notifyListeners();
  }
}
