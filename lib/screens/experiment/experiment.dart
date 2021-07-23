import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

class TimeIsUp extends StatefulWidget {
  final String uid;
  const TimeIsUp({required this.uid, Key? key}) : super(key: key);

  @override
  _TimeIsUpState createState() => _TimeIsUpState();
}

class _TimeIsUpState extends State<TimeIsUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}

class FirstText extends StatefulWidget {
  final String uid;
  const FirstText({required this.uid, Key? key}) : super(key: key);

  @override
  FirstTextState createState() => FirstTextState();
}

class FirstTextState extends State<FirstText> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}

class FirstQuiz extends StatefulWidget {
  final String uid;
  const FirstQuiz({required this.uid, Key? key}) : super(key: key);

  @override
  _FirstQuizState createState() => _FirstQuizState();
}

class _FirstQuizState extends State<FirstQuiz> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}

class SecondText extends StatefulWidget {
  final String uid;
  const SecondText({required this.uid, Key? key}) : super(key: key);

  @override
  _SecondTextState createState() => _SecondTextState();
}

class _SecondTextState extends State<SecondText> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}

class SecondQuiz extends StatefulWidget {
  final String uid;
  const SecondQuiz({required this.uid, Key? key}) : super(key: key);

  @override
  _SecondQuizState createState() => _SecondQuizState();
}

class _SecondQuizState extends State<SecondQuiz> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}

class ThirdText extends StatefulWidget {
  final String uid;
  const ThirdText({required this.uid, Key? key}) : super(key: key);

  @override
  _ThirdTextState createState() => _ThirdTextState();
}

class _ThirdTextState extends State<ThirdText> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}

class ThirdQuiz extends StatefulWidget {
  final String uid;
  const ThirdQuiz({required this.uid, Key? key}) : super(key: key);

  @override
  _ThirdQuizState createState() => _ThirdQuizState();
}

class _ThirdQuizState extends State<ThirdQuiz> with WidgetsBindingObserver {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(),
        ),
      ),
    );
  }
}
