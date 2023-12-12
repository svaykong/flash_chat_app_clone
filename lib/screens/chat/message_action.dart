import 'package:flutter/material.dart';

class MessageAction extends StatefulWidget {
  const MessageAction({super.key});

  @override
  State<MessageAction> createState() => _MessageActionState();
}

class _MessageActionState extends State<MessageAction> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text('Alert'),
      content: Text('Content Alert'),
      actions: [
        Row(
          children: [
            Icon(Icons.edit),
            Text('Edit'),
          ],
        )
      ],
    );
  }
}
