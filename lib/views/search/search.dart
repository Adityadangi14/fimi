import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimi/services/DatabaseServices/databaseServices.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';
import 'package:fimi/views/HomePage/testView.dart';
import 'package:fimi/views/search/helperSearchWidget.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fimi/views/HomePage/HomePage.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  QuerySnapshot? fetchedData;
  DatabaseServices databaseServices = new DatabaseServices();
  SearchHelper searchHelper = new SearchHelper();

  TextEditingController searchInputController = new TextEditingController();

  initiateSearch() {
    databaseServices
        .searchUsersByUserName(searchInputController.text)
        .then((val) {
      print('$val');
      setState(() {
        fetchedData = val;
      });
    });
  }

  searchList() {
    print('seachList++++');

    return fetchedData != null
        ? ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: fetchedData!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(fetchedData!.docs[index]['photoURL'] + '+++++');
              final imageUrl = fetchedData!.docs[index]['photoURL'];
              final displayName = fetchedData!.docs[index]['displayName'];
              final userName = fetchedData!.docs[index]['userName'];
              return searchTile(imageUrl, displayName, userName);
            })
        : Container();
  }

  createChatRoom(userName) async {
    QuerySnapshot user = await getUsername();
    String roomId = searchHelper.roomId(user.docs[0]['userName'], userName);
    Map<String, dynamic> usersMap = {
      'users': [user.docs[0]['userName'], userName],
      'chatRoomId': roomId
    };
    databaseServices.createRoom(roomId, usersMap);
  }

  getUsername() async {
    return databaseServices.searchUserByEmail(
        await SharedPreferencesHelper.getEmailInSharedPrefrences());
  }

  searchTile(String imageURL, String displayName, String userName) {
    print("searchTile++++++");
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imageURL,
                ),
                radius: 40,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('@' + userName),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              createChatRoom(userName);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: TextField(
                          controller: searchInputController,
                          style: GoogleFonts.raleway(fontSize: 20),
                          decoration: InputDecoration(
                              hintText: 'Search by Username',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        initiateSearch();
                      },
                      child: Container(
                        width: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.all(10),
                        child: Icon(
                          Icons.search,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            searchList(),
          ],
        ),
      )),
    );
  }
}
