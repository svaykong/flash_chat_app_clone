import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../controllers/firestore_controller.dart';

Future<void> init() async {
  // async dependency injection
  await Get.putAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });

  // Controller
  Get.lazyPut<AuthController>(() => AuthController());
  Get.lazyPut(() => FirestoreController());
}
