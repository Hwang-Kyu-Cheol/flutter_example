import 'package:flutter/material.dart';
import 'package:flutter_chatting/screens/chat_screen.dart';
import 'package:flutter_chatting/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyD0kvvCI5R5y2O6zeH5fAo0jmLvvd2VSR8",
      appId: "1:124751189479:android:b400a4e02392ffcdb35942",
      messagingSenderId: "124751189479",
      projectId: "chat-app-54c4b",
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting App',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ChatScreen();
          }
          return LoginSignupScreen();
        },
      ),
    );
  }
}
