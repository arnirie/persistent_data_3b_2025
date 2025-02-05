import 'package:flutter/material.dart';
import 'package:persistent_data/car.dart';
import 'package:persistent_data/note.dart';
import 'package:realm/realm.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Realm realm;
  late RealmResults<Note> notes;

  final titleCtrl = TextEditingController();
  final contentCtrl = TextEditingController();

  void loadNotes() {
    notes = realm.all<Note>();
    setState(() {});
  }

  void initRealm() {
    var config = Configuration.local([Note.schema]);
    realm = Realm(config);
    loadNotes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRealm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView.builder(
        itemBuilder: (_, index) {
          var note = notes[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (_) {
              doDelete(note);
            },
            child: Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                trailing: Text(note.date.toString()),
              ),
            ),
          );
        },
        itemCount: notes.length,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void showAddDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              ElevatedButton(
                onPressed: doAdd,
                child: const Text('Add'),
              ),
            ],
            title: const Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                ),
                TextField(
                  controller: contentCtrl,
                ),
              ],
            ),
          );
        });
  }

  void doAdd() {
    realm.write(() {
      var note = Note(titleCtrl.text, contentCtrl.text, date: DateTime.now());

      realm.add(note);
    });
    print('added');
    Navigator.of(context).pop();
    loadNotes();
  }

  void doDelete(Note n) {
    realm.write(() {
      realm.delete(n);
    });
    loadNotes();
  }
}
