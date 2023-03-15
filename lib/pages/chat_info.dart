import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/database_service.dart';

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
  Stream? members;

  getParticipants() {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getParticipants();
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
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
          participantList(),
        ],
      ),
    );
  }

  participantList() {
    return StreamBuilder(
        stream: members,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
          if (snapshot.data["members"] == null) {
            return Center(
              child: const Text("No members"),
            );
          }
          if (snapshot.data["members"].length < 1) {
            return Center(
              child: const Text("No members"),
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data["members"].length,
                itemBuilder: (context, index) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber[900],
                        child: Text(getName(snapshot.data["members"][index])[0],
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      title: Text(getName(snapshot.data["members"][index]),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  );
                });
          }
        });
  }
}
