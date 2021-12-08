import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';
import 'package:reading_experiment/shared/note_data.dart';
import 'package:reading_experiment/shared/session_data.dart';
import 'package:reading_experiment/shared/text_data.dart';
import 'package:reading_experiment/shared/unlock_request_data.dart';

class DatabaseService {
  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DatabaseService({required this.uid});

  final CollectionReference consentCollection =
      FirebaseFirestore.instance.collection('participantConsent');
  final CollectionReference sessionCollection =
      FirebaseFirestore.instance.collection('sessions');
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference unlockRequestsCollection =
      FirebaseFirestore.instance.collection('unlockRequests');
  final CollectionReference answerCollection =
      FirebaseFirestore.instance.collection('answers');

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
  Future removeUserConsent({BuildContext? context, required String uid}) async {
    try {
      await consentCollection.doc(uid).delete();
    } catch (e) {
      print(e.toString());
      if (context != null) {
        _showErrorToast(context, text: e.toString());
      }
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

  Future _incrementLockouts(String uid) async {
    try {
      await sessionCollection.doc(uid).update({
        'lockOuts': FieldValue.increment(1),
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Stream<List<NoteData>> get notes =>
      notesCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return NoteData(
            id: doc.id,
            author: (doc.data() as Map)['author'],
            kick: (doc.data() as Map)['kick'],
            kickReason: (doc.data() as Map)['kickReason'],
            notes: (doc.data() as Map)['userNotes'],
          );
        }).toList();
      });

  Stream<NoteData?> get userKickStream =>
      notesCollection.doc(uid).snapshots().map((doc) {
        if (doc.exists) {
          return NoteData(
            id: uid,
            kickReason: doc.get('kickReason'),
            kick: doc.get('kick'),
          );
        }
      });

  Future kickUser({required String userUID, required String kickReason}) async {
    try {
      await notesCollection.doc(userUID).set({
        'id': userUID,
        'kick': true,
        'kickReason': kickReason,
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Stream<List<UnlockRequestData>?> get unlockRequests =>
      unlockRequestsCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return UnlockRequestData(
            docID: doc.id,
            uid: (doc.data() as Map)['uid'],
            reason: (doc.data() as Map)['reason'],
            unlock: (doc.data() as Map)['unlock'],
          );
        }).toList();
      });

  Stream<UnlockRequestData?> userUnlockRequest(String docID) {
    return unlockRequestsCollection.doc(docID).snapshots().map((doc) {
      if (doc.exists) {
        return UnlockRequestData(
          docID: docID,
          uid: (doc.data() as Map)['uid'],
          reason: (doc.data() as Map)['reason'],
          unlock: (doc.data() as Map)['unlock'],
        );
      }
    });
  }

  // Stream<UnlockRequestData?> get userUnlockRequest =>
  //     unlockRequestsCollection.doc(uid).snapshots().map((doc) {
  //       if (doc.exists) {
  //         return UnlockRequestData(
  //           uid: doc.id,
  //           unlock: (doc.data() as Map)['unlock'],
  //         );
  //       }
  //     });

  Future addUnlockRequest(UnlockRequestData data) async {
    try {
      var doc = unlockRequestsCollection.doc();
      await doc.set({'uid': data.uid, 'reason': data.reason, 'unlock': false});
      await _incrementLockouts(data.uid);
      return doc.id;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future unlockUser(String docID) async {
    try {
      await unlockRequestsCollection.doc(docID).update({
        'unlock': true,
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future uploadAnswers(
      {required Map firstQuiz, required Map secondQuiz}) async {
    await answerCollection.doc(uid).set({
      'firstQuiz': firstQuiz,
      'secondQuiz': secondQuiz,
    });
  }
}

enum TextNumber {
  firstText,
  secondText,
}

class InfoService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference infoCollection =
      FirebaseFirestore.instance.collection('info');

  final String texts = 'texts';
  final String discovery = 'discovery';

  // get text
  Future<TextData?> getTexts(BuildContext context,
      {void Function()? setFetching, void Function()? setNotFetching}) async {
    try {
      if (setFetching != null) {
        setFetching();
      }

      var result = await infoCollection.doc(texts).get().then((doc) {
        var data = doc.data() as Map;

        return TextData(
            firstText: data['firstText'], secondText: data['secondText']);
      });

      if (setNotFetching != null) {
        setNotFetching();
      }

      return result;
    } catch (e) {
      print(e.toString());
      _showErrorToast(context,
          text:
              'Error Fetching Texts. Please reload and try again.\nIf you are already in the experiment, please exit then reload.');
    }
  }

  Future updateTexts(String textOne, String textTwo) async {
    try {
      await infoCollection.doc(texts).set(
        {
          'firstText': textOne,
          'secondText': textTwo,
        },
      );
    } catch (e) {
      print(e);
      return e;
    }
  }

  Stream<TextData?> get textUpdates =>
      infoCollection.doc(texts).snapshots().map((doc) => TextData(
            firstText: (doc.data() as Map)['firstText'],
            secondText: (doc.data() as Map)['secondText'],
          ));

  Stream<bool?> get discoveryStream => infoCollection
      .doc(discovery)
      .snapshots()
      .map((doc) => doc.get(discovery));

  Future changeDiscovery(bool discovery) =>
      infoCollection.doc(this.discovery).set({this.discovery: discovery});
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
