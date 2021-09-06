import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/services/auth.dart';

void _showToast(BuildContext context, {required String text}) {
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
        Icon(Icons.error_rounded, color: Colors.red[700]),
        const SizedBox(
          width: 12.0,
        ),
        Text(text.toString(), style: const TextStyle(color: Colors.white)),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 6),
  );
}

class SideNavigationBar extends StatefulWidget {
  final void Function(int) onChange;
  const SideNavigationBar({required this.onChange, Key? key}) : super(key: key);

  @override
  _SideNavigationBarState createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  bool navBarExpanded = false;
  double closedNavBarWidth = 65,
      openedNavBarWidth = 250,
      navBarWidth = 65,
      itemHeight = 65;
  int selectedIndex = 0;

  Color navBarShadowHoverColor = Colors.black.withOpacity(0.4),
      // navBarShadowColor = Colors.transparent;
      navBarShadowColor = Colors.black.withOpacity(0.1);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) =>
          setState(() => navBarShadowColor = navBarShadowHoverColor),
      onExit: (_) => setState(
          // () => navBarShadowColor = Colors.transparent),
          () => navBarShadowColor = Colors.black.withOpacity(0.1)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        height: double.infinity,
        width: navBarWidth,
        clipBehavior: Clip.hardEdge,
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
                    label: 'Dashboard',
                    tooltip: 'Dashboard - The main page',
                    selected: selectedIndex == 0,
                    expanded: navBarExpanded,
                    icon: Icons.dashboard_rounded,
                    height: itemHeight,
                    width: navBarWidth,
                    onTap: () {
                      setState(() => selectedIndex = 0);
                      widget.onChange(selectedIndex);
                    },
                  ),
                  PageIcon.tooltip(
                    label: 'Participants',
                    tooltip: 'Participants - Currently active participants',
                    selected: selectedIndex == 1,
                    expanded: navBarExpanded,
                    icon: Icons.people_rounded,
                    height: itemHeight,
                    width: navBarWidth,
                    onTap: () {
                      setState(() => selectedIndex = 1);
                      widget.onChange(selectedIndex);
                    },
                  ),
                  PageIcon.tooltip(
                    label: 'Unlock Requests',
                    tooltip:
                        'Unlock Requests - Requests made by participants to unlock their portal.\nThe lock is caused by the experiment tab or browser losing focus.',
                    selected: selectedIndex == 2,
                    expanded: navBarExpanded,
                    icon: Icons.lock_open_rounded,
                    height: itemHeight,
                    width: navBarWidth,
                    onTap: () {
                      setState(() => selectedIndex = 2);
                      widget.onChange(selectedIndex);
                    },
                  ),
                  PageIcon.tooltip(
                    label: 'Text Editor',
                    tooltip:
                        'Text Editor - Edit the texts displayed to the participants',
                    selected: selectedIndex == 3,
                    expanded: navBarExpanded,
                    icon: Icons.edit_rounded,
                    height: itemHeight,
                    width: navBarWidth,
                    onTap: () {
                      setState(() => selectedIndex = 3);
                      widget.onChange(selectedIndex);
                    },
                  ),
                  PageIcon.tooltip(
                    label: 'Discovery',
                    tooltip:
                        'Discovery - Toggle whether particpants are able to enter the experiment.',
                    selected: selectedIndex == 4,
                    expanded: navBarExpanded,
                    icon: Icons.search_rounded,
                    height: itemHeight,
                    width: navBarWidth,
                    onTap: () {
                      setState(() => selectedIndex = 4);
                      widget.onChange(selectedIndex);
                    },
                  ),
                  PageIcon.tooltip(
                    label: 'Notes',
                    tooltip: 'Notes - View User Notes',
                    selected: selectedIndex == 5,
                    expanded: navBarExpanded,
                    icon: Icons.note_alt_rounded,
                    height: itemHeight,
                    width: navBarWidth,
                    onTap: () {
                      setState(() => selectedIndex = 5);
                      widget.onChange(selectedIndex);
                    },
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
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
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
                              'Log Out',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Are you sure you want to log out?',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                var _auth = AuthService();
                                dynamic result = await _auth.adminLogOut();

                                if (result == null) {
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                } else {
                                  _showToast(context,
                                      text: _auth.getError(result.toString()));
                                }
                              },
                              child: const Text('Log Out'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Tooltip(
          message: tooltip!,
          textStyle: const TextStyle(fontSize: 14, color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: body,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: body,
      );
    }
  }
}
