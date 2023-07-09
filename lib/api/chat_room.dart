import 'package:chatty/common/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomProvider = StateNotifierProvider<ChatRoom, bool>((ref) {
  return ChatRoom(firestore: FirebaseFirestore.instance);
});

class ChatRoom extends StateNotifier<bool> {
  final FirebaseFirestore _firestore;
  ChatRoom({required FirebaseFirestore firestore})
      : _firestore = firestore,
        super(false);

  Future<bool> doesChatExist(String thisUser, String otherUser) async {
    final DocumentReference documentRef =
        _firestore.collection('chats').doc('$thisUser$otherUser');

    final DocumentSnapshot documentSnapshot = await documentRef.get();
    return documentSnapshot.exists;
  }

  Future<DocumentReference> createOneToOneChatRoom({
    required BuildContext context,
    required String thisUser,
    required String otherUser,
  }) async {
    if (await doesChatExist(thisUser, otherUser)) {
      return _firestore.collection('chats').doc('$thisUser$otherUser');
    } else if (await doesChatExist(otherUser, thisUser)) {
      return _firestore.collection('chats').doc('$otherUser$thisUser');
    } else {
      return _firestore.collection('chats').doc('$thisUser$otherUser');
    }
  }

  void addMessage(
      {required senderId,
      required DocumentReference documentReference,
      required String message,
      required BuildContext context}) async {
    try {
      state = true;
      documentReference
          .update({
            'message': FieldValue.arrayUnion([message]),
          })
          .then((value) => state = false)
          .catchError((e) {
            state = false;
            showSnackbar(context, e.toString());
          });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
}
