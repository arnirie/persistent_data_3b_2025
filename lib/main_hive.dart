import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
  late Box box;
  final noteCtrl = TextEditingController();
  List notes = [];

  void initBox() async {
    box = await Hive.openBox('notes');
    loadBox();
  }

  void loadBox() async {
    notes = box.values.toList();
    setState(() {});
    print(notes);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //open box
    initBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (_, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                doDelete(index);
              },
              child: Card(
                child: ListTile(
                  title: Text(notes.elementAt(index)),
                ),
              ),
            );
          },
          itemCount: notes.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddNote,
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddNote() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('Add Note'),
            content: TextField(
              controller: noteCtrl,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton(onPressed: doAdd, child: const Text('Add'))
            ],
          );
        });
  }

  void doAdd() {
    //add to box
    box.add(noteCtrl.text);
    Navigator.of(context).pop();
    noteCtrl.clear();
    loadBox();
    print('added note');
  }

  void doDelete(int i) {
    //delete in the box
    box.deleteAt(i);
    loadBox();
  }
}

// class NotesScreen extends StatelessWidget {
//   const NotesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           ElevatedButton(
//               onPressed: () async {
//                 var box = await Hive.openBox('items');
//                 // box.put('name', 'arni');
//                 box.add('tamayo');
//                 print('saved');
//               },
//               child: Text('open box')),
//           ElevatedButton(
//               onPressed: () async {
//                 var box = await Hive.openBox('items');
//                 var item = box.get(0);
//                 print(item);
//               },
//               child: Text('get name')),
//         ],
//       ),
//     );
//   }
// }
