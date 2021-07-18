import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseService({required this.uid});

  final CollectionReference textCollection =
      FirebaseFirestore.instance.collection('texts');
}
