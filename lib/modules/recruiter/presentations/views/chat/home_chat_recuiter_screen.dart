import 'package:app/modules/recruiter/presentations/views/chat/item_company_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeChatRecruiterScreen extends StatefulWidget {
  final String currentUserId;
  const HomeChatRecruiterScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  State<HomeChatRecruiterScreen> createState() =>
      _HomeChatRecruiterScreenState();
}

class _HomeChatRecruiterScreenState extends State<HomeChatRecruiterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.currentUserId)
            .collection('messages')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return const Center(
                child: Text("No Chats Available!"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var friendId = snapshot.data.docs[index].id;
                  var lastMsg = snapshot.data.docs[index]['last_msg'];
                  return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnap) {
                        if (asyncSnap.hasData) {
                          ///var friend = asyncSnap.data;
                          return ItemCompanyChat(
                            idUser: friendId,
                            idCompany: widget.currentUserId,
                            lastMsgl: lastMsg,
                          );
                        }
                        return LoadingAnimationWidget.waveDots(
                            color: Colors.grey, size: 20);
                      });
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
