import 'package:app/modules/candidate/presentations/views/chat/widgets/message_textfield.dart';
import 'package:app/modules/candidate/presentations/views/chat/widgets/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                friendImage,
                height: 35,
                width: 35,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                friendName,
                style: const TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserId)
                      .collection('messages')
                      .doc(friendId)
                      .collection('chats')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return const Center(
                          child: Text('Say hi'),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          bool isMe = snapshot.data.docs[index]['senderId'] ==
                              currentUserId;
                          return SingleMessage(
                              snapshot.data.docs[index]['message'], isMe);
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            MessageTextField(currentUserId, friendId),
          ],
        ),
      ),
    );
  }
}
