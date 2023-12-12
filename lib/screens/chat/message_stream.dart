import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../controllers/firestore_controller.dart';
import 'message_bubble.dart';
import 'message_action.dart';

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key? key,
    required this.loggedInUser,
  }) : super(key: key);
  final User loggedInUser;

  @override
  Widget build(BuildContext context) {
    final firestoreController = Get.find<FirestoreController>();
    return StreamBuilder(
        stream: firestoreController.messageStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _wrapPadding(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return _wrapPadding(
              child: Text('Snapshot error: ${snapshot.error}'),
            );
          }

          final messages = snapshot.data!.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()["text"];
            final messageSender = message.data()["sender"];
            final isMe = loggedInUser.email == messageSender;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: isMe,
              onTap: () {
                if (isMe) {
                  print('message data: ${message.id}');

                  showMenu(
                    context: context,
                    position: RelativeRect.fill,
                    items: [
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.edit),
                              Text('Edit'),
                            ],
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        child: InkWell(
                          onTap: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.edit),
                              Text('Edit2'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                  // const MessageAction();
                }
              },
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: Container(
              color: Colors.blueGrey[800],
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                children: messageBubbles,
              ),
            ),
          );
        });
  }

  Widget _wrapPadding({required Widget child}) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        child: child,
      );
}
