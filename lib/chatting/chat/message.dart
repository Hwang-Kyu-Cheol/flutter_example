import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatting/chatting/chat/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('time', descending: true)
              .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(5,0,5,0),
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index){
            return ChatBubbles(
              userImage: chatDocs[index]['userImage'],
              message: chatDocs[index]['text'],
              isMe: chatDocs[index]['userId'].toString() == user!.uid,
              userName: chatDocs[index]['userName'],
            );
          },
        );
      },
    );
  }
}
