import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimi/services/DatabaseServices/databaseServices.dart';
import 'package:fimi/views/logInSignUp/logInSignUp.dart';
import 'package:fimi/views/search/search.dart';
import 'package:fimi/views/vidioCallingScreen/videoCall.dart';
import 'package:fimi/views/vidioCallingScreen/videoCallJoin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fimi/providers/provider.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream? chatRoomStream;
  Stream? caller;

  DatabaseServices databaseServices = new DatabaseServices();
  @override
  void initState() {
    getUserInfo();
    print('initstate+++++');
    super.initState();
  }



  getUserInfo() async {
    QuerySnapshot user = await getUsername();
    databaseServices.getChatRooms(user.docs[0]['userName']).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  getUsername() async {
    return databaseServices.searchUserByEmail(
        await SharedPreferencesHelper.getEmailInSharedPrefrences());
  }

   CollectionReference? calleeCandidateCollectionRef  ;

   

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return RoomTiles(
                      snapshot.data.docs[index].data()['chatRoomId'],
                    );
                  })
              : Container();
        });
  }

  // chatRoomTile(chatRoomId) async {
  //   String photoURL = await getUser2imageURL(chatRoomId);
  //   return Container(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Row(
  //           children: [
  //             CircleAvatar(
  //               backgroundImage: NetworkImage(photoURL),
  //             ),
  //             Text(''),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Icon(Icons.call, size: 35),
  //             SizedBox(
  //               width: 40,
  //             ),
  //             Icon(
  //               Icons.video_call,
  //               size: 35,
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fimi'),
          actions: [
            IconButton(
                onPressed: () async {
                  context.read(googlelogInProvider).logOut();
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LogInSignUp()));
                },
                icon: Icon(Icons.exit_to_app))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          },
          child: Icon(
            Icons.search,
            size: 35,
          ),
        ),


        body: chatRoomList());
  }
}

class RoomTiles extends StatefulWidget {
  final String roomId;

  RoomTiles(
    this.roomId,
  );

  @override
  _RoomTilesState createState() => _RoomTilesState();
}

class _RoomTilesState extends State<RoomTiles> {
  DatabaseServices databaseServices = new DatabaseServices();

  @override
  void initState() {
    getNavtiveUserName();

    super.initState();
  }

  getNavtiveUserName() async {
    return await SharedPreferencesHelper.getUserNameSharedPrefrences();
  }

  Future<String> getUser2imageURL() async {
    String? nativeUser = await getNavtiveUserName();
    print('nativeuser++++++' + nativeUser.toString());

    QuerySnapshot user = await databaseServices.searchUsersByUserName(widget
        .roomId
        .toString()
        .replaceAll(nativeUser!, '')
        .replaceAll('_', ''));
    print('image+++++++' + user.docs[0]['photoURL']);
    return await user.docs[0]['photoURL'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Future.wait<dynamic>([getUser2imageURL(), getNavtiveUserName()]),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print('+++++++++' + snapshot.data.toString());
            return Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data[0].toString(), scale: 1),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          widget.roomId
                              .toString()
                              .replaceAll(snapshot.data[1], '')
                              .replaceAll('_', ''),
                          style: GoogleFonts.raleway(fontSize: 20),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallJoinScreen(widget.roomId)));
                            
                          },
                          child: Icon(
                            Icons.add_ic_call,
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VideoCallScreen(widget.roomId)));
                                          
                            },
                            child: Icon(Icons.video_call, size: 30)),
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
                child: Container(
                    height: 20, width: 20, child: CircularProgressIndicator()));
          }
        });
  }
}
