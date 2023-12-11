import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  late final FirebaseFirestore _firestore;

  @override
  void onInit() {
    super.onInit();
    _firestore = FirebaseFirestore.instance;
  }

  void sendMessage({required String messageText, required String email}) {
    // getting collection ID from cloud firestore
    _firestore.collection('messages').add({
      "text": messageText,
      "sender": email,
    });
  }

  Future<void> getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream() {
    return _firestore.collection('messages').snapshots();
  }
}
