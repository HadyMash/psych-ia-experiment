import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:reading_experiment/screens/experiment/exit_experiment.dart';
import 'package:reading_experiment/screens/experiment/intro.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/data.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';
import 'package:reading_experiment/shared/text_data.dart';

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

class Experiment extends StatelessWidget {
  final Widget? page;
  const Experiment([this.page, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DatabaseService(uid: AuthService().getUser()!.uid)
        .userKickStream
        .listen((note) async {
      if (note != null) {
        if (note.kick == true) {
          showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (context) {
              bool loading = false;
              return StatefulBuilder(builder: (context, setState) {
                return !loading
                    ? AlertDialog(
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
                              'You have been kicked',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 20),
                            RichText(
                                text: TextSpan(children: <TextSpan>[
                              const TextSpan(
                                text: 'Kick Reason: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: note.kickReason),
                            ])),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              child: const Text('Ok'),
                              onPressed: () async {
                                setState(() => loading = true);
                                await AuthService().deleteUserAndData(
                                    uid: AuthService().getUser()!.uid);
                                AppData.mainNavKey.currentState!
                                    .popUntil((route) => route.isFirst);
                              },
                            ),
                          ],
                        ),
                      )
                    : const Center(child: CircularProgressIndicator());
              });
            },
          );
        }
      }
    });

    return Navigator(
      key: AppData.experimentNavKey,
      // initialRoute: '/Dashboard',
      onGenerateRoute: (RouteSettings route) {
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page ?? Agreement(uid: AuthService().getUser()!.uid);
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
        );
      },
    );
  }
}

class TimeIsUp extends StatefulWidget {
  final String uid;
  final int textNumber;

  const TimeIsUp({required this.uid, required this.textNumber, Key? key})
      : super(key: key);

  @override
  _TimeIsUpState createState() => _TimeIsUpState();
}

class _TimeIsUpState extends State<TimeIsUp> {
  @override
  void initState() {
    super.initState();
    switch (widget.textNumber) {
      case 1:
        print('first quiz');
        setExperimentProgress(ExperimentProgress.firstQuiz);
        break;
      case 2:
        print('second quiz');
        setExperimentProgress(ExperimentProgress.secondQuiz);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Is Up'),
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
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Time is up. Press the button below when you are ready to start the quiz.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Take Text ${widget.textNumber} quiz'),
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => (widget.textNumber == 1
                            ? FirstQuiz(uid: widget.uid)
                            : SecondQuiz(uid: widget.uid)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const ExitExperiment(),
        ],
      ),
    );
  }
}

// TODO use shared preferences to save the time left
class ExperimentAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String uid;
  final void Function() onTimeFinish;
  final Duration? duration;
  const ExperimentAppBar({
    Key? key,
    required this.title,
    required this.uid,
    required this.onTimeFinish,
    this.duration,
  }) : super(key: key);

  @override
  _ExperimentAppBarState createState() => _ExperimentAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _ExperimentAppBarState extends State<ExperimentAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    if (controller.duration != null) {
      Duration duration = controller.duration! * controller.value;
      return '${((controller.duration!.inSeconds - duration.inSeconds) ~/ 60)}:${((controller.duration!.inSeconds - duration.inSeconds) % 60).toString().padLeft(2, '0')}';
    } else {
      return '_:__';
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(minutes: 3),
    );

    controller.addStatusListener(
      (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          widget.onTimeFinish();
        }
      },
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return AppBar(
          title: Text(widget.title),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leadingWidth: 80,
          leading: Center(
            child: Text(
              timerString,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6.0),
            child: SizedBox(
              width: width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  color: Colors.amber[700],
                  height: 6.0,
                  width: width * controller.value,
                ),
              ),
            ),
          ),
        );
      },
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

    setExperimentProgress(ExperimentProgress.firstText);

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
    TextData? texts = Provider.of<TextData?>(context);

    return Scaffold(
      appBar: ExperimentAppBar(
        title: 'First Text',
        uid: widget.uid,
        onTimeFinish: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TimeIsUp(
                uid: widget.uid,
                textNumber: 1,
              ),
            ),
          );
        },
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: MarkdownBody(
                  data: texts?.firstText ??
                      'Error Getting Text. Please exit the experiment and try again.',
                  selectable: false,
                  styleSheet: MarkdownStyleSheet(
                    strong: TextStyle(
                      fontWeight: (AppData.groupNumber ?? 1) == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const ExitExperiment(),
        ],
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
      appBar: ExperimentAppBar(
        title: 'First Quiz',
        uid: widget.uid,
        onTimeFinish: () {},
      ),
      body: Stack(
        children: const [
          Center(
            child: SingleChildScrollView(
              child: Center(),
            ),
          ),
          ExitExperiment(),
        ],
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

    setExperimentProgress(ExperimentProgress.secondText);

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
    TextData? texts = Provider.of<TextData?>(context);

    return Scaffold(
      appBar: ExperimentAppBar(
        title: 'Second Text',
        uid: widget.uid,
        onTimeFinish: () {},
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: MarkdownBody(
                  data: texts?.secondText ??
                      'Error Getting Text. Please exit the experiment and try again.',
                  selectable: false,
                  styleSheet: MarkdownStyleSheet(
                    strong: TextStyle(
                      fontWeight: (AppData.groupNumber ?? 1) == 1
                          ? FontWeight.normal
                          : FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const ExitExperiment(),
        ],
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
      appBar: ExperimentAppBar(
        title: 'Second Quiz',
        uid: widget.uid,
        onTimeFinish: () {},
      ),
      body: Stack(
        children: const [
          Center(
            child: SingleChildScrollView(
              child: Center(),
            ),
          ),
          ExitExperiment(),
        ],
      ),
    );
  }
}
