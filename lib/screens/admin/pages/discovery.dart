import 'package:flutter/material.dart';
import 'package:reading_experiment/services/database.dart';

class Discovery extends StatefulWidget {
  const Discovery({Key? key}) : super(key: key);

  @override
  State<Discovery> createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  bool? isSwitched;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InfoService().discoveryStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          isSwitched = snapshot.data as bool;

          if (isSwitched == null) {
            return const Center(child: Text('An error has occured.'));
          } else {
            return Center(
              child: Switch(
                value: isSwitched!,
                onChanged: (val) => InfoService().changeDiscovery(val),
              ),
            );
          }
        }

        return const Center(child: Text('An error has occured.'));
      },
    );
  }
}
