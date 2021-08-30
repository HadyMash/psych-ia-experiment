import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/text_data.dart';

class EditTexts extends StatefulWidget {
  const EditTexts({Key? key}) : super(key: key);

  @override
  _EditTextsState createState() => _EditTextsState();
}

class _EditTextsState extends State<EditTexts> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final Future<TextData?> textFuture;

  late final TextEditingController textOneController;
  late final TextEditingController textTwoController;

  @override
  void initState() {
    super.initState();
    textFuture = TextService().getTexts(context);
    textFuture.then((textData) {
      if (textData != null) {
        textOneController = TextEditingController(text: textData.firstText);
        textTwoController = TextEditingController(text: textData.secondText);
      }
    });
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<TextData?>(
        future: textFuture,
        builder: (context, future) {
          if (future.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (future.hasData) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text('Text 1'),
                                    const SizedBox(height: 30),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      clipBehavior: Clip.hardEdge,
                                      child: const TabBar(
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.grey,
                                        indicatorColor: Colors.blue,
                                        indicatorWeight: 4,
                                        tabs: [
                                          Tab(
                                            child: Text('Edit'),
                                          ),
                                          Tab(
                                            child: Text('Preview'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          TextFormField(
                                            controller: textOneController,
                                            onChanged: (val) => setState(() {}),
                                            onFieldSubmitted: (val) =>
                                                setState(() {}),
                                            maxLines: null,
                                            expands: true,
                                            textAlign: TextAlign.start,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            validator: (val) =>
                                                (val ?? '').isEmpty
                                                    ? 'Form cannot be empty'
                                                    : null,
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey[300],
                                              filled: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "Lorem ipsum",
                                            ),
                                          ),
                                          Markdown(
                                            data: textOneController.text,
                                            selectable: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: DefaultTabController(
                                length: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text('Text 2'),
                                    const SizedBox(height: 30),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      clipBehavior: Clip.hardEdge,
                                      child: const TabBar(
                                        labelColor: Colors.black,
                                        unselectedLabelColor: Colors.grey,
                                        indicatorColor: Colors.blue,
                                        indicatorWeight: 4,
                                        tabs: [
                                          Tab(
                                            child: Text('Edit'),
                                          ),
                                          Tab(
                                            child: Text('Preview'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          TextFormField(
                                            controller: textTwoController,
                                            onChanged: (val) => setState(() {}),
                                            onFieldSubmitted: (val) =>
                                                setState(() {}),
                                            maxLines: null,
                                            expands: true,
                                            textAlign: TextAlign.start,
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            validator: (val) =>
                                                (val ?? '').isEmpty
                                                    ? 'Form cannot be empty'
                                                    : null,
                                            decoration: InputDecoration(
                                              fillColor: Colors.grey[300],
                                              filled: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                              hintText: "Lorem ipsum",
                                            ),
                                          ),
                                          Markdown(
                                            data: textTwoController.text,
                                            selectable: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState != null) {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                content:
                                    Center(child: CircularProgressIndicator()),
                              );
                            },
                          );
                          var result = await TextService().updateTexts(
                              textOneController.text, textTwoController.text);
                          Navigator.of(context).pop();
                          if (result == null) {
                            void _showToast(BuildContext context, String text) {
                              late FToast fToast;
                              fToast = FToast();
                              fToast.init(context);

                              Widget toast = Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
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
                                    Icon(Icons.check_circle_rounded,
                                        color: Colors.green[700]),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(
                                      text,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              );

                              fToast.showToast(
                                child: toast,
                                gravity: ToastGravity.TOP,
                                toastDuration: const Duration(seconds: 3),
                              );
                            }

                            _showToast(context, 'Texts successfully updated');
                          } else {
                            _showErrorToast(BuildContext context,
                                {required String text}) {
                              late FToast fToast;

                              fToast = FToast();
                              fToast.init(context);

                              Widget toast = Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
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
                                    Icon(Icons.error_rounded,
                                        color: Colors.red[700]),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(text.toString(),
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                ),
                              );

                              fToast.showToast(
                                child: toast,
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: const Duration(seconds: 6),
                              );
                            }

                            _showErrorToast(context,
                                text:
                                    'Error updating texts, please try again.\nError: ${result.toString()}');
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('An error has occured'));
        },
      ),
    );
  }
}

class TextEditor extends StatefulWidget {
  const TextEditor({Key? key}) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
