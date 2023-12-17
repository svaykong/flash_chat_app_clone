import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/export_screen.dart';
import '../utils/logger.dart';
import '../controllers/auth_prefs_controller.dart';

class AuthController extends GetxController {
  late final FirebaseAuth _firebaseAuth;
  late final AuthPrefsController _authPrefs;
  late final SharedPreferences _prefs;
  final RxString errorMsg = ''.obs;

  final RxBool _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  final RxString _token = ''.obs;
  String get token => _token.value;

  RxBool isLogged = RxBool(false);

  @override
  void onInit() async {
    'AuthController onInit'.log();
    super.onInit();

    _firebaseAuth = FirebaseAuth.instance;
    _prefs = Get.find<SharedPreferences>();
    _authPrefs = AuthPrefsController(_prefs);
    final localToken = _authPrefs.getToken(AuthPrefsController.tokenKey);
    await _checkLocalToken(localToken);
    ever(isLogged, _firstRoute);
  }

  Future<void> _checkLocalToken(String? localToken) async {
    '_checkLocalToken called...'.log();
    try {
      if (localToken != null) {
        // final emailAuthProvider = EmailAuthProvider.credential(email: email, password: password);
        // await _firebaseAuth.signInWithCredential(emailAuthProvider);
        var userCredential = await _firebaseAuth.signInWithCustomToken(localToken);
        'userCredential: $userCredential'.log();
        // if (userCredential.user != null) {
        //   final user = userCredential.user;
        //   'user: $user'.log();
        //   isLogged(true);
        // }
      }
    } catch (e) {
      '_checkLocalToken exception: $e'.log();
    }
  }

  void _firstRoute(bool logged) async {
    if (logged) {
      Get.offNamed(ChatScreen.id);
    } else {
      Get.offNamed(LoginScreen.id);
    }
  }

  Future<void> register({required String email, required String password}) async {
    try {
      _isLoading(true);
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) {
        errorMsg('User credential is unknown');
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMsg('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        errorMsg('The account already exists for that email.');
      }
    } catch (e) {
      errorMsg(e.toString());
    } finally {
      _isLoading(false);
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      _isLoading(true);
      await Future.delayed(const Duration(seconds: 1), () {});

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final token = await userCredential.user?.getIdToken(/* forceRefresh */ true);

      if (token == null) {
        errorMsg('token is null');
        return;
      }
      _token(token);
      _authPrefs.setToken(_token.value);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMsg('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        errorMsg('Wrong password provided for that user.');
      }
    } catch (e) {
      errorMsg(e.toString());
    } finally {
      _isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _isLoading(true);
      await Future.delayed(const Duration(seconds: 1), () {});
      await _firebaseAuth.signOut();
      await _authPrefs.removeToken();
      errorMsg('');
    } catch (e) {
      errorMsg(e.toString());
    } finally {
      _isLoading(false);
    }
  }

  User? get getCurrentUser => _firebaseAuth.currentUser;
}
