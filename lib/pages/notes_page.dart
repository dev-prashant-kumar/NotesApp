import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotePageState();
}

class _NotePageState extends State<NotesPage> {
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    readNotes();
  }

  //create note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<NoteDatabase>().addNote(textController.text);
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  //read notes
  void readNotes() {
    context.watch<NoteDatabase>().fetchNotes();
  }

  //update notes
  void updateNotes(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Note"),
        content: TextField(controller: textController),
        actions: [
          MaterialButton(onPressed: (){
            context.read<NoteDatabase>().updateNote(note.id,textController.text);
            textController.clear();
            Navigator.pop(context);
          },
          child: const Text("Update"),
          )
        ],
      ),
    );
  }

  //detele notes
  void deleteNote(int id){
    context.read<NoteDatabase>().deleteNotes(id);
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          final note = currentNotes[index];
          return ListTile(title: Text(note.text),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(onPressed: () => updateNotes(note),
               icon: const Icon(Icons.edit),
               ),
               IconButton(onPressed: () => deleteNote(note.id),
               icon: const Icon(Icons.delete),
               ),
            ],
          ),
          );
        },
      ),
    );
  }
}
