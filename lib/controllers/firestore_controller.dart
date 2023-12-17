import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../utils/logger.dart';

class FirestoreController extends GetxController {
  late final FirebaseFirestore _firestore;
  RxString updateMessage = RxString('');
  RxString messageID = RxString('');
  RxBool isUpdate = RxBool(false);

  Rx<bool> _isLoading = Rx(false);
  Rx<bool> get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    _firestore = FirebaseFirestore.instance;
  }

  void sendMessage({required String messageText, required String email}) async {
    try {
      // getting collection ID from cloud firestore
      await _firestore.collection('messages').add({
        "createdDate": FieldValue.serverTimestamp(),
        "updatedDate": FieldValue.serverTimestamp(),
        "text": messageText,
        "sender": email,
      });
    } catch (e) {
      'sendMessage err: $e'.log();
    } finally {
      'sendMessage finally'.log();
    }
  }

  Future<void> getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      message.data().log();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messageStream() {
    return _firestore.collection('messages').orderBy("createdDate", descending: false).snapshots();
  }

  void clickMessage({required String msg, required String msgID}) async {
    updateMessage(msg);
    messageID(msgID);
    isUpdate(true);
    update();
  }

  Future<void> editMessage({required String msgID, required String updatedMsg}) async {
    try {
      _isLoading(true);
      await Future.delayed(const Duration(seconds: 2), () {});
      'updatedMsg: $updatedMsg'.log();
      await _firestore.collection('messages').doc(msgID).update({
        "text": updatedMsg,
      });
    } catch (e) {
      'editMessage err: $e'.log();
    } finally {
      _isLoading(false);
    }
  }

  Future<void> deleteMessage({required String docID}) async {
    try {
      await Future.delayed(const Duration(seconds: 2), () {});
      await _firestore.collection('messages').doc(docID).delete();
    } catch (e) {
      'deleteMessage err: $e'.log();
    } finally {
      'deleteMessage finally'.log();
    }
  }

  void clearUpdateMessage() {
    updateMessage('');
    messageID('');
    isUpdate(false);
    update();
  }
}
