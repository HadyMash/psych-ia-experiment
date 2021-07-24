import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool navBarExpanded = false;
  double closedNavBarWidth = 65,
      openedNavBarWidth = 250,
      navBarWidth = 65,
      itemHeight = 65;
  int selectedIndex = 0;

  Color navBarShadowHoverColor = Colors.black.withOpacity(0.4),
      navBarShadowColor = Colors.black.withOpacity(0.15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          MouseRegion(
            onEnter: (_) =>
                setState(() => navBarShadowColor = navBarShadowHoverColor),
            onExit: (_) => setState(
                () => navBarShadowColor = Colors.black.withOpacity(0.15)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              height: double.infinity,
              width: navBarWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: navBarShadowColor,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        PageIcon.tooltip(
                          label: 'Unlock Requests',
                          tooltip:
                              'Unlock Requests - Requests made by participants to unlock their portal.\nThe lock is caused by the experiment tab or browser losing focus.',
                          selected: selectedIndex == 0,
                          expanded: navBarExpanded,
                          icon: Icons.lock_open_rounded,
                          height: itemHeight,
                          width: navBarWidth,
                          onTap: () => selectedIndex = 0,
                        ),
                      ],
                    ),
                    const Spacer(),
                    RotatedBox(
                      quarterTurns: -1,
                      child: ExpandIcon(
                        isExpanded: navBarExpanded,
                        onPressed: (val) => setState(
                          () {
                            navBarExpanded = !val;
                            navBarWidth = navBarExpanded
                                ? openedNavBarWidth
                                : closedNavBarWidth;
                          },
                        ),
                        size: 34,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PageIcon.tooltip(
                      icon: Icons.logout_rounded,
                      tooltip: 'Log Out - Exit this portal',
                      selected: false,
                      expanded: navBarExpanded,
                      label: 'Log Out',
                      height: itemHeight,
                      width: navBarWidth,
                      onTap: () {
                        // TODO log Out
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIcon extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final bool selected;
  final bool expanded;
  final String label;
  final String? tooltip;
  final double height, width;

  final Color selectedColor, unselectedColor;

  PageIcon({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.selected,
    required this.expanded,
    required this.label,
    required this.height,
    required this.width,
  })  : selectedColor = Colors.blue,
        unselectedColor = Colors.grey[600]!,
        tooltip = null,
        super(key: key);

  PageIcon.tooltip({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.selected,
    required this.expanded,
    required this.label,
    required this.tooltip,
    required this.height,
    required this.width,
  })  : selectedColor = Colors.blue,
        unselectedColor = Colors.grey[600]!,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body = SizedBox(
      height: height,
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 34,
                color: selected ? selectedColor : unselectedColor,
              ),
              SizedBox(width: expanded ? 10 : 0),
              expanded
                  ? Text(
                      label,
                      style: TextStyle(
                        color: selected ? selectedColor : unselectedColor,
                        fontSize: 20,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    )
                  : const SizedBox(height: 0, width: 0),
            ],
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Tooltip(
          message: tooltip!,
          textStyle: const TextStyle(fontSize: 14, color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: body,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: body,
      );
    }
  }
}
