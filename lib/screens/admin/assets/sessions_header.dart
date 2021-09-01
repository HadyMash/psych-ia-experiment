import 'package:flutter/material.dart';

class SessionsHeader extends StatelessWidget {
  const SessionsHeader({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Flexible(flex: 3, child: Center(child: Text('Name'))),
        Flexible(
          flex: 4,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 0.2 * width,
                  child: const Center(child: Text('Progress (%)')),
                ),
                const SizedBox(width: 40),
                const SizedBox(
                  width: 100,
                  child: Center(child: Text('Screen')),
                ),
              ],
            ),
          ),
        ),
        const Flexible(flex: 1, child: Center(child: Text('Group'))),
        const Flexible(flex: 1, child: Center(child: Text('Lock Outs'))),
        const Flexible(flex: 1, child: Center(child: Text('Kick'))),
        const Flexible(flex: 1, child: Center(child: Text('Notes'))),
      ],
    );
  }
}
