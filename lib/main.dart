import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/screens/admin/admin_login.dart';
import 'package:reading_experiment/screens/admin/admin_panel.dart';
import 'package:reading_experiment/screens/experiment/intro.dart';
import 'package:reading_experiment/services/auth.dart';

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

  runApp(
    const MaterialApp(
      home: Home(),
    ),
  );
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final User? user = AuthService().getUser();

      if (user != null) {
        if (user.isAnonymous) {
          // go to experiment
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Agreement(uid: user.uid)));
        } else {
          // go to admin panel
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminPanel()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      body: Center(
        child: ElevatedButton(
          child: const Text('Get Started'),
          onPressed: () async {
            final AuthService _auth = AuthService();
            dynamic currentUser = _auth.getUser();
            if (currentUser != null) {
              await _auth.deleteUserAndData(uid: AuthService().getUser()!.uid);
            }

            dynamic result = await _auth.logInAnonymously();
            if (result is User) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Agreement(uid: result.uid.toString())));
            } else {
              _showToast(context, text: _auth.getError(result.toString()));
            }
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: height * 0.1,
        child: Center(
          child: ClickableText(
            text: 'Go to Admin Portal',
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdminLogin())),
          ),
        ),
      ),
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

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> with WidgetsBindingObserver {
  bool active = true;

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
    active = false;
    if (kIsWeb) {
      window.removeEventListener('focus', onFocus);
      window.removeEventListener('blur', onBlur);
    } else {
      WidgetsBinding.instance!.removeObserver(this);
    }
    super.dispose();
  }

  void onFocus(Event e) {
    if (active) {
      didChangeAppLifecycleState(AppLifecycleState.resumed);
    }
  }

  void onBlur(Event e) {
    if (active) {
      didChangeAppLifecycleState(AppLifecycleState.paused);
    }
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
