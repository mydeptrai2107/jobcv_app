
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future signInFunction(UserModel user) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.userId)
        .set({
      'name': user.firstName + user.lastName,
      'image': user.avatar,
      'uid': user.userId,
      'date': DateTime.now()
    });
  }

}
