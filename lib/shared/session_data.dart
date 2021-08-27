import 'package:reading_experiment/shared/experiment_progress.dart';

class SessionData {
  final String uid;
  final ExperimentProgress progress;
  final int lockOuts;
  final int? group;

  SessionData({
    required this.uid,
    required this.progress,
    required this.lockOuts,
    this.group,
  });

  final Map<ExperimentProgress, String> progressToName =
      <ExperimentProgress, String>{
    ExperimentProgress.agreement: 'Agreement Page',
    ExperimentProgress.experimentInfo: 'Experiment Info',
    ExperimentProgress.areYouReady: 'Start Screen',
    ExperimentProgress.firstText: 'First Text',
    ExperimentProgress.firstQuiz: 'First Quiz',
    ExperimentProgress.secondText: 'Second Text',
    ExperimentProgress.secondQuiz: 'Second Quiz',
    ExperimentProgress.thirdText: 'Third Text',
    ExperimentProgress.thirdQuiz: 'Third Quiz',
  };
}
