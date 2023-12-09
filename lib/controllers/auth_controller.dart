import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final FirebaseAuth _auth;
  RxString errorMsg = ''.obs;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    _auth = FirebaseAuth.instance;
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      _updateLoading(true);
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        errorMsg = ''.obs;
      } else {
        errorMsg = 'User credential is unknown'.obs;
      }
    } catch (e) {
      errorMsg = e.toString().obs;
    } finally {
      _updateLoading(false);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _updateLoading(true);
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        errorMsg = ''.obs;
      } else {
        errorMsg = 'User credential is unknown'.obs;
      }
    } catch (e) {
      errorMsg = e.toString().contains('INVALID_LOGIN_CREDENTIALS') ? 'INVALID_LOGIN_CREDENTIALS'.obs : e.toString().obs;
    } finally {
      _updateLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      errorMsg = ''.obs;
    } catch (e) {
      errorMsg = e.toString().obs;
    }
  }

  User? get getCurrentUser => _auth.currentUser;

  void _updateLoading(bool currentStatus) {
    isLoading = currentStatus;
    update();
  }
}
