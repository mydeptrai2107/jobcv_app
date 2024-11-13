import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;

  const SingleMessage(this.message, this.isMe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
              color: isMe ? primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.circular(8)),
          child: Text(
            message,
            style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
        )
      ],
    );
  }
}
