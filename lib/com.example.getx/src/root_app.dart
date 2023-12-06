import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'screens/home_screen.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetX Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.blueGrey[900],
          cardColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (_) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
