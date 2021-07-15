import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.1, horizontal: width * 0.2),
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
                const SizedBox(height: 20),
                const Text(
                  '[insert cheating text]',
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Anonymity',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                const Text(
                  '[insert anonymity text]',
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('I agree bla bla bla'),
                    SizedBox(width: 50),
                    Placeholder(
                      fallbackHeight: 10,
                      fallbackWidth: 10,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
