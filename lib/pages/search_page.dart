import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comrades/const/constants.dart';
import 'package:comrades/widget/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_functions.dart';
import '../service/database_service.dart';
import 'chat_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String r) {
    return r.substring(0, r.indexOf("_"));
  }

  Future<void> gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("Search"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search Groups...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    initialSearchMethod();
                    print("method called");
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading ? Center(child: CircularProgressIndicator()) : groupList(),
        ],
      ),
    );
  }

  Future<void> initialSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName((searchController.text).trim())
          .then((snapshot) {
        searchSnapshot = snapshot;
        isLoading = false;
        hasUserSearched = true;
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index].get("admin"),
                searchSnapshot!.docs[index].get("groupId"),
                searchSnapshot!.docs[index].get("groupName"),
              );
            },
          )
        : Container();
  }

  Widget groupTile(
    String userName,
    String admin,
    String groupId,
    String groupName,
  ) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              trailing: InkWell(
                onTap: () {
                  DatabaseService()
                      .toggleGroupJoin(groupId, userName, groupName);
                  if (isJoined) {
                    setState(() {
                      isJoined = !isJoined;
                    });
                    showSnackbar(
                      context,
                      Colors.green,
                      "successfully joined",
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      nextScreen(
                          context,
                          ChatPage(
                              groupId: groupId,
                              groupName: groupName,
                              userName: userName));
                    });
                  } else {
                    showSnackbar(
                      context,
                      Colors.red,
                      "there is some error  ",
                    );
                  }
                },
              ),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(Constants.src),
              ),
              title: Text(groupName),
              subtitle: Text(getName(admin)),
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
