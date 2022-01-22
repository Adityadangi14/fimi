
//step 1: collecting our local ice candidates
//step 2: send it to our room
//step 3: listen to remote session descrption
//step 4: listen for remote ice candidate
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:fimi/services/DatabaseServices/databaseServices.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';


typedef void StreamStateCallback(MediaStream stream);
class Signaling{

  RTCPeerConnection? peerConnection ;
  MediaStream? localStream;
  MediaStream? remoteStream;
  StreamStateCallback? onAddRemoteStream;
  DatabaseServices databaseServices = new DatabaseServices();


  Map<String, dynamic> configuration = {
      "iceServers": [
        {
          "urls": [
            "stun:stun.l.google.com:19302",
          ]
        }
      ]
    };


  createConnection(String? roomId) async{
    

    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "Optional": []
    };

     peerConnection = await createPeerConnection(configuration,offerSdpConstraints);
    registerPeerConnectionListeners();

         peerConnection!.onIceConnectionState = (e) {
      print('connectionState:'+ e.toString());
    };

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track);
    });

     peerConnection?.onIceConnectionState = (e) {
      print(e);
    };

    String? userName = await SharedPreferencesHelper.getUserNameSharedPrefrences();

  databaseServices.setCaller(roomId!, userName!);

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate){
      databaseServices.addCallerCandidates(candidate.toMap(), roomId!);
    };

    RTCSessionDescription offer = await peerConnection!.createOffer();

    await peerConnection!.setLocalDescription(offer);

    databaseServices.addOfferOrAnswerSdp({"offer":offer.toMap()}, roomId!);   

    CollectionReference sdpCollectionRef = databaseServices.getSdpRoomRef(roomId);

    sdpCollectionRef.snapshots().listen(( dynamic snapshot) async { 
      Map<String ,dynamic> data = snapshot.data() as Map<String , dynamic>;
      if(peerConnection?.getRemoteDescription() != null && data['answer'] != null ){
          var answer = RTCSessionDescription(data['answer']['sdp'], data['answer']['type']);

          await peerConnection?.setRemoteDescription(answer);
      }
    });

    CollectionReference calleeCandidateCollectionRef = databaseServices.newCalleeCandidateCheck(roomId);

    calleeCandidateCollectionRef.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if(change.type == DocumentChangeType.added){
        Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;

          peerConnection?.addCandidate(RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex']
          ));
        }
      });
     });


    
  }

  joinRoom( String roomId) async{
      

      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      registerPeerConnectionListeners();

      DocumentSnapshot snapshot = await databaseServices.getSdpDoc(roomId);
      print("roomRef "+ snapshot.toString());
      var data = await snapshot.data() as Map<String ,dynamic>;
      
      // var data = roomSnapshot.data() as Map<String ,dynamic>;
     

      peerConnection?.onIceCandidate = (RTCIceCandidate candidate){
        
          databaseServices.
          setCalleeCandidate(roomId, candidate.toMap());
      };

      registerPeerConnectionListeners();
       peerConnection!.onIceConnectionState = (e) {
      print('connectionState:'+ e.toString());
    };

      
      var offer = data['offer'];

     

      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']));
      print('offer : '+offer['type']);
      
      var answer = await peerConnection!.createAnswer();

       

      await peerConnection!.setLocalDescription(answer!);

    CollectionReference callerCandidateCollectionRef = databaseServices.newCallerCandidateCheck(roomId);

    callerCandidateCollectionRef.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if(change.type == DocumentChangeType.added){
        Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;

          peerConnection?.addCandidate(RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex']
          ));
        }
      });
     });
    
  }

  Future<void> openUserMedia(
  RTCVideoRenderer localVideo,
  RTCVideoRenderer remoteVideo,
  ) async {
    var stream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
  }

  void hangUp(roomId){
   databaseServices.deleteCaller(roomId);
   databaseServices.deleteCalleeCandidates(roomId);
   databaseServices.deleteCallerCandidates(roomId);
   databaseServices.deleteSdp(roomId);
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      print('Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      print('Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      print('ICE connection state change: $state');
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      print("Add remote stream");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }
} 
