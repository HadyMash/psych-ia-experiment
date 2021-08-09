import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/main.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';

class ExitExperiment extends StatefulWidget {
  const ExitExperiment({Key? key}) : super(key: key);

  @override
  _ExitExperimentState createState() => _ExitExperimentState();
}

class _ExitExperimentState extends State<ExitExperiment> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 35,
      bottom: 35,
      child: ClickableText(
        text: 'Exit Experiment',
        onTap: () => showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                content: loading == true
                    ? const SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Exit Experiment',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Are you sure you want to exit the experiment?\nThis will delete all of your data. This cannot be reversed.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text('Exit'),
                            onPressed: () async {
                              setState(() => loading = true);
                              var auth = AuthService();
                              var uid = auth.getUser()!.uid;
                              var database = DatabaseService(uid: uid);

                              // remove user consent
                              dynamic consentResult = await database
                                  .removeUserConsent(context, uid: uid);

                              if (consentResult == null) {
                                // TODO delete user session
                                // ignore: avoid_init_to_null
                                dynamic sessionResult = null;
                                if (sessionResult == null) {
                                  // delete user and their data
                                  dynamic authResult =
                                      await auth.deleteUserAndData(uid: uid);

                                  if (authResult == null) {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  } else {
                                    setState(() => loading = false);
                                    _showToast(context,
                                        text: auth
                                            .getError(authResult.toString()));
                                  }
                                  // ignore: dead_code
                                } else {
                                  setState(() => loading = false);
                                  _showToast(context,
                                      text: auth
                                          .getError(sessionResult.toString()));
                                }
                              } else {
                                setState(() => loading = false);
                                _showToast(context,
                                    text: auth
                                        .getError(consentResult.toString()));
                              }
                            },
                          ),
                        ],
                      ),
              );
            });
          },
        ),
      ),
    );
  }
}

void _showToast(BuildContext context, {required String text}) {
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
