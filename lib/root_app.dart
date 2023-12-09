import 'package:flutter/material.dart';

import 'screens/export_screen.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (_) => const WelcomeScreen(),
        LoginScreen.id: (_) => const LoginScreen(),
        RegisterScreen.id: (_) => const RegisterScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
 