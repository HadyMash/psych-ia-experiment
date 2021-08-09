import 'package:enum_to_string/enum_to_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ExperimentProgress {
  agreement,
  experimentInfo,
  areYouReady,
  firstText,
  firstQuiz,
  secondText,
  secondQuiz,
  thirdText,
  thirdQuiz,
  error,
}

String _key = 'progress';

Future setExperimentProgress(ExperimentProgress progress) async {
  try {
    var instance = await SharedPreferences.getInstance();
    await instance.setString(_key, EnumToString.convertToString(progress));
  } catch (e) {
    print(e.toString());
    return e;
  }
}

Future<ExperimentProgress?> getExperimentProgress() async {
  try {
    var instance = await SharedPreferences.getInstance();
    String progressString = instance.getString(_key) ?? 'error';
    ExperimentProgress? progress =
        EnumToString.fromString(ExperimentProgress.values, progressString);
    return progress;
  } catch (e) {
    print(e.toString());
  }
}
