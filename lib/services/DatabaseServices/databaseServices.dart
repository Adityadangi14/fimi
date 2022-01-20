import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimi/views/search/search.dart';
import 'package:flutter/cupertino.dart';

class DatabaseServices {
  void uploadUserData(userMap) {
    FirebaseFirestore.instance.collection('Users').add(userMap);
  }

  doesUserExist(currentEmail) async {
    print('currentEmail===========' + currentEmail);
    try {
      final bool data = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: currentEmail)
          .get()
          .then((value) => value.size > 0 ? true : false);
      print('data+++' + data.toString());
      return data;
    } catch (e) {
      debugPrint("catch =======" + e.toString());
    }
  }

  searchUsersByUserName(userNameSearch) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('userName', isEqualTo: userNameSearch)
        .get();
  }

  searchUserByEmail(userEmail) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();
  }

  createRoom(roomId, userMap) async {
    FirebaseFirestore.instance.collection('rooms').doc(roomId).set(userMap);
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection("rooms")
        .where("users", arrayContains: userName)
        .snapshots();
  }
  // All signaling services are below
  addCallerCandidates(Map<String,dynamic> candidate, String roomId){
    FirebaseFirestore.instance
    .collection('rooms')
    .doc(roomId)
    .collection('callerCandidates')
    .add(candidate);
  }

  addOfferOrAnswerSdp(Map<String,dynamic> sdp,String roomId){
    FirebaseFirestore.instance.collection('rooms').doc(roomId).
    collection('sdp').doc('OfferAnswerSdp').set(sdp);
  }

  getSdpRoomRef(String roomId) async {
    return await FirebaseFirestore.instance.collection('rooms')
    .doc(roomId).collection('sdp');
  } 

  newCalleeCandidateCheck(String roomId) async {
    return await FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('calleeCandidate');
  }


  getSdpDoc(String roomId) async {
    return await FirebaseFirestore.instance
    .collection('rooms')
    .doc(roomId)
    .collection('sdp')
    .doc('OfferAnswerSdp')
    .get();
  }

  setCalleeCandidate(String roomId, candidate){
   return FirebaseFirestore.instance
   .collection('rooms')
    .doc(roomId).
    collection('calleeCandidate')
    .add(candidate);
  }

  newCallerCandidateCheck(String roomId){
    return FirebaseFirestore.instance
    .collection('rooms')
    .doc(roomId)
    .collection('callerCandidates');
  }

  setCaller(String roomId , String userName ){
    FirebaseFirestore.instance.collection('rooms')
    .doc(roomId)
    .collection('caller').add({'caller':userName});
  } 

  deleteCaller(roomId)async {
    print('++++'+roomId);
    CollectionReference collection =  FirebaseFirestore.instance.collection('rooms')
    .doc(roomId).collection('caller');

  var futureQuery = await collection.get();
  for(var doc in futureQuery.docs){
    await doc.reference.delete();
  }
}

  deleteCalleeCandidates(roomId) async {
     CollectionReference collection =  FirebaseFirestore.instance.collection('rooms').doc(roomId).collection('calleeCandidate');

   var futureQuery = await collection.get();
  for(var doc in futureQuery.docs){
    await doc.reference.delete();
  }
  }

  deleteCallerCandidates(roomId) async{
     CollectionReference collection =  FirebaseFirestore.instance.collection('rooms')
     .doc(roomId)
     .collection('callerCandidates');

      var futureQuery = await collection.get();
      for(var doc in futureQuery.docs){
    await doc.reference.delete();
  }

  }

  deleteSdp(roomId) async {
    CollectionReference collection =  FirebaseFirestore.instance.collection('rooms')
     .doc(roomId)
     .collection('sdp');

      var futureQuery = await collection.get();
      for(var doc in futureQuery.docs){
    await doc.reference.delete();
  }

  }

}