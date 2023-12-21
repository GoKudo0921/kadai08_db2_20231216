import 'package:chat_demo/firestore/room_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';
import '../utils/shared_prefs.dart';

class UserFirestore{
  static final FirebaseFirestore _firebaseFirestoreInstance = FirebaseFirestore.instance;
  static final _userCollection = _firebaseFirestoreInstance.collection('user');
  static Future<String?> insertNewAccount() async{
    try {
      final newDoc = await _userCollection.add({
        'name': '名無し',
        'imagePath':'https://th.bing.com/th/id/OIP.imKPRIqMaYxROss6L0qBwQAAAA?w=140&h=150&c=7&r=0&o=5&dpr=1.5&pid=1.7'
      });
      print('アカウント作成完了');
      return newDoc.id;

    } catch(e) {
      print('アカウント作成失敗 ===== $e' );
      return null;
    }
  }

  static Future<void> createUser() async{
    final myUid = await UserFirestore.insertNewAccount();
    if(myUid != null) {
      await RoomFirestore.createRoom(myUid);
      await SharedPrefs.setUid(myUid);
    }
  }

  static Future<List<QueryDocumentSnapshot>?> fetchUsers() async{
    try{
      final snapshot = await _userCollection.get();
      snapshot.docs.forEach((doc) {
      });
      return snapshot.docs;
    }
    catch(e){
      print('ユーザ情報の取得失敗 ------${e}');
      return null;
    }
  }
  static Future<User?> fetchMyProfile(String uid) async{
    try{
      String uid = SharedPrefs.fetchUid()!;
      final snapshot = await _userCollection.doc(uid).get();
      User user = User(
        name: snapshot.data()!['name'],
        imagePath: snapshot.data()!['imagePath'],
        uid: uid
      );
      return user;
    } catch(e) {
      print('自分のユーザ情報の取得失敗-----${e}');
      return null;
    }
  }
}