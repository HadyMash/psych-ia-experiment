import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: const Center(
        child: SingleChildScrollView(
          child: Text(''),
        ),
      ),
    );
  }
}
