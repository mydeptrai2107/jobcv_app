import 'package:app/modules/candidate/presentations/views/chat/widgets/item_user_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeChatCandidateScreen extends StatefulWidget {
  final String currentUserId;
  const HomeChatCandidateScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  State<HomeChatCandidateScreen> createState() =>
      _HomeChatCandidateScreenState();
}

class _HomeChatCandidateScreenState extends State<HomeChatCandidateScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tin nhắn'),
      ),
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
            return Container(
              width: size.width,
              height: size.height,
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17.5),
                    height: 50,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5, color: Colors.black.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(8)),
                    child: const TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                          hintText: 'Search'),
                    ),
                  ),
                  SizedBox(
                    height: size.width - 60,
                    child: ListView.builder(
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
                                  //var friend = asyncSnap.data;
                                  return ItemUserChat(
                                    idUser: widget.currentUserId,
                                    idCompany: friendId,
                                    lastMsgl: lastMsg,
                                  );
                                }
                                return LoadingAnimationWidget.waveDots(
                                    color: Colors.grey, size: 5);
                              });
                        }),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
