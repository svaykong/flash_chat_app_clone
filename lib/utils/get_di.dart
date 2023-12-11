import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/firestore_controller.dart';

void init() {
  // Controller
  Get.lazyPut(() => AuthController());
  Get.lazyPut(() => FirestoreController());
}
