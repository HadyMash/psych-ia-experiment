import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:reading_experiment/screens/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
      home: Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      body: Center(
        child: ElevatedButton(
          child: const Text('Get Started'),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Agreement())),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: height * 0.1,
        child: const Center(
          child: ClickableText('Go to Admin Portal'),
        ),
      ),
    );
  }
}

class ClickableText extends StatefulWidget {
  final String text;

  const ClickableText(this.text, {Key? key}) : super(key: key);

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
          onTap: () => print('admin portal'),
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

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      window.addEventListener('focus', onFocus);
      window.addEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.addObserver(this);
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      window.removeEventListener('focus', onFocus);
      window.removeEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.removeObserver(this);
    }
    super.dispose();
  }

  void onFocus(Event e) {
    didChangeAppLifecycleState(AppLifecycleState.resumed);
  }

  void onBlur(Event e) {
    didChangeAppLifecycleState(AppLifecycleState.paused);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    text = 'locked out';
  }

  String text = 'Hello';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}
