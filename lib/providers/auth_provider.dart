import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parti_app/models/failure.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;
  final TextEditingController _registerEmailController =
      TextEditingController();

  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;
  FirebaseAuth.FirebaseAuth _auth;
  FirebaseAuth.User? _user;
  Status _status = Status.uninitialized;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isTextVisible = false;
  set isTextVisible(value) {
    _isTextVisible = !_isTextVisible;
    notifyListeners();
  }

  bool get isTextVisible => _isTextVisible;
  TextEditingController get registerEmailController => _registerEmailController;

  TextEditingController get registerPasswordController =>
      _registerPasswordController;
  TextEditingController get registerNameController => _registerNameController;
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
      if (_auth.currentUser?.uid != null) {
        _status = Status.authenticated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      print(e);
      _status = Status.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final userCredential =
          await _auth.signInWithCredential(facebookCredential);
      if (_auth.currentUser?.uid != null) {
        _status = Status.authenticated;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _status = Status.unauthenticated;

      rethrow;
    }
    return false;
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
