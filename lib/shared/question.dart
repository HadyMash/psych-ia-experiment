import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:reading_experiment/shared/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  final String name;
  final List<String> choices;
  final int quizNumber;
  final String? initialValue;
  const MultipleChoiceQuestion(
      {Key? key,
      required this.name,
      required this.choices,
      required this.quizNumber,
      this.initialValue})
      : super(key: key);

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  List<FormBuilderFieldOption<String?>> _options(List<String> choices) {
    var shuffledList = [...choices];
    shuffledList.shuffle();
    if (shuffledList.contains('All of the above')) {
      shuffledList.remove('All of the above');
      shuffledList.add('All of the above');
    }

    List<FormBuilderFieldOption<String?>> options = [];

    for (var choice in shuffledList) {
      options.add(FormBuilderFieldOption(value: choice, child: Text(choice)));
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 600,
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.name,
                  style: Theme.of(context).textTheme.headline6)),
          FormBuilderRadioGroup<String?>(
            name: widget.name,
            options: _options(widget.choices),
            initialValue: widget.initialValue,
            validator: FormBuilderValidators.required(context),
            orientation: OptionsOrientation.vertical,
            separator: const SizedBox(height: 50),
            onChanged: (String? val) async {
              if (val != null) {
                switch (widget.quizNumber) {
                  case 1:
                    AppData.quizOneAnswers[widget.name] = val;

                    var prefs = await SharedPreferences.getInstance();
                    String encodedMap = json.encode(AppData.quizOneAnswers);
                    await prefs.setString('quizOneAnswers', encodedMap);

                    break;
                  case 2:
                    AppData.quizTwoAnswers[widget.name] = val;

                    var prefs = await SharedPreferences.getInstance();
                    String encodedMap = json.encode(AppData.quizTwoAnswers);
                    await prefs.setString('quizTwoAnswers', encodedMap);

                    break;
                  default:
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
