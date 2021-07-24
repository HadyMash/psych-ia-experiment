import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reading_experiment/screens/admin/side_navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: const [
          SideNavigationBar(),
        ],
      ),
    );
  }
}
