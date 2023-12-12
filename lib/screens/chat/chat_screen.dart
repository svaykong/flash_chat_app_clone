import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import '../../controllers/firestore_controller.dart';
import '../../controllers/auth_controller.dart';
import '../welcome_screen.dart';
import '../../utils/app_util.dart';
import 'message_stream.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'chat_screen';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageTextController = TextEditingController();
  final _firestoreController = Get.find<FirestoreController>();
  User? _loggedInUser;
  final _authController = Get.find<AuthController>();
  String _messageText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loggedInUser = _authController.getCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.close,
                color: thirdColor,
              ),
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await _authController.logout();
                setState(() {
                  _isLoading = false;
                });
                if (_authController.errorMsg.isNotEmpty) {
                  Get.snackbar('Unknown Error', 'Logout failed');
                } else {
                  Get.snackbar('Logout', 'success');
                }
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(WelcomeScreen.id, (route) => false);
              }),
        ],
        title: const Text(
          '⚡️Chat',
          style: TextStyle(
            color: thirdColor,
          ),
        ),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: _loggedInUser == null
              ? const Center(child: Text("Could not verify user"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    MessagesStream(
                      loggedInUser: _loggedInUser!,
                    ),
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _messageTextController,
                              onChanged: (value) {
                                _messageText = value;
                              },
                              decoration: kMessageTextFieldDecoration,
                              style: const TextStyle(
                                color: thirdColor
                              ),
                              autocorrect: false,
                              autofocus: false,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: thirdColor
                            ),
                            onPressed: () {
                              _messageTextController.clear();
                              String? email = _loggedInUser!.email;
                              if (email == null) {
                                Get.snackbar("Email Error", "Email is null");
                                return;
                              }
                              // getting collection ID from cloud firestore
                              _firestoreController.sendMessage(messageText: _messageText, email: email);
                            },
                            child: Text(
                              'Send',
                              style: kSendButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
