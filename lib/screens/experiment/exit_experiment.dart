import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/main.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/data.dart';

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

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                barrierColor: Colors.transparent,
                                builder: (context) {
                                  return Container();
                                },
                              );

                              var auth = AuthService();
                              var uid = auth.getUser()!.uid;
                              var database = DatabaseService(uid: uid);

                              // remove user consent
                              dynamic consentResult =
                                  await database.removeUserConsent(
                                      context: context, uid: uid);

                              if (consentResult == null) {
                                // ignore: avoid_init_to_null
                                dynamic sessionResult =
                                    await database.deleteSession();
                                if (sessionResult == null) {
                                  // delete user and their data
                                  dynamic authResult =
                                      await auth.deleteUserAndData(uid: uid);

                                  if (authResult == null) {
                                    AppData.experimentNavKey.currentState!
                                        .popUntil((route) => route.isFirst);

                                    AppData.mainNavKey.currentState!
                                        .popUntil((route) => route.isFirst);
                                  } else {
                                    setState(() => loading = false);
                                    Navigator.pop(context);

                                    _showToast(context,
                                        text: auth
                                            .getError(authResult.toString()));
                                  }
                                  // ignore: dead_code
                                } else {
                                  setState(() => loading = false);
                                  Navigator.pop(context);

                                  _showToast(context,
                                      text: auth
                                          .getError(sessionResult.toString()));
                                }
                              } else {
                                setState(() => loading = false);
                                Navigator.pop(context);

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

/*
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
  // bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 35,
      bottom: 35,
      child: ClickableText(
        text: 'Exit Experiment',
        onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              content: Column(
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
                      // setState(() => loading = true);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            content: SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          );
                        },
                      );
                      var auth = AuthService();
                      var uid = auth.getUser()!.uid;
                      var database = DatabaseService(uid: uid);

                      // remove user consent
                      dynamic consentResult =
                          await database.removeUserConsent(context, uid: uid);

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
                            // setState(() => loading = false);
                            Navigator.of(context).pop();
                            _showToast(context,
                                text: auth.getError(authResult.toString()));
                          }
                          // ignore: dead_code
                        } else {
                          // setState(() => loading = false);
                          Navigator.of(context).pop();
                          _showToast(context,
                              text: auth.getError(sessionResult.toString()));
                        }
                      } else {
                        // setState(() => loading = false);
                        Navigator.of(context).pop();
                        _showToast(context,
                            text: auth.getError(consentResult.toString()));
                      }
                    },
                  ),
                ],
              ),
            );
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
*/