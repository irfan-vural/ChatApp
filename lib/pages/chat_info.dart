import 'package:flutter/material.dart';

class ChatInfoPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  const ChatInfoPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.adminName});

  @override
  State<ChatInfoPage> createState() => _ChatInfoPageState();
}

class _ChatInfoPageState extends State<ChatInfoPage> {
  @override
  getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Chat Info"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.amber[900],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(getName(widget.adminName),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }
}
