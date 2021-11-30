import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reading_experiment/screens/admin/admin_login.dart';
import 'package:reading_experiment/screens/admin/admin_panel.dart';
import 'package:reading_experiment/screens/experiment/experiment.dart';
import 'package:reading_experiment/screens/experiment/finish.dart';
import 'package:reading_experiment/screens/experiment/intro.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/data.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';
import 'package:reading_experiment/shared/text_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as url;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ignore: constant_identifier_names
  const bool USE_EMULATOR = false;

  // ignore: dead_code
  if (USE_EMULATOR) {
    // [Firestore | localhost:8080]
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );

    // [Authentication | localhost:9099]
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<TextData?>(
      create: (_) => InfoService().getTexts(context),
      initialData: null,
      lazy: false,
      child: MaterialApp(
        navigatorKey: AppData.mainNavKey,
        home: const Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _showToast(BuildContext context, {required String text}) {
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final User? user = AuthService().getUser();

      if (user != null) {
        if (user.isAnonymous) {
          // go to experiment
          ExperimentProgress? progress = await getExperimentProgress();
          if (progress == null) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Experiment(Agreement(uid: user.uid))));
          } else {
            switch (progress) {
              case ExperimentProgress.agreement:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Experiment(Agreement(uid: user.uid))));
                break;
              case ExperimentProgress.experimentInfo:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Experiment(Explanation(uid: user.uid))));
                break;
              case ExperimentProgress.areYouReady:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Experiment(AreYouReady(uid: user.uid))));
                break;
              case ExperimentProgress.firstText:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Experiment(FirstText(uid: user.uid))));
                break;
              case ExperimentProgress.firstQuiz:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Experiment(
                    TimeIsUp(
                      uid: user.uid,
                      textNumber: 1,
                    ),
                  ),
                ));
                break;
              case ExperimentProgress.secondText:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Experiment(SecondText(uid: user.uid))));
                break;
              case ExperimentProgress.secondQuiz:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Experiment(
                    TimeIsUp(
                      uid: user.uid,
                      textNumber: 2,
                    ),
                  ),
                ));
                break;
              case ExperimentProgress.finish:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Experiment(Finish()),
                ));
                break;
              case ExperimentProgress.error:
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Experiment(Agreement(uid: user.uid))));
                break;
            }
          }
        } else {
          // go to admin panel
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminPanel()));
        }
      }
    });
  }

  final Stream<bool?> stream = InfoService().discoveryStream;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return StreamBuilder<bool?>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && (snapshot.data as bool) == true) {
          return Scaffold(
            extendBody: true,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Get Started'),
                    onPressed: () async {
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
                              height: 100,
                              width: 100,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        },
                      );

                      var instance = await SharedPreferences.getInstance();
                      await instance.remove('experimentAppBarProgress');

                      var completed = instance.getBool('completed');

                      // * check if they already completed the experiment to avoid duplicate results.
                      if (completed != true) {
                        final AuthService _auth = AuthService();
                        dynamic currentUser = _auth.getUser();
                        if (currentUser != null) {
                          await _auth.deleteUserAndData(
                              uid: AuthService().getUser()!.uid);
                        }

                        dynamic result = await _auth.logInAnonymously();
                        if (result is User) {
                          await DatabaseService(uid: _auth.getUser()!.uid)
                              .makeSession(uid: _auth.getUser()!.uid);
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Experiment(
                                  Agreement(uid: result.uid.toString()))));
                        } else {
                          Navigator.pop(context);
                          _showToast(context,
                              text: _auth.getError(result.toString()));
                        }
                      } else {
                        Navigator.pop(context);
                        _showToast(context,
                            text:
                                'You already completed this experiment. Thank you');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Repository'),
                    onPressed: () async {
                      if (await url.canLaunch(
                          'https://github.com/HadyMash/psych-ia-experiment')) {
                        url.launch(
                            'https://github.com/HadyMash/psych-ia-experiment');
                      } else {
                        _showToast(context, text: 'An error has occured.');
                      }
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SizedBox(
              height: height * 0.1,
              child: Center(
                child: ClickableText(
                  text: 'Go to Admin Portal',
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return const AdminLogin();
                      },
                      transitionsBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child) {
                        return Align(
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          extendBody: true,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Experiment not discoverable'),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Repository'),
                  onPressed: () async {
                    if (await url.canLaunch(
                        'https://github.com/HadyMash/psych-ia-experiment')) {
                      url.launch(
                          'https://github.com/HadyMash/psych-ia-experiment');
                    } else {
                      _showToast(context, text: 'An error has occured.');
                    }
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: height * 0.1,
            child: Center(
              child: ClickableText(
                text: 'Go to Admin Portal',
                onTap: () => Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return const AdminLogin();
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ClickableText extends StatefulWidget {
  final String text;
  final void Function() onTap;

  const ClickableText({required this.text, required this.onTap, Key? key})
      : super(key: key);

  @override
  ClickableTextState createState() => ClickableTextState();
}

class ClickableTextState extends State<ClickableText> {
  Color textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        onEnter: (_) => setState(() => textColor = Colors.blue),
        onExit: (_) => setState(() => textColor = Colors.black),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Text(
            widget.text,
            style: TextStyle(
              color: textColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
