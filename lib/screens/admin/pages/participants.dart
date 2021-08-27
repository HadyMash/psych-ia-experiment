import 'package:flutter/material.dart';
import 'package:reading_experiment/screens/admin/assets/session.dart';
import 'package:reading_experiment/screens/admin/assets/sessions_header.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/session_data.dart';

class Participants extends StatefulWidget {
  const Participants({Key? key}) : super(key: key);

  @override
  _ParticipantsState createState() => _ParticipantsState();
}

class _ParticipantsState extends State<Participants> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late Stream<List<SessionData>> sessionStream;
  List<SessionData> currentSessions = [];

  @override
  void initState() {
    super.initState();
    sessionStream =
        DatabaseService(uid: AuthService().getUser()!.uid).userSessions;

    sessionStream.listen((List<SessionData> sessions) {
      List<SessionData> newSessions = [];
      List<SessionData> existingSessions = sessions;
      List<int> existingSessionIndices = [];
      List<int> deletedSessionIndices = [];

      // determine which messages are new and which are users already
      // displayed and which are deleted users.
      for (int i = 0; i < sessions.length; i++) {
        // if any element in the current sessions doesn't have a uid matching
        // the current `session` in the for loop.
        // aka check if an element in `sessions` doesn't exist in `currentSessions`.
        if (!currentSessions
            .any((currentSession) => sessions[i].uid == currentSession.uid)) {
          newSessions.add(sessions[i]);
          existingSessions.remove(sessions[i]);
        } else {
          // if the element does exist, store it's index
          existingSessionIndices.add(i);
        }
      }
      print(
          'existing sessions: ${existingSessions.length}, indices list: ${existingSessionIndices.length}');
      for (int i = 0; i < currentSessions.length; i++) {
        // if any element in the sesssions doesn't have a uid matching the
        // `current session` in the for loop.
        // aka check if an element in `currentSessions` doesn't exist in `sessions`.
        if (!sessions.any((element) => currentSessions[i].uid == element.uid)) {
          deletedSessionIndices.add(i);
        }
      }

      // * add new sessions to the animated list
      for (var newSession in newSessions) {
        currentSessions.add(newSession);

        if (_listKey.currentState != null) {
          _listKey.currentState!.insertItem(currentSessions.length - 1,
              duration: const Duration(milliseconds: 500));
        }
      }

      // * update existing sessions
      for (int i = 0; i < existingSessionIndices.length; i++) {
        currentSessions[existingSessionIndices[i]] = existingSessions[i];
      }

      // * remove deleted sessions
      for (int i = 0; i < deletedSessionIndices.length; i++) {
        var session = currentSessions[deletedSessionIndices[i]];
        if (_listKey.currentState != null) {
          _listKey.currentState!.removeItem(
            deletedSessionIndices[i],
            (context, animation) => SizeTransition(
              sizeFactor: CurvedAnimation(
                curve: Curves.easeInOut,
                parent: animation,
              ),
              child: Session(
                uid: session.uid,
                progress: session.progress,
                lockOuts: session.lockOuts,
                group: session.group,
              ),
            ),
          );
        }
        currentSessions.removeAt(deletedSessionIndices[i]);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // TODO Add total participant count to app bar.
      appBar: AppBar(
        title: const Text('Participants'),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          Center(child: Text('${currentSessions.length} Participants')),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            // Headers
            SessionsHeader(width: width),
            const SizedBox(height: 5),
            Container(
              height: 2,
              color: Colors.grey,
            ),
            // Sessions
            currentSessions.isNotEmpty
                ? Expanded(
                    child: AnimatedList(
                      key: _listKey,
                      initialItemCount: currentSessions.length,
                      itemBuilder: (context, index, anim) {
                        return SizeTransition(
                          sizeFactor: CurvedAnimation(
                              curve: Curves.easeInOut, parent: anim),
                          child: Session(
                            key: ValueKey(currentSessions[index].uid),
                            uid: currentSessions[index].uid,
                            progress: currentSessions[index].progress,
                            lockOuts: currentSessions[index].lockOuts,
                            group: currentSessions[index].group,
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(height: 30),
                        Text('There are no currently active sessions'),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );

    // return StreamBuilder(
    //   stream: sessionStream,
    //   builder: (context, snapshot) {
    //     return Scaffold(
    //       backgroundColor: Colors.transparent,
    //       appBar: AppBar(
    //         title: const Text('Participants'),
    //         centerTitle: false,
    //         automaticallyImplyLeading: false,
    //       ),
    //       body: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 20),
    //         child: Column(
    //           mainAxisSize: MainAxisSize.max,
    //           children: [
    //             const SizedBox(height: 10),
    //             // Headers
    //             Row(
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 const Flexible(flex: 2, child: Center(child: Text('Name'))),
    //                 Flexible(
    //                   flex: 3,
    //                   child: Center(
    //                     child: Row(
    //                       mainAxisSize: MainAxisSize.min,
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         SizedBox(
    //                           width: 0.2 * width,
    //                           child: const Center(child: Text('Progress (%)')),
    //                         ),
    //                         const SizedBox(width: 40),
    //                         const SizedBox(
    //                           width: 100,
    //                           child: Center(child: Text('Screen')),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //                 const Flexible(
    //                     flex: 1, child: Center(child: Text('Group'))),
    //                 const Flexible(
    //                     flex: 1, child: Center(child: Text('Lock Outs'))),
    //                 const Flexible(flex: 1, child: Center(child: Text('Kick'))),
    //               ],
    //             ),
    //             const SizedBox(height: 5),
    //             Container(
    //               height: 2,
    //               color: Colors.grey,
    //             ),
    //             // Sessions
    //             (snapshot.connectionState == ConnectionState.active)
    //                 ? (((snapshot.data ?? []) as List).isNotEmpty
    //                     ? Expanded(
    //                         child: ListView.builder(
    //                           itemCount: ((snapshot.data ?? []) as List).length,
    //                           itemBuilder: (context, index) {
    //                             return Session(
    //                               key: ValueKey(((snapshot.data as List)[index]
    //                                       as SessionData)
    //                                   .uid),
    //                               uid: ((snapshot.data as List)[index]
    //                                       as SessionData)
    //                                   .uid,
    //                               progress: ((snapshot.data as List)[index]
    //                                       as SessionData)
    //                                   .progress,
    //                               lockOuts: ((snapshot.data as List)[index]
    //                                       as SessionData)
    //                                   .lockOuts,
    //                               group: ((snapshot.data as List)[index]
    //                                       as SessionData)
    //                                   .group,
    //                             );
    //                           },
    //                         ),
    //                       )
    //                     : const Center(
    //                         child:
    //                             Text('There are no currently active sessions'),
    //                       ))
    //                 : const Center(
    //                     child: CircularProgressIndicator(),
    //                   ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
