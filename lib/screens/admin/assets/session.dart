import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reading_experiment/shared/experiment_progress.dart';

class Session extends StatefulWidget {
  final String uid;
  final ExperimentProgress progress;
  final int lockOuts;
  final int? group;
  const Session(
      {required this.uid,
      required this.progress,
      required this.lockOuts,
      this.group,
      Key? key})
      : super(key: key);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  final Map<ExperimentProgress, double> progressPercentage = {
    ExperimentProgress.agreement: (1 / 8) * 1,
    ExperimentProgress.experimentInfo: (1 / 8) * 2,
    ExperimentProgress.areYouReady: (1 / 8) * 3,
    ExperimentProgress.firstText: (1 / 8) * 4,
    ExperimentProgress.firstQuiz: (1 / 8) * 5,
    ExperimentProgress.secondText: (1 / 8) * 6,
    ExperimentProgress.secondQuiz: (1 / 8) * 7,
    ExperimentProgress.finish: (1 / 8) * 8,
    ExperimentProgress.error: 0.0,
  };

  final Map<ExperimentProgress, String> progressName = {
    ExperimentProgress.agreement: 'Agreement',
    ExperimentProgress.experimentInfo: 'Experiment Info',
    ExperimentProgress.areYouReady: 'Ready Screen',
    ExperimentProgress.firstText: 'First Text',
    ExperimentProgress.firstQuiz: 'First Quiz',
    ExperimentProgress.secondText: 'Second Text',
    ExperimentProgress.secondQuiz: 'Second Quiz',
    ExperimentProgress.error: 'Error',
  };

  final Duration progressAnimDuration = const Duration(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // name/uid
          Flexible(flex: 3, child: Center(child: Text(widget.uid))),
          // Progress
          Flexible(
            flex: 4,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Progress bar
                  Stack(
                    children: [
                      // Area indicator
                      Container(
                        height: 25,
                        width: 0.2 * width,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // current progress
                      AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: progressAnimDuration,
                        height: 25,
                        width: (progressPercentage[widget.progress] ?? 0) *
                            width *
                            0.2,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  // progress text
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: Text(progressName[widget.progress] ?? 'Error'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Group number
          Flexible(
            flex: 1,
            child: Center(
              child: Text(widget.group != null ? widget.group.toString() : '–'),
            ),
          ),
          // Lock Outs
          Flexible(
            flex: 1,
            child: Center(
              child: Text(widget.lockOuts.toString()),
            ),
          ),
          // Controls
          const Flexible(
            flex: 1,
            child: Center(child: KickUser()),
          ),
          const Flexible(
            flex: 1,
            child: Center(child: SessionNotes()),
          ),
        ],
      ),
    );
  }
}

class KickUser extends StatefulWidget {
  const KickUser({Key? key}) : super(key: key);

  @override
  _KickUserState createState() => _KickUserState();
}

class _KickUserState extends State<KickUser> {
  Color color = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          CupertinoIcons.xmark,
          color: Colors.red[700],
        ),
      ),
    );
  }
}

class SessionNotes extends StatefulWidget {
  const SessionNotes({Key? key}) : super(key: key);

  @override
  _SessionNotesState createState() => _SessionNotesState();
}

class _SessionNotesState extends State<SessionNotes> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(5),
      child: const Padding(
        padding: EdgeInsets.all(5),
        child: Icon(
          Icons.note_alt_rounded,
          color: Colors.black,
        ),
      ),
    );
  }
}
