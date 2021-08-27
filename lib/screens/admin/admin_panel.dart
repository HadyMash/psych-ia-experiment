import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reading_experiment/screens/admin/assets/side_navbar.dart';
import 'package:reading_experiment/screens/admin/pages/dashboard.dart';
import 'package:reading_experiment/screens/admin/pages/discovery.dart';
import 'package:reading_experiment/screens/admin/pages/participants.dart';
import 'package:reading_experiment/screens/admin/pages/unlock_requests.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SideNavigationBar(
              onChange: (int newIndex) => setState(() => index = newIndex)),
          // const SizedBox(width: 50),
          Expanded(
            child: IndexedStack(
              index: index,
              children: const [
                Dashboard(),
                Participants(),
                UnlockRequests(),
                Discovery(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
