import 'package:chatty/common/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDetailsProvider = StateNotifierProvider<UserDetails, bool>((ref) {
  return UserDetails(firestore: FirebaseFirestore.instance);
});

class UserDetails extends StateNotifier<bool> {
  FirebaseFirestore _firestore;
  UserDetails({required FirebaseFirestore firestore})
      : _firestore = firestore,
        super(false);

  Future<String?> getDisplayPhoto(
      BuildContext context, String userDocId) async {
    var photoUrl =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQNvWDvQb_rCtRL-p_w329CtzHmfzfWP0FIw&usqp=CAU';
    try {
      await _firestore
          .collection('users')
          .doc(userDocId)
          .get()
          .then((value) => {
                if (value.data() != null &&
                    value.data()!.containsKey('profilePhoto'))
                  {photoUrl = value.data()!['profilePhoto']}
                else
                  photoUrl =
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQQNvWDvQb_rCtRL-p_w329CtzHmfzfWP0FIw&usqp=CAU'
              });
      return photoUrl;
    } on FirebaseException catch (e) {
      showSnackbar(context, e.toString());
      return photoUrl;
    }
  }
}
