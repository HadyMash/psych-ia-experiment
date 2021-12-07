import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/screens/experiment/experiment.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/data.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _showToast(BuildContext context) {
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
        Icon(Icons.check_circle_rounded, color: Colors.green[700]),
        const SizedBox(
          width: 12.0,
        ),
        const Text(
          'Copied to Clipboard',
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 3),
  );
}

class Agreement extends StatefulWidget {
  final String uid;
  const Agreement({required this.uid, Key? key}) : super(key: key);

  @override
  _AgreementState createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  bool offstage = true;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    setExperimentProgress(ExperimentProgress.agreement);
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction - Agreement'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            _popExperiment(context);
          },
        ),
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
                      _showToast(context);
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
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Anonymity',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please note that all of your data is recorded under the UID you see in the app bar. We have no way of identifying you. No one inside or outside the experiment will be able to identify you from your data. For this reason, please keep note of your UID. You can copy it and paste it somewhere after the experiment.',
                      style: TextStyle(height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Use of Data',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your data will be used for the purpose of this experiment. You will be debriefed at the end of the experiment and you may withdraw at any point. Before starting you can press the back arrow and after starting there will be an "exit experiment" button available at all times. The data collected will be used for research purposes only.',
                      style: TextStyle(height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Cheating',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'We kindly ask of you not to cheat. Cheating will not benefit you but affect the results of this experiment. If you go to another window or tab you will be locked out and must request to be unlocked from one of the researchers. You must provide a good reason for your lock out and you must provide the researchers with your UID for them to unlock you. In such a case they will be able to identify you.',
                      style: TextStyle(height: 1.5),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 280,
                            child: Text(
                                'I agree to take part in this experiment and allow the researchers to use my data for the experiment\'s declared purposes.'),
                          ),
                          const SizedBox(width: 20),
                          Checkbox(
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                                offstage = !value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Offstage(
                        offstage: offstage, child: const SizedBox(height: 20)),
                    Offstage(
                      offstage: offstage,
                      child: Center(
                        child: ElevatedButton(
                          child: const Text('Next'),
                          onPressed: () async {
                            String uid = AuthService().getUser()!.uid;

                            dynamic result = await DatabaseService(uid: uid)
                                .addUserConsent(context, uid: uid);

                            if (result == null) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Explanation(uid: widget.uid)));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Explanation extends StatelessWidget {
  final String uid;
  const Explanation({required this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    setExperimentProgress(ExperimentProgress.experimentInfo);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction - Explanation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            _popExperiment(context);
          },
        ),
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
                    child: SelectableText(uid),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: uid));
                      _showToast(context);
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'The Experiment',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'You are going to read 2 texts. After you read each text, you are going to take a quiz on the information of the text. You may not leave the experiment page for the entire duration of the experiment.\n*Sources for the texts will be available at the end of the experiment.',
                    style: TextStyle(height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => AreYouReady(uid: uid))),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AreYouReady extends StatefulWidget {
  final String uid;

  const AreYouReady({required this.uid, Key? key}) : super(key: key);

  @override
  _AreYouReadyState createState() => _AreYouReadyState();
}

class _AreYouReadyState extends State<AreYouReady> {
  int? groupNumber;

  @override
  void initState() {
    super.initState();
    setExperimentProgress(ExperimentProgress.areYouReady);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ready to Start'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            await _popExperiment(context);
          },
        ),
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
                      _showToast(context);
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are You Ready?',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please select the group assigned to you below.\nOnce you press \'Start\' the experiment will begin. You will not be able to pause once started. The experiment should take about 20 minutes. You will have 5 minutes for each text and as long as you\'d like to answer each quiz. Good luck!',
                    style: TextStyle(height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<int?>(
                    value: groupNumber,
                    onChanged: (int? number) {
                      setState(() => groupNumber = number);
                      AppData.groupNumber = number;
                    },
                    items: <int>[1, 2].map<DropdownMenuItem<int>>(
                      (int number) {
                        return DropdownMenuItem<int>(
                          value: number,
                          child: Text('Group $number'),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20),
                  Offstage(
                    offstage: groupNumber == null,
                    child: Center(
                      child: ElevatedButton(
                        child: const Text('Start'),
                        onPressed: () async {
                          await DatabaseService(
                                  uid: AuthService().getUser()!.uid)
                              .setGroupNumber(groupNumber!);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      FirstText(uid: widget.uid)));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _popExperiment(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Container();
    },
  );

  var instance = await SharedPreferences.getInstance();
  instance.remove('experimentAppBarProgress');

  AuthService auth = AuthService();
  DatabaseService database = DatabaseService(uid: auth.getUser()!.uid);

  await setExperimentProgress(ExperimentProgress.agreement);

  await database.removeUserConsent(context: context, uid: auth.getUser()!.uid);

  await database.deleteSession();

  await auth.deleteUser();
  AppData.experimentNavKey.currentState?.popUntil((route) => route.isFirst);
  AppData.mainNavKey.currentState?.popUntil((route) => route.isFirst);
}
