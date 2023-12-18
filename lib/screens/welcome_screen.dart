import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gap/gap.dart';

import '../utils/app_util.dart';
import '../screens/export_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const id = '/welcome_screen';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thirdColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 60.0,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.11, //ios: 45.0 aos: 35.0
                        fontWeight: FontWeight.w900,
                      ),
                      speed: const Duration(milliseconds: 130),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(48.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(LoginScreen.id),
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              child: const Text(
                'Login',
                style: kTextStyle,
              ),
            ),
            const Gap(32.0),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(RegisterScreen.id),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: const Text(
                'Register',
                style: kTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
