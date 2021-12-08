import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/screens/experiment/experiment.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/data.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class ExperimentOver extends StatefulWidget {
  final String uid;
  const ExperimentOver({Key? key, required this.uid}) : super(key: key);

  @override
  State<ExperimentOver> createState() => _ExperimentOverState();
}

class _ExperimentOverState extends State<ExperimentOver> {
  void _finish() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('completed', true);

    print(AppData.quizOneAnswers);
    print(AppData.quizTwoAnswers);
    DatabaseService(uid: AuthService().getUser()!.uid).uploadAnswers(
      firstQuiz: AppData.quizOneAnswers,
      secondQuiz: AppData.quizTwoAnswers,
    );
  }

  void _deleteUserAndSession() async {
    await DatabaseService(uid: AuthService().getUser()!.uid).deleteSession();
    await AuthService().deleteUser();
  }

  @override
  void initState() {
    super.initState();
    setExperimentProgress(ExperimentProgress.finish);
    _finish();
    _deleteUserAndSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiment Over'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('ID: '),
                  Theme(
                    data: ThemeData(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionColor: Colors.amber[700],
                      ),
                    ),
                    child: SelectableText(widget.uid),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: widget.uid));
                      showClipboardToast(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  'Thank you for participating in this experiment and for your precious time!\n\nWe really appreicate it! Please copy the UID above and save it somewhere safe in case you would like to withdraw from the experiment and delete your data. You may now go to another tab, window or application and you can close this tab. Below are the sources for the texts used in this experiment.\nPlease wait for the researchers to debrief you on this experiment\'s nature and purpose.'),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                      child: const Text('Text 1'),
                      onPressed: () async {
                        const String textUrl =
                            'https://www.space.com/amp/17661-theory-general-relativity.html';
                        if (await url.canLaunch(textUrl)) {
                          url.launch(textUrl);
                        } else {
                          _showErrorToast(context,
                              text: 'An error has occured.');
                        }
                      }),
                  ElevatedButton(
                      child: const Text('Text 2'),
                      onPressed: () async {
                        const String textUrl =
                            'https://app.kognity.com/study/app/psychology-sl-fe2019/sociocultural-approach-to-understanding-behaviour/the-individual-and-the-group/social-cognitive-theory';
                        if (await url.canLaunch(textUrl)) {
                          url.launch(textUrl);
                        } else {
                          _showErrorToast(context,
                              text: 'An error has occured.');
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
