import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chatting/chatting/chat/new_message.dart';

import '../chatting/chat/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  void getCurrentUser(){
    try{
      final user = _authentication.currentUser;
      if(user != null){
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Screen'
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.white,
            ),
            onPressed: (){
              _authentication.signOut();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages()
            ),
            NewMessage()
          ],
        ),
      )
    );
  }
}
