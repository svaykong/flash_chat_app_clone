import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import '../app_util.dart';

class LoginScreen extends StatelessWidget {
  static const id = 'login_screen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo.png',
                height: 160.0,
              ),
            ),
            const Gap(48.0),
            TextFormField(
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              autofocus: false,
              autocorrect: false,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
            const Gap(8.0),
            TextFormField(
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              autofocus: false,
              autocorrect: false,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
            ),
            const Gap(26.0),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
              ),
              child: const Text(
                'Login',
                style: kTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
