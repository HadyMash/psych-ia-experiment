import 'package:flutter/material.dart';
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

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
    return Container();
  }
}

// class Test extends StatefulWidget {
//   const Test({Key? key}) : super(key: key);

//   @override
//   _TestState createState() => _TestState();
// }

// class _TestState extends State<Test> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     if (kIsWeb) {
//       window.addEventListener('visibilitychange', onVisibilityChange);
//     } else {
//       WidgetsBinding.instance!.addObserver(this);
//     }
//   }

//   @override
//   void dispose() {
//     if (kIsWeb) {
//       window.removeEventListener('visibilitychange', onVisibilityChange);
//     } else {
//       WidgetsBinding.instance!.removeObserver(this);
//     }
//     super.dispose();
//   }

//   void onVisibilityChange(Event e) {
//     String visibility = document.visibilityState;
//     if (visibility == 'visible') {
//       didChangeAppLifecycleState(AppLifecycleState.resumed);
//     } else if (visibility == 'hidden') {
//       didChangeAppLifecycleState(AppLifecycleState.paused);
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print(state);
//     setState(() => text = 'you cheated.');
//   }

//   String text = 'Hello';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Test'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text(text),
//       ),
//     );
//   }
// }
