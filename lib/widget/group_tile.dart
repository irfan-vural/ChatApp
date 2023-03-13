import 'package:comrades/widget/widgets.dart';
import 'package:flutter/material.dart';

import '../const/constants.dart';
import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatPage());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.green[200],
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 20,
          title: Text(
            widget.groupName,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(Constants.src),
          ),
        ),
      ),
    );
  }
}
