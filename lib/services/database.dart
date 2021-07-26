import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DatabaseService {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseService({required this.uid});

  final CollectionReference textCollection =
      FirebaseFirestore.instance.collection('texts');

  _showErrorToast(BuildContext context, {required String text}) {
    late FToast fToast;

    fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[850],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_rounded, color: Colors.red[700]),
          const SizedBox(
            width: 12.0,
          ),
          Text(text.toString(), style: const TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 6),
    );
  }

  // add user consent to database
  Future addUserConsent(BuildContext context, {required String uid}) async {
    try {
      await firestore.collection('participantConsent').doc(uid).set(
        {
          'consent': true,
        },
      );
    } catch (e) {
      print(e.toString());
      _showErrorToast(context, text: e.toString());
    }
  }

  // remove user from consent
  Future removeUserConsent(BuildContext context, {required String uid}) async {
    try {
      await firestore.collection('participantConsent').doc(uid).delete();
    } catch (e) {
      print(e.toString());
      _showErrorToast(context, text: e.toString());
    }
  }

  // TODO create user session

  // get text
  Future<String?> getText(BuildContext context,
      {required String textName}) async {
    try {
      return await firestore.doc('texts/$textName').get().then(
            (doc) => doc.get('text'),
          );
    } catch (e) {
      _showErrorToast(context, text: e.toString());
      return null;
    }
  }

  // TODO add answer to text
}
