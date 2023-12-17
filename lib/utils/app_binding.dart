import 'package:get/get.dart';

import 'get_di.dart' as di;

class AppBinding implements Bindings {
  @override
  void dependencies() async {
    await di.init();
  }
}
