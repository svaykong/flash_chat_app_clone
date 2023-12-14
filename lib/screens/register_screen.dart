import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import '../utils/app_util.dart';
import '../controllers/auth_controller.dart';
import 'chat/chat_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const id = 'register_screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _authController = Get.find<AuthController>();
  final _registerFormKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _secured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _authController.isLoading.value,
        child: Form(
          key: _registerFormKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 200.0,
                    ),
                  ),
                ),
                const Gap(48.0),
                TextFormField(
                  validator: (inputValue) {
                    if (inputValue == null || inputValue.isEmpty) {
                      return "Please enter email.";
                    } else if (!inputValue.contains('@')) {
                      return "Please enter email.";
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofocus: false,
                  autocorrect: false,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const Gap(8.0),
                TextFormField(
                  validator: (inputValue) {
                    if (inputValue == null || inputValue.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _secured = !_secured;
                        });
                      },
                      icon: Icon(_secured ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  obscureText: _secured,
                  autofocus: false,
                  autocorrect: false,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                const Gap(26.0),
                GetBuilder<AuthController>(
                    init: _authController,
                    builder: (authCtr) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_registerFormKey.currentState!.validate()) {
                            await authCtr.register(
                              email: _email,
                              password: _password,
                            );
                            if (authCtr.errorMsg.string.isEmpty) {
                              Get.snackbar('Register', 'Success');
                              if (!mounted) return;
                              Get.offNamedUntil(ChatScreen.id, (route) => false);
                            } else {
                              Get.snackbar('Register exception', authCtr.errorMsg.string);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        child: const Text(
                          'Register',
                          style: kTextStyle,
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
