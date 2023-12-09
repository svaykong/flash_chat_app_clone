import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

void init() {
  // Controller
  Get.lazyPut(() => AuthController());
}
