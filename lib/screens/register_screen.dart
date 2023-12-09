import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import '../app_util.dart';

class RegisterScreen extends StatelessWidget {
  static const id = 'register_screen';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo.png',
                height: 120.0,
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
                backgroundColor: primaryColor,
              ),
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
