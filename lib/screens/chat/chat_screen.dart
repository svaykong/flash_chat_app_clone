import 'package:flask_chat_app_clone/utils/logger.dart';
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
  late final FirestoreController _firestoreController;
  late final AuthController _authController;

  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  late FocusNode _myFocusNode;
  late final TextEditingController _messageTextController;
  User? _loggedInUser;
  String _messageText = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _firestoreController = Get.find<FirestoreController>();
    _authController = Get.find<AuthController>();
    _myFocusNode = FocusNode();
    _messageTextController = TextEditingController();
    _loggedInUser = _authController.getCurrentUser;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _myFocusNode.dispose();
    _messageTextController.dispose();
    super.dispose();
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
              ? const Center(
                  child: Text("Could not verify user"),
                )
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
                          GetBuilder(
                              init: _firestoreController,
                              builder: (fireStoreCtr) {
                                if (fireStoreCtr.updateMessage.isNotEmpty) {
                                  _messageText = fireStoreCtr.updateMessage.value;
                                  _messageTextController.text = _messageText;

                                  // When click change button
                                  // give focus to the text field using myFocusNode.
                                  _myFocusNode.requestFocus();
                                }
                                return Expanded(
                                  child: TextField(
                                    focusNode: _myFocusNode,
                                    controller: _messageTextController,
                                    onChanged: (value) {
                                      _messageText = value;
                                    },
                                    decoration: kMessageTextFieldDecoration,
                                    style: const TextStyle(color: thirdColor),
                                    autocorrect: false,
                                    autofocus: false,
                                  ),
                                );
                              }),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: thirdColor),
                            onPressed: () async {
                              _messageTextController.clear();
                              String? email = _loggedInUser!.email;
                              if (email == null) {
                                Get.snackbar("Email Error", "Email is null");
                                return;
                              }
                              if (_firestoreController.isUpdate.value) {
                                final msgID = _firestoreController.messageID.value;
                                _firestoreController.clearUpdateMessage();
                                await _firestoreController.editMessage(msgID: msgID, updatedMsg: _messageText);
                              } else {
                                if (_messageText.isEmpty) {
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                                _firestoreController.sendMessage(messageText: _messageText, email: email);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
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
