import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrades/helper/helper_functions.dart';
import 'package:comrades/service/database_service.dart';
import 'package:comrades/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  String admin = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin() async {
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getChats(widget.groupId)
        .then((value) {
      setState(() {
        chats = value;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupAdmin(widget.groupId)
        .then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text("Chat Page"),
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(
                    context,
                    ChatInfoPage(
                      groupName: widget.groupName,
                      groupId: widget.groupId,
                      adminName: admin,
                    ));
              },
              icon: Icon(Icons.info)),
        ],
      ),
      body: Scaffold(),
    );
  }
}
