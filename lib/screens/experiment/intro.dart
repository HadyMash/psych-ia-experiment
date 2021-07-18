import 'package:flutter/material.dart';
import 'package:reading_experiment/services/auth.dart';

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
            await AuthService().deleteUser();
            Navigator.of(context).pop();
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
                    child: const SelectableText('UEdZmw5sZkWtRay9Gkj6FNCljjn1'),
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
                Offstage(offstage: offstage, child: const SizedBox(height: 20)),
                Offstage(
                  offstage: offstage,
                  child: Center(
                    child: ElevatedButton(
                      child: const Text('Next'),
                      onPressed: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const Explanation())),
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

class Explanation extends StatelessWidget {
  const Explanation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction - Explanation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            await AuthService().deleteUser();
            Navigator.of(context).pop();
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
                    child: const SelectableText('UEdZmw5sZkWtRay9Gkj6FNCljjn1'),
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
                            builder: (context) => const AreYouReady())),
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

class AreYouReady extends StatelessWidget {
  const AreYouReady({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ready to Start'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () async {
            await AuthService().deleteUser();
            Navigator.of(context).pop();
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
                    child: const SelectableText('UEdZmw5sZkWtRay9Gkj6FNCljjn1'),
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
                Center(
                  child: ElevatedButton(
                    child: const Text('Start'),
                    onPressed: () {},
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
