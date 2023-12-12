import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../utils/app_util.dart';
import '../../controllers/firestore_controller.dart';
import 'message_bubble.dart';

class MessagesStream extends StatefulWidget {
  const MessagesStream({
    Key? key,
    required this.loggedInUser,
  }) : super(key: key);
  final User loggedInUser;

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
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
            final isMe = widget.loggedInUser.email == messageSender;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: isMe,
              onTap: () async {
                if (isMe) {
                  await showDialog<void>(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) {
                        return const Row(
                          children: [
                            Icon(
                              Icons.edit,
                              color: thirdColor,
                            ),
                            Gap(10.0),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: thirdColor,
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: thirdColor, width: 0.2),
                ),
                color: Colors.blueGrey[800],
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 10.0,
                ),
                itemCount: messageBubbles.length,
                itemBuilder: (context, index) {
                  final isMe = messageBubbles[index].isMe;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: messageBubbles[index],
                  );
                },
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
