import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
    return GestureDetector(
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
          color: Colors.blueGrey[800],
          child: Container(
            alignment: Alignment.centerLeft,
            width: _getWidth(),
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
                        _getName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.green,
                        ),
                      ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get _getName {
    if (sender.isEmpty) return "";
    String name = sender.substring(0, sender.indexOf('@'));
    name = name[0].toUpperCase() + name.substring(1, name.length);
    return name;
  }

  double _getWidth() {
    double result = Get.width;
    final divided = result / text.length;
    if (divided <= 13) {
      result = Get.width * 0.7;
    } else {
      if (text.length <= 5) {
        result = Get.width * 0.3;
      } else if (text.length > 5 && text.length < 9) {
        result = Get.width * 0.4;
      } else if (text.length == 9) {
        result = Get.width * 0.45;
      } else if (text.length >= 10 && text.length <= 15) {
        result = Get.width * 0.5;
      } else {
        result = Get.width * 0.7;
      }
    }

    return result;
  }
}
