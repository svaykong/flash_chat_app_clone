import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../utils/util.dart';

class HomeScreen extends StatelessWidget {
  static const id = 'home_screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                ),
                onPressed: () {
                  Get.snackbar("Hello", "This is a snack bar!");
                },
                child: const Text('Display snack bar'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.background,
                ),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Notice',
                    titleStyle: kCommonTextStyle,
                    middleText: 'This is a default dialog notice!',
                    middleTextStyle: kCommonTextStyle,
                    textConfirm: 'OK',
                    confirmTextColor: Theme.of(context).colorScheme.background,
                    buttonColor: Colors.white,
                    onConfirm: () => Get.back(),
                  );
                },
                child: const Text('Display default dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
