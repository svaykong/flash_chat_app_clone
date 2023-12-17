import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import '../utils/logger.dart';
import '../utils/app_util.dart';
import '../controllers/auth_controller.dart';
import 'chat/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authController = Get.find<AuthController>();
  final _loginFormKey = GlobalKey<FormState>();
  String _email = 'johndoe@gmail.com'; //test@gmail.com
  String _password = 'johnqwer'; //test123
  bool _secured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => ModalProgressHUD(
          inAsyncCall: _authController.isLoading.value,
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
                        icon: Icon(
                          _secured ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black38,
                        ),
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_loginFormKey.currentState!.validate()) {
                        await _authController.login(
                          email: _email,
                          password: _password,
                        );
                        /*
                        if (_authController.errorMsg.string.isEmpty) {
                          Get.snackbar('Login', 'Success');
                          if (!mounted) return;
                          Get.offNamed(ChatScreen.id);
                        } else {
                          Get.snackbar('Login exception', _authController.errorMsg.string);
                        }
                        */
                      }
                    },
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
          ),
        ),
      ),
    );
  }
}
