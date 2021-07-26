import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/screens/experiment/experiment.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';

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
            child: SizedBox(
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cheating',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '[insert cheating text]',
                    style: TextStyle(height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Anonymity',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '[insert anonymity text]',
                    style: TextStyle(height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Use of Data',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '[insert use of data text]',
                    style: TextStyle(height: 1.5),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('I agree bla bla bla'),
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
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
                  Offstage(
                      offstage: offstage, child: const SizedBox(height: 20)),
                  Offstage(
                    offstage: offstage,
                    child: Center(
                      child: ElevatedButton(
                        child: const Text('Next'),
                        onPressed: () async {
                          String uid = AuthService().getUser()!.uid;

                          await DatabaseService(uid: uid)
                              .addUserConsent(context, uid: uid);

                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Explanation(uid: widget.uid)));
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

class Explanation extends StatelessWidget {
  final String uid;
  const Explanation({required this.uid, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: SizedBox(
          width: 250,
          child: SingleChildScrollView(
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
                  '[insert text about the explanation of the experiment]',
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
        child: SizedBox(
          width: 250,
          child: SingleChildScrollView(
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
                  'Once you press \'Start\' the experiment will begin. You will not be able to pause once started. The experiment should take about [insert time here] minutes. You will have [insert time] minutes for each text and as long as you\'d like to answer each text. There are 3 texts in total. Good luck!',
                  style: TextStyle(height: 1.5),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                DropdownButton<int?>(
                  value: groupNumber,
                  onChanged: (int? number) {
                    setState(() => groupNumber = number);
                  },
                  items: <int>[1, 2, 3].map<DropdownMenuItem<int>>(
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
                        // TODO Create a new session
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => FirstText(uid: widget.uid)));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _popExperiment(BuildContext context) async {
  AuthService auth = AuthService();

  await DatabaseService(uid: auth.getUser()!.uid)
      .removeUserConsent(context, uid: auth.getUser()!.uid);

  await auth.deleteUser();
  Navigator.of(context).pop();
}
