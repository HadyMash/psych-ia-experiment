import 'package:flutter/material.dart';
import 'package:reading_experiment/services/auth.dart';
import 'package:reading_experiment/services/database.dart';
import 'package:reading_experiment/shared/note_data.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<Widget> _buildNotes(List<String> notes) {
    var widgets = <Widget>[];

    notes.forEach((element) {
      widgets.add(Text(element));
    });
    return widgets;
  }

  final stream = DatabaseService(uid: AuthService().getUser()!.uid).notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Notes'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<NoteData>?>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data != null) {
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('Notes are empty'));
              }
            }
            return SingleChildScrollView(
              child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    (snapshot.data as List<NoteData>)[index].isExpanded =
                        !isExpanded;
                  });
                },
                children: snapshot.data!.map<ExpansionPanel>((NoteData note) {
                  return ExpansionPanel(
                    headerBuilder: (context, bool isExpanded) => ListTile(
                      title: Text(note.id),
                    ),
                    body: ListTile(
                      title: Text(note.id),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          note.author == null
                              ? Container()
                              : Text('Author: ${note.author}'),
                          note.kick == null
                              ? Container()
                              : Text('Kick: ${note.kick}'),
                          note.kickReason == null
                              ? Container()
                              : Text('Kick Reason: ${note.kickReason}'),
                          note.notes == null
                              ? Container()
                              : const Text('Notes:'),
                          note.notes == null
                              ? Container()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: _buildNotes(note.notes!),
                                )
                        ],
                      ),
                    ),
                    isExpanded: note.isExpanded,
                  );
                }).toList(),
              ),
            );
          }),
    );
  }
}
