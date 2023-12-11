import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import '../utils/app_util.dart';
import 'chat_screen.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authController = Get.find<AuthController>();
  final _loginFormKey = GlobalKey<FormState>();
  String _email = 'johndoe@gmail.com';
  String _password = 'johnqwer';
  bool _secured = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Form(
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  initialValue: _email,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (inputValue) {
                    if (inputValue == null || inputValue.isEmpty) {
                      return "Please enter email";
                    }
                    if (!inputValue.contains('@')) {
                      return "Invalid email";
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
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
                  initialValue: _password,
                  validator: (inputValue) {
                    if (inputValue == null || inputValue.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
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
                  autofocus: false,
                  autocorrect: false,
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    _password = value;
                  },
                  textAlign: TextAlign.center,
                  obscureText: _secured,
                ),
                const Gap(26.0),
                GetBuilder<AuthController>(
                    init: _authController,
                    builder: (authCtr) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (_loginFormKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            await authCtr.login(
                              email: _email,
                              password: _password,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            if (authCtr.errorMsg.string.isEmpty) {
                              Get.snackbar('Login', 'Success');
                              if (!mounted) return;
                              Get.offNamedUntil(ChatScreen.id, (route) => false);
                            } else {
                              Get.snackbar('Login exception', authCtr.errorMsg.string);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                        ),
                        child: const Text(
                          'Login',
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
