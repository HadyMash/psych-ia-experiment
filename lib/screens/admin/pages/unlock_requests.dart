import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/screens/admin/assets/unlock_request.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/unlock_request_data.dart';

class UnlockRequests extends StatelessWidget {
  const UnlockRequests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stream =
        DatabaseService(uid: AuthService().getUser()!.uid).unlockRequests;

    stream.listen((data) {
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
            const Text(
              'Unlock Requests updated.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 15),
            TextButton(
              child: const Text('Show'),
              onPressed: () {
                // TODO navigate to unlock requests page
                fToast.removeCustomToast();
              },
            ),
            const SizedBox(width: 5),
            TextButton(
              child: const Text('Ok'),
              onPressed: () => fToast.removeCustomToast(),
            ),
          ],
        ),
      );

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(days: 1),
      );
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Unlock Requests'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<UnlockRequestData>?>(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data.isEmpty) {
            return const Center(child: Text('There are no Unlock Requests'));
          }

          var data = snapshot.data as List<UnlockRequestData>?;

          if (data != null && data.isNotEmpty) {
            final groupedRequests =
                groupBy(data, (UnlockRequestData data) => data.unlock);

            final lockedRequests = groupedRequests[false] ?? [];
            final unlockedRequests = groupedRequests[true] ?? [];

            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      'Locked',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: lockedRequests.length,
                //     itemBuilder: (context, index) {
                //       var requestData = lockedRequests[index];

                //       return UnlockRequest(
                //         uid: requestData.uid,
                //         reason: requestData.reason ?? '',
                //         unlock: requestData.unlock ?? false,
                //       );
                //     },
                //   ),
                // ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var requestData = lockedRequests[index];

                      return UnlockRequest(
                        docID: requestData.docID!,
                        uid: requestData.uid,
                        reason: requestData.reason ?? '',
                        unlock: requestData.unlock ?? false,
                      );
                    },
                    childCount: lockedRequests.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Text(
                      'Unlocked',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: unlockedRequests.length,
                //     itemBuilder: (context, index) {
                //       var requestData = unlockedRequests[index];

                //       return UnlockRequest(
                //         uid: requestData.uid,
                //         reason: requestData.reason ?? '',
                //         unlock: requestData.unlock ?? true,
                //       );
                //     },
                //   ),
                // ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var requestData = unlockedRequests[index];

                      return UnlockRequest(
                        docID: requestData.docID!,
                        uid: requestData.uid,
                        reason: requestData.reason ?? '',
                        unlock: requestData.unlock ?? false,
                      );
                    },
                    childCount: unlockedRequests.length,
                  ),
                ),
              ],
            );

            // return Column(
            //   mainAxisSize: MainAxisSize.max,
            //   children: [
            //     const SizedBox(height: 10),
            //     const Text(
            //       'Locked',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 26,
            //       ),
            //     ),
            //     const SizedBox(height: 20),
            //     Expanded(
            //       child: ListView.builder(
            //         itemCount: lockedRequests.length,
            //         itemBuilder: (context, index) {
            //           var requestData = lockedRequests[index];

            //           return UnlockRequest(
            //             uid: requestData.uid,
            //             reason: requestData.reason ?? '',
            //             unlock: requestData.unlock ?? false,
            //           );
            //         },
            //       ),
            //     ),
            //     const Text(
            //       'Unlocked',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 26,
            //       ),
            //     ),
            //     const SizedBox(height: 20),
            //     Expanded(
            //       child: ListView.builder(
            //         itemCount: unlockedRequests.length,
            //         itemBuilder: (context, index) {
            //           var requestData = unlockedRequests[index];

            //           return UnlockRequest(
            //             uid: requestData.uid,
            //             reason: requestData.reason ?? '',
            //             unlock: requestData.unlock ?? true,
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // );
          }

          return const Center(child: Text('Error'));
        },
      ),
    );
  }
}
