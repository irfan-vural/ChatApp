import 'package:flutter/material.dart';

class ProfileTile extends StatefulWidget {
  Icon icon;
  String title;
  String subtitle;
  ProfileTile(
      {required this.icon, required this.title, required this.subtitle});
  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {},
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.amber[200],
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 20,
            title: Text(
              widget.title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(widget.subtitle),
            leading: widget.icon,
          ),
        ));
  }
}
