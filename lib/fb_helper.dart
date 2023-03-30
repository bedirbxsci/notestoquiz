import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


var db = FirebaseFirestore.instance;
Map<String, dynamic> userData = {};

void init() async {
  userData = await getUserData();
}

Future<Map<String, dynamic>> getUserData() async {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  final querySnapshot = await db
      .collection("users")
      .where("email", isEqualTo: currentUserEmail)
      .get();
  return querySnapshot.docs.first.data();
}


Future<List<Map<String, dynamic>>> getAllQuestionsForUserByEmail() async {
  final email = FirebaseAuth.instance.currentUser?.email;
  QuerySnapshot<Map<String, dynamic>> userSnapshot = await db
      .collection('users')
      .where('email', isEqualTo: email)
      .get();

  if (userSnapshot.docs.isNotEmpty) {
    String userId = userSnapshot.docs.first.id;

    // Fetch all the question documents for the user
    QuerySnapshot<Map<String, dynamic>> questionsSnapshot = await db
        .collection('users')
        .doc(userId)
        .collection('questions')
        .get();

    List<Map<String, dynamic>> questionsData = questionsSnapshot.docs
        .map((doc) => doc.data())
        .toList();

    return questionsData;
  } else {
    throw Exception('User not found');
  }
}


