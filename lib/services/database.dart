import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';
import 'package:reading_experiment/shared/session_data.dart';
import 'package:reading_experiment/shared/text_data.dart';

class DatabaseService {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseService({required this.uid});

  final CollectionReference consentCollection =
      FirebaseFirestore.instance.collection('participantConsent');

  final CollectionReference sessionCollection =
      FirebaseFirestore.instance.collection('sessions');

  // * Participant

  // add user consent to database
  Future addUserConsent(BuildContext context, {required String uid}) async {
    try {
      await consentCollection.doc(uid).set(
        {
          'consent': true,
        },
      );
    } catch (e) {
      print(e.toString());
      _showErrorToast(context, text: e.toString());
      return e;
    }
  }

  // remove user from consent
  Future removeUserConsent(BuildContext context, {required String uid}) async {
    try {
      await consentCollection.doc(uid).delete();
    } catch (e) {
      print(e.toString());
      _showErrorToast(context, text: e.toString());
      return e;
    }
  }

  // checks if the user has a currently active session
  Future<bool> sessionExists() async {
    return sessionCollection.doc(uid).get().then((doc) => doc.exists);
  }

  // make a new session
  makeSession({required String uid}) async {
    try {
      await sessionCollection.doc(uid).set({
        'uid': uid,
        'lockOuts': 0,
        'progress': EnumToString.convertToString(ExperimentProgress.agreement),
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // set group number
  setGroupNumber(int number) async {
    try {
      await sessionCollection.doc(uid).update({
        'group': number,
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // update the session progress
  updateSessionProgress(ExperimentProgress progress) async {
    try {
      await sessionCollection.doc(uid).update({
        'progress': EnumToString.convertToString(progress),
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // delete the user's session
  Future deleteSession() async {
    try {
      await sessionCollection.doc(uid).delete();
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // * Admin
  Stream<List<SessionData>> get userSessions =>
      sessionCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((QueryDocumentSnapshot doc) {
          Map data = doc.data() as Map;
          return SessionData(
            uid: data['uid'],
            progress: EnumToString.fromString(
                    ExperimentProgress.values, data['progress']) ??
                ExperimentProgress.error,
            lockOuts: data['lockOuts'],
            group: data['group'],
          );
        }).toList();
      });
}

enum TextNumber {
  firstText,
  secondText,
}

class TextService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference textCollection =
      FirebaseFirestore.instance.collection('texts');

  // get text
  Future<TextData?> getTexts() async {
    try {
      String firstText = await textCollection
          .doc('firstText')
          .get()
          .then((doc) => doc.get('text'));
      String secondText = await textCollection
          .doc('secondText')
          .get()
          .then((doc) => doc.get('text'));

      return TextData(
        firstText: firstText,
        secondText: secondText,
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

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
