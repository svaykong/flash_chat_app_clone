import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../utils/app_util.dart';
import '../../controllers/firestore_controller.dart';
import '../../utils/logger.dart';
import 'message_bubble.dart';

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
            final String messageText = message.data()["text"];
            final String messageSender = message.data()["sender"];
            final isMe = loggedInUser.email == messageSender;
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: isMe,
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      title: const Text('Do you want to change?'),
                      content: Wrap(
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.center,
                        spacing: 10.0,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey[800],
                            ),
                            onPressed: isMe ? () {
                              'current message: $messageText'.log();

                              // firestoreController.editMessage(docID: docID, updateMessage: updateMessage);
                            } : null,
                            icon: const Icon(
                              Icons.edit,
                              color: thirdColor,
                            ),
                            label: const Text(
                              'Change',
                              style: TextStyle(
                                color: thirdColor,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: thirdColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
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
