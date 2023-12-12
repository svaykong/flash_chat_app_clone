import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.onTap,
  });

  final String sender;
  final String text;
  final bool isMe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String name = sender.substring(
      0,
      sender.indexOf('@'),
    );
    name = name[0].toUpperCase() + name.substring(1, name.length);
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Material(
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
              color: Colors.blueGrey[800], //isMe ? secondaryColor : thirdColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isMe
                        ? const SizedBox.shrink()
                        : Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.green,
                            ),
                          ),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white, //isMe ? thirdColor : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
