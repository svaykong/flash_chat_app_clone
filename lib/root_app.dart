import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'screens/export_screen.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: WelcomeScreen.id,
      getPages: [
        GetPage(name: WelcomeScreen.id, page: () => const WelcomeScreen()),
        GetPage(name: LoginScreen.id, page: () => const LoginScreen()),
        GetPage(name: RegisterScreen.id, page: () => const RegisterScreen()),
        GetPage(name: ChatScreen.id, page: () => const ChatScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
