import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';

import '../controllers/firestore_controller.dart';
import '../controllers/auth_controller.dart';
import '../screens/welcome_screen.dart';
import '../utils/app_util.dart';

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
        backgroundColor: secondaryColor,
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
                    const MessagesStream(),
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
                            ),
                          ),
                          ElevatedButton(
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
                            child: const Text(
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firestoreController = Get.find<FirestoreController>();
    final authController = Get.find<AuthController>();
    return StreamBuilder(
        stream: firestoreController.messageStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Snapshot error: ${snapshot.error}');
          }

          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()["text"];
            final messageSender = message.data()["sender"];

            // _loggedInUser
            final currentUser = authController.getCurrentUser!.email;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 20.0,
              ),
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? secondaryColor : thirdColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? thirdColor : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
